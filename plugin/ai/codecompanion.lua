-- deps
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
-- main package
vim.pack.add({
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^19.0.0"),
	},
})

require("codecompanion").setup({
	adapters = {
		http = {
			opts = {
				show_model_choices = false,
			},
			openwebui = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					formatted_name = "Open WebUI",
					env = {
						url = "https://slop.blatant-lizardry.moe/openai",
						chat_url = "/chat/completions",
						models_endpoint = "/models",
						-- called per request; an empty string keeps the request alive if the file is gone
						api_key = function()
							local path = vim.fn.expand("~/.config/jester/secrets/slop.key")
							if vim.fn.filereadable(path) == 0 then
								return ""
							end
							return vim.fn.readfile(path)[1] or ""
						end,
					},
					schema = {
						model = {
							default = "deepseek-ai/DeepSeek-V4.1-Flash-1017",
							choices = {},
							-- Token budget the context management triggers divide against: editing
							-- (0.65) replaces old tool results with placeholders around 42k,
							-- compaction (0.85) summarises the history around 56k. Exceeding the
							-- real limit ends the conversation outright.
							-- Not in the documented adapter schema (only meta.context_window is), so
							-- this needs checking against the box: too low forces needless
							-- compaction, too high overshoots. If it can't be confirmed, prefer
							-- absolute token triggers under interactions.chat.opts.context_management.
							context_window = 65536,
						},
					},
				})
			end,
		},
	},
	opts = {
		log_level = "ERROR",
	},
	interactions = {
		chat = {
			adapter = "openwebui",
			-- Transcripts land in the notes folder rather than stdpath("data") so they
			-- sit alongside everything else and can be grepped or attached with /file.
			sessions = {
				enabled = true,
				autosave = true,
				continuous_save = true,
				save_dir = (function()
					local dir = vim.fn.expand("~/notes/agent-sessions")
					vim.fn.mkdir(dir, "p")
					return dir
				end)(),
			},
			keymaps = {
				sessions = {
					modes = { n = "gh" },
					description = "Browse saved sessions",
					callback = function()
						require("codecompanion").sessions()
					end,
				},
				save = {
					modes = { n = "gS" },
					description = "Save session now",
					callback = function(chat)
						chat:save()
					end,
				},
			},
			tools = {
				-- Always available, otherwise the LLM has to be told about it per message.
				opts = {
					default_tools = { "file_exists" },
				},
				-- Lets the LLM cheaply test a path before spending an approval on
				-- read_file. A miss returns the parent's neighbouring entries so it
				-- can correct itself instead of guessing again. Read-only, so it runs
				-- without asking, like the built-in file_search.
				file_exists = {
					name = "file_exists",
					description = "Check whether a file or directory exists before reading or editing it",
					opts = { require_approval_before = false },
					system_prompt = [[## File Exists Tool (`file_exists`)

## CONTEXT
- You are in Neovim, where a wrong path in read_file fails with an error and costs the user an approval.

### OBJECTIVE
- Call this before read_file or insert_edit_into_file whenever you are not certain of a path.

### RESPONSE
- `exists: true` means the path is safe to pass to another tool.
- `exists: false` lists nearby entries; pick one from those rather than guessing again.
]],
					schema = {
						type = "function",
						["function"] = {
							name = "file_exists",
							description = "Check whether a path exists and what it is, without reading its contents",
							parameters = {
								type = "object",
								properties = {
									path = {
										type = "string",
										description = "Absolute path, or a path relative to the current working directory",
									},
								},
								required = { "path" },
								additionalProperties = false,
							},
							strict = true,
						},
					},
					cmds = {
						---@param self table
						---@param args table
						---@return table
						function(self, args)
							local raw = (args.path or ""):match("^%s*(.-)%s*$")
							if raw == "" then
								return { status = "error", data = "No path was given" }
							end

							local path = vim.fn.fnamemodify(vim.fn.expand(raw), ":p")
							local function pretty(p)
								local home = vim.env.HOME or ""
								if home == "" then
									return p
								end
								return (p:gsub("^" .. (vim.esc or vim.pesc)(home), "~"))
							end

							local stat = (vim.uv or vim.loop).fs_stat(path)
							if stat then
								local kind = stat.type == "directory" and "directory" or "file"
								return {
									status = "success",
									data = string.format("exists: true\n%s is a %s", pretty(path), kind),
								}
							end

							local parent = vim.fs.dirname(path)
							local lines = { "exists: false", string.format("%s does not exist.", pretty(path)) }

							if not parent or vim.fn.isdirectory(parent) == 0 then
								lines[#lines + 1] = "Its parent directory does not exist either."
								return { status = "success", data = table.concat(lines, "\n") }
							end

							local wanted = vim.fs.basename(path)
							local names, total = {}, 0
							for name in vim.fs.dir(parent) do
								total = total + 1
								if #names < 25 then
									names[#names + 1] = name
								end
							end
							table.sort(names)

							for _, name in ipairs(names) do
								if name:lower() == wanted:lower() then
									lines[#lines + 1] = string.format("Case differs: use `%s`.", name)
									break
								end
							end

							if total == 0 then
								lines[#lines + 1] = string.format("Its parent, %s, is empty.", pretty(parent))
							else
								lines[#lines + 1] = string.format("Neighbours in %s:", pretty(parent))
								for _, name in ipairs(names) do
									lines[#lines + 1] = "  " .. name
								end
								if total > #names then
									lines[#lines + 1] = string.format("  ...and %d more", total - #names)
								end
							end

							return { status = "success", data = table.concat(lines, "\n") }
						end,
					},
					output = {
						---@param self table
						---@param stdout table
						---@param meta table
						success = function(self, stdout, meta)
							return meta.tools.chat:add_tool_output(self, tostring(stdout[1]))
						end,
						---@param self table
						---@param stderr table
						---@param meta table
						error = function(self, stderr, meta)
							return meta.tools.chat:add_tool_output(self, "file_exists failed: " .. tostring(stderr[1]))
						end,
					},
				},
			},
		},
		inline = { adapter = "openwebui" },
	},
})

-- A query that fails to compile (e.g. a stale file in after/queries) raises out of
-- the markdown parse inside context_paths.attach, which aborts submit() and drops
-- the message. Attachment is a nicety, so keep sending even when it fails.
do
	local context_paths = require("codecompanion.interactions.chat.helpers.context_paths")
	local attach = context_paths.attach
	context_paths.attach = function(opts)
		local ok, err = pcall(attach, opts)
		if not ok then
			require("codecompanion.utils.log"):warn("[context_paths] %s", err)
		end
	end
end

vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Code Companion" })
