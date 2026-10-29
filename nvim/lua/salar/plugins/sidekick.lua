return {
	"folke/sidekick.nvim",
	opts = {
		nes = {
			enabled = false,
		},
		copilot = {
			status = {
				enabled = false,
			},
		},
		cli = {
			watch = true,
		},
	},
	keys = {
		{
			"<c-.>",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle Focus",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Sidekick Select Agent (Claude/Codex/Pi)",
		},
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Toggle Claude Code",
		},
		{
			"<leader>ax",
			function()
				require("sidekick.cli").toggle({ name = "codex", focus = true })
			end,
			desc = "Sidekick Toggle Codex",
		},
		{
			"<leader>ai",
			function()
				require("sidekick.cli").toggle({ name = "pi", focus = true })
			end,
			desc = "Sidekick Toggle Pi",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Sidekick Detach CLI Session",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Sidekick Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Sidekick Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Sidekick Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
