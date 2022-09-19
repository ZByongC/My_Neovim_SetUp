local M = {}

-- Find files
function M.find_files()

	if PLUGINS.telescope.enabled then
		
		local opts = {}
		local telescope = require "telescope.builtin"
		local ok = pcall(telescope.git_files, opts)

		if not ok then
			telescope.find_files(opts)
		end

	else

		local fzf = require "fzf-lua"

		if vim.fn.system "git rev-parse --is-inside-work-tree" == true then
			fzf.git_files()
		else
			fzf.files()
		end
	
	end

end

-- Find dotfiles
function M.find_dotfiles()

	require("telescope.builtin").git_files {
		prompt_title = "<Dotfiles>",
		cwd = "$HOME/.config",
	}

end

return M
