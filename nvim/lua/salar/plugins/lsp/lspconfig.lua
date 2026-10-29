return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap
		local qt_clangd_flag_pattern = "^Unknown argument:%s*['\"]?%-mno%-direct%-extern%-access['\"]?"

		local default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			local client = ctx and vim.lsp.get_client_by_id(ctx.client_id)
			if client and client.name == "clangd" and result and result.diagnostics then
				result = vim.deepcopy(result)
				result.diagnostics = vim.tbl_filter(function(diagnostic)
					local message = diagnostic.message or ""
					return not message:match(qt_clangd_flag_pattern)
				end, result.diagnostics)
			end

			return default_publish_diagnostics(err, result, ctx, config)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.semanticTokensProvider then
					client.server_capabilities.semanticTokensProvider = nil
				end

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Go to definition"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				opts.desc = "Show documentation under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				local ft = vim.bo[ev.buf].filetype
				local path = vim.api.nvim_buf_get_name(ev.buf)
				local disable_inlay_hints = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)
					or path:match("%.h$")
					or path:match("%.hh$")
					or path:match("%.hpp$")
					or path:match("%.hxx$")
					or path:match("%.inl$")

				if client and client.server_capabilities.inlayHintProvider and not disable_inlay_hints then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 2,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			filetypes = {
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact",
			},
		})
		vim.lsp.enable("ts_ls")

		vim.lsp.config("html", {
			capabilities = capabilities,
		})
		vim.lsp.enable("html")

		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})
		vim.lsp.enable("cssls")

		vim.lsp.config("marksman", {
			capabilities = capabilities,
		})
		vim.lsp.enable("marksman")

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--query-driver=/usr/bin/c++,/usr/bin/g++",
			},
		})
		vim.lsp.enable("clangd")

		local function get_python_path(root_dir)
			local venv_names = { ".venv", "venv", "env" }

			for _, venv_name in ipairs(venv_names) do
				local unix_python = root_dir .. "/" .. venv_name .. "/bin/python"
				local windows_python = root_dir .. "/" .. venv_name .. "/Scripts/python.exe"

				if vim.fn.executable(unix_python) == 1 then
					return unix_python, venv_name
				end

				if vim.fn.executable(windows_python) == 1 then
					return windows_python, venv_name
				end
			end

			if vim.env.VIRTUAL_ENV then
				local virtualenv_python = vim.env.VIRTUAL_ENV .. "/bin/python"
				if vim.fn.executable(virtualenv_python) == 1 then
					return virtualenv_python
				end
			end

			local python3 = vim.fn.exepath("python3")
			if python3 ~= "" then
				return python3
			end

			local python = vim.fn.exepath("python")
			if python ~= "" then
				return python
			end
		end

		vim.lsp.config("pyright", {
			capabilities = capabilities,
			filetypes = { "python" },
			root_markers = {
				"pyrightconfig.json",
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				".git",
			},
			before_init = function(_, config)
				local root_dir = config.root_dir or vim.fn.getcwd()
				local python_path, venv_name = get_python_path(root_dir)

				config.settings = config.settings or {}
				config.settings.python = config.settings.python or {}
				config.settings.python.analysis = config.settings.python.analysis or {}
				config.settings.python.analysis.autoSearchPaths = true
				config.settings.python.analysis.useLibraryCodeForTypes = true

				if python_path then
					config.settings.python.pythonPath = python_path
				end

				if venv_name then
					config.settings.python.venvPath = root_dir
					config.settings.python.venv = venv_name
				end
			end,
		})
		vim.lsp.enable("pyright")

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(ev)
				local ft = vim.bo[ev.buf].filetype
				local cpp_like = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)

				if not cpp_like then
					return
				end

				vim.lsp.buf.format({
					bufnr = ev.buf,
					async = false,
					filter = function(client)
						return client.name == "clangd"
					end,
				})
			end,
		})
	end,
}
