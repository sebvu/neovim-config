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
		volume = 10,
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
