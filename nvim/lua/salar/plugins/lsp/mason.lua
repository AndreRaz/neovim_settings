return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local ensure_installed = {
			"clangd",
			"pyright",
			"ts_ls",
			"html",
			"cssls",
			"lua_ls",
			"marksman",
		}

		mason_lspconfig.setup({
			ensure_installed = ensure_installed,
		})
	end,
}
