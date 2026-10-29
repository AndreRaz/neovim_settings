return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local disable_markdown = vim.fn.has("nvim-0.12") == 1
		local treesitter = require("nvim-treesitter.configs")

		do
			local non_filetype_match_injection_language_aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				uxn = "uxntal",
				ts = "typescript",
			}

			require("nvim-treesitter.query_predicates")

			vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local captured = match[pred[2]]
				local node = type(captured) == "table" and captured[#captured] or captured
				if type(node) ~= "userdata" then
					return
				end

				local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
				if not ok then
					return
				end

				local injection_alias = text:lower()
				local filetype = vim.filetype.match({ filename = "a." .. injection_alias })
				metadata["injection.language"] = filetype
					or non_filetype_match_injection_language_aliases[injection_alias]
					or injection_alias
			end, { force = true })
		end

		treesitter.setup({
			highlight = {
				enable = true,
				disable = disable_markdown and { "markdown", "markdown_inline" } or {},
			},
			indent = { enable = false },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"python",
				"c",
				"cpp",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
