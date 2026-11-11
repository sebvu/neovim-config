vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^19.0.0"),
	},
})

local sessions_dir = vim.fn.expand("~/notes/agent-sessions")
vim.fn.mkdir(sessions_dir, "p")

-- ---------------------------------------------------------------------------
-- Hardened file_search tool ---------------------------------------------------
-- The built-in schema lets the LLM omit `query` or send JSON `null`. That decodes
-- to vim.NIL, gets rendered back into the history as `v:null`, and the model then
-- copies the token forever. This version makes `query` a required non-empty
-- string and coerces anything nullish to `**/*` so a bad call degrades instead of
-- erroring with "Query parameter is required and cannot be empty".
local NULLISH = { "", "null", "v:null", "nil", "vim.NIL", "undefined" }

---Coerce whatever the LLM sent into a non-empty glob
---@param args table|nil
---@return string query
---@return string? warning
local function normalise_query(args)
	local q = args and args.query
	if q == nil or q == vim.NIL or type(q) ~= "string" then
		return "**/*", ("query was %s; fell back to **/*"):format(tostring(q))
	end
	q = vim.trim(q)
	if vim.list_contains(NULLISH, q) then
		return "**/*", ("query was '%s'; fell back to **/*"):format(q)
	end
	return q
end

local file_search = {
	name = "file_search",
	description = "Search for files in the current working directory by glob pattern",
	opts = { max_results = 500, require_approval_before = false },
	schema = {
		type = "function",
		["function"] = {
			name = "file_search",
			description = table.concat({
				"Search for files in the current working directory by glob pattern.",
				"`query` is ALWAYS a non-empty string. Use '**/*' to list everything.",
				"Never send null, v:null, nil or an empty string.",
			}, " "),
			parameters = {
				type = "object",
				properties = {
					query = {
						type = "string",
						minLength = 1,
						description = "A glob relative to the working directory, e.g. '**/*.lua' or 'src/**'. Use '**/*' for everything.",
					},
				},
				required = { "query" },
				additionalProperties = false,
			},
			strict = true,
		},
	},
	cmds = {
		---@param self CodeCompanion.Tools.Tool
		---@param args table|nil
		---@return { status: "success"|"error", data: string }
		function(self, args)
			local query, warning = normalise_query(args)

			local ok, matches = pcall(vim.fn.glob, query, false, true)
			if not ok or type(matches) ~= "table" then
				return { status = "error", data = ("Invalid glob: %s. Use '**/*' instead."):format(query) }
			end

			local limit = (self.opts and self.opts.max_results) or 500
			local files, seen = {}, {}
			for _, path in ipairs(matches) do
				local p = path:gsub("^%./", ""):gsub("/$", "")
				if not seen[p] and vim.fn.filereadable(p) == 1 then
					seen[p] = true
					files[#files + 1] = p
					if #files >= limit then
						break
					end
				end
			end

			table.sort(files)

			if #files == 0 then
				return {
					status = "error",
					data = ("No files matched '%s'%s. Try a broader glob such as '**/*'."):format(
						query,
						warning and (" (" .. warning .. ")") or ""
					),
				}
			end

			local data = table.concat(files, "\n")
			if warning then
				data = data .. "\n\nNote: " .. warning
			end
			return { status = "success", data = data }
		end,
	},
	output = {
		---@param self CodeCompanion.Tools.Tool
		---@param stdout table
		---@param meta { tools: CodeCompanion.Tools, cmd: table }
		success = function(self, stdout, meta)
			local query = (self.args and self.args.query) or "**/*"
			return meta.tools.chat:add_tool_output(
				self,
				tostring(stdout[1]),
				("%s (%d files)"):format(query, vim.tbl_count(stdout))
			)
		end,
		---@param self CodeCompanion.Tools.Tool
		---@param stderr table
		---@param meta { tools: CodeCompanion.Tools, cmd: table }
		error = function(self, stderr, meta)
			return meta.tools.chat:add_tool_output(self, tostring(stderr[1]))
		end,
	},
}
-- ---------------------------------------------------------------------------

require("codecompanion").setup({
	adapters = {
		http = {
			opts = { show_presets = false },
			openwebui = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					formatted_name = "Open WebUI",
					env = {
						url = "https://slop.blatant-lizardry.moe/openai",
						chat_url = "/chat/completions",
						models_endpoint = "/models",
						-- Called on each request, so rotating the key needs no restart.
						api_key = function()
							local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/.config/jester/secrets/slop.key"))
							if not ok or not lines then
								vim.notify_once("slop.key missing/unreadable", vim.log.levels.WARN)
								return ""
							end
							for _, line in ipairs(lines) do
								local trimmed = vim.trim(line)
								if trimmed ~= "" then
									return trimmed
								end
							end
							return ""
						end,
					},
					schema = {
						model = {
							default = "deepseek-ai/DeepSeek-V4.1-Flash-1017",
						},
					},
				})
			end,
		},
	},
	interactions = {
		chat = {
			adapter = "openwebui",
			opts = {
				system_prompt = function(ctx)
					return ctx.default_system_prompt
						.. [[

Tool arguments:
- `file_search` requires a non-empty string `query`. Use "**/*" to list everything.
- Never send null, v:null, nil or "" as a tool argument. Omit optional arguments you do not need.
]]
				end,
			},
			tools = {
				["file_search"] = {
					callback = function()
						return file_search
					end,
				},
			},
			sessions = {
				enabled = true,
				autosave = true,
				continuous_save = true,
				save_dir = sessions_dir,
			},
		},
		inline = { adapter = "openwebui" },
		cmd = { adapter = "openwebui" },
		background = { adapter = "openwebui" },
	},
})

vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Code Companion" })
vim.keymap.set("n", "<leader>gh", function()
	require("codecompanion").sessions()
end, { desc = "Resume agent session" })

-- State-change cues ---------------------------------------------------------
-- Two clips only: one while the agent is blocked on your approval, one when the
-- session is actually finished. Nothing plays while a request is merely in flight.

-- --NOTE: install mpv for windowless audio (pacman -S mpv / apt install mpv).
-- --NOTE: If it is absent the fallback is ffplay from ffmpeg in -nodisp mode,
-- --NOTE: which also opens no window, so no install is strictly required.
do
	local cues = {
		enabled = true,
		-- A "done" that lands while another round is already queued is a lie, so the
		-- finished cue waits this long and any new request cancels it.
		done_delay_ms = 700,
		volume = 35,
		clips = {
			approval = "~/media/agent/approval.mp3",
			done = "~/media/agent/done.mp3",
		},
	}

	---@return string[]|nil
	local function audio_command()
		if vim.fn.executable("mpv") == 1 then
			return {
				"mpv",
				"--no-video",
				"--audio-display=no",
				"--force-window=no",
				"--no-terminal",
				"--really-quiet",
				"--no-resume-playback",
				"--no-config",
				"--volume=" .. cues.volume,
			}
		end
		if vim.fn.executable("ffplay") == 1 then
			return {
				"ffplay",
				"-nodisp",
				"-autoexit",
				"-loglevel",
				"quiet",
				"-sn",
				"-volume",
				tostring(cues.volume),
			}
		end
	end

	local playing
	local function stop()
		if playing then
			pcall(playing.kill, playing, "sigterm")
			playing = nil
		end
	end

	---@param name "approval"|"done"
	local function play(name)
		if not cues.enabled then
			return
		end
		local cmd = audio_command()
		if not cmd then
			return
		end
		local path = vim.fn.expand(cues.clips[name] or "")
		if path == "" or vim.fn.filereadable(path) == 0 then
			return
		end
		-- One clip at a time: a later cue replaces the one still playing.
		stop()
		local ok, proc = pcall(vim.system, vim.list_extend(cmd, { path }), { detach = true })
		if ok then
			playing = proc
		end
	end

	local timer = vim.uv.new_timer()
	local function cancel_done()
		timer:stop()
	end
	local function schedule_done()
		cancel_done()
		timer:start(
			cues.done_delay_ms,
			0,
			vim.schedule_wrap(function()
				play("done")
			end)
		)
	end

	local group = vim.api.nvim_create_augroup("jester_codecompanion_cues", { clear = true })
	local function on(event, callback)
		vim.api.nvim_create_autocmd("User", { group = group, pattern = event, callback = callback })
	end

	-- In flight is never audible by itself, but it proves more output is coming.
	for _, event in ipairs({
		"CodeCompanionRequestStarted",
		"CodeCompanionChatSubmitted",
		"CodeCompanionToolStarted",
	}) do
		on(event, cancel_done)
	end

	-- Blocked on you: the only cue that interrupts.
	for _, event in ipairs({
		"CodeCompanionToolApprovalRequested",
		"CodeCompanionToolQuestionAsked",
		"CodeCompanionCLIApprovalRequested",
	}) do
		on(event, function()
			cancel_done()
			play("approval")
		end)
	end

	-- Each finished round schedules "done"; the delay collapses the rounds that are
	-- immediately followed by another (tool results feeding straight back in).
	for _, event in ipairs({
		"CodeCompanionRequestFinished",
		"CodeCompanionChatDone",
		"CodeCompanionInlineFinished",
	}) do
		on(event, schedule_done)
	end

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			cancel_done()
			stop()
			timer:close()
		end,
	})

	vim.api.nvim_create_user_command("CueToggle", function()
		cues.enabled = not cues.enabled
		if not cues.enabled then
			stop()
			cancel_done()
		end
		vim.notify("Agent cues " .. (cues.enabled and "on" or "off"))
	end, { desc = "Toggle agent cues" })

	vim.api.nvim_create_user_command("CueTest", function(args)
		local which = args.args ~= "" and args.args or "done"
		if not cues.clips[which] then
			vim.notify("Unknown cue: " .. which, vim.log.levels.WARN)
			return
		end
		play(which)
	end, {
		nargs = "?",
		desc = "Play an agent cue",
		complete = function()
			return { "approval", "done" }
		end,
	})
end
