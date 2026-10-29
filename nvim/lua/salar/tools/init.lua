local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("SalarIncludeFormatter", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = { "*.h", "*.hpp", "*.hh", "*.hxx", "*.c", "*.cc", "*.cpp", "*.cxx" },
		callback = function(args)
			require("salar.tools.include_formatter").format(args.buf)
		end,
	})

	vim.api.nvim_create_user_command("Skel", function()
		require("salar.tools.skeleton").insert()
	end, {})

	require("salar.tools.cpp_extract").setup()
	require("salar.tools.cpp_trivial_constructor").setup()
end

return M
