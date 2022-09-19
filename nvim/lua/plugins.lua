local M = {}

function M.setup()
	-- Indicate first time installation
	local packer_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
	end

	-- Plugins
	local function plugins(use)
		use { "wbthomason/packer.nvim" }

		-- Load only when require
		use { "nvim-lua/plenary.nvim", module = "plenary" }

		-- Notification
		use {
			"rcarriga/nvim-notify",
			event = "VimEnter",
			config = function()
				vim.notify = require "notify"
			end,
		}

		-- Colorscheme
		use {
			"sainnhe/everforest",
			config = function()
				vim.cmd "colorscheme everforest"
			end,
		}

		-- Startup screen
		use {
			"goolord/alpha-nvim",
			config = function()
				require("config.alpha").setup()
			end,
		}

		-- Git
		use {
			"TimUntersberger/neogit",
			cmd = "Neogit",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("config.neogit").setup()
			end,
		}

		use {
			"lewis6991/gitsigns.nvim"
		}


		-- WhichKey
		use {
			"folke/which-key.nvim",
			event = "VimEnter",
			config = function()
				require("config.whichkey").setup()
			end,
		}

		-- Better icons
		use {
			"kyazdani42/nvim-web-devicons",
			module = "nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup { default = true }
			end,
		}

		-- IndentLine
		use {
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			config = function()
				require("config.indentblankline").setup()
			end,
		}

		-- StatusLine
		use {
			"nvim-lualine/lualine.nvim",
			event = "VimEnter",
			config = function()
				require("config.lualine").setup()
			end,
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		-- Nvim-Treesitter : highlighting
		use {
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
		}

		-- fzf-lua : File Search
		if PLUGINS.fzf_lua.enabled then
			-- You don't need to install this if you already have fzf installed
			use { "junegunn/fzf", run = "./install --all" }
			use { "junegunn/fzf.vim", event = "BufEnter" }
			use {
				"ibhagwan/fzf-lua",
				event = "BufEnter",
				wants = "nvim-web-devicons",
				requires = {
					"junegunn/fzf",
					run = "./install --all"
				},
			}
		end

		-- Telescope
		if PLUGINS.telescope.enabled then
			use {
				"nvim-telescope/telescope.nvim",
				opt = true,
				config = function()
					require("config.telescope").setup()
				end,
				cmd = { "Telescope" },
				module = "telescope",
				keys = { "<leader>f", "<leader>p" },
				wants = {
					"plenary.nvim",
					"popup.nvim",
					"telescope-fzf-native.nvim",
					"telescope-project.nvim",
					"telescope-repo.nvim",
					"telescope-file-browser.nvim",
					"project.nvim",
				},
				requires = {
					"nvim-lua/plenary.nvim",
					"nvim-lua/popup.nvim",
					{
						"nvim-telescope/telescope-fzf-native.nvim",
						run = "make"
					},
					"nvim-telescope/telescope-project.nvim",
					"cljoly/telescope-repo.nvim",
					"nvim-telescope/telescope-file-browser.nvim",
					{
						"ahmedkhalf/project.nvim",
						config = function()
							require("project_nvim").setup {}
						end,
					},
				},
			}
		end

		-- Better Netrw
		use { "tpope/vim-vinegar" }

		-- nvim-tree
		use {
			"kyazdani42/nvim-tree.lua",
			wants = "nvim-web-devicons",
			cmd = { "NvimTreeToggle" },
			config = function()
				require("config.nvimtree").setup()
			end,
		}

		-- completion interactive with lsp
		use {
			"ms-jpq/coq_nvim",
		}

		-- LSP
		use {
			"neovim/nvim-lspconfig",
			opt = true,
			event = "BufReadPre",
			wants = {
				"nvim-lsp-installer",
				"coq_nvim",
				"lua-dev.nvim",
				"vim-illuminate",
				"null-ls.nvim",
				"schemastore.nvim",
				"nvim-lsp-ts-utils",
			},

			config = function()
				require("config.lsp").setup()
			end,

			requires = {
				"williamboman/nvim-lsp-installer",
				"ms-jpq/coq_nvim",
				"folke/lua-dev.nvim",
				"RRethy/vim-illuminate",
				-- "ray-x/lsp_signature.nvim",
				"jose-elias-alvarez/null-ls.nvim",
				{
					"j-hui/fidget.nvim",
					config = function()
						require("fidget").setup {}
					end,
				},
				"b0o/schemastore.nvim",
				"jose-elias-alvarez/nvim-lsp-ts-utils",
			},
		}

		-- nvim-jdtls
		use {
			"mfussenegger/nvim-jdtls",
			ft = { "java" }
		}

		-- Rust
		use {
			"simrat39/rust-tools.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"rust-lang/rust.vim"
			},
			module = "rust-tools",
			ft = { "rust" },
			config = function()
				require("rust-tools").setup {}
			end,
		}

		if packer_bootstrap then
			print "Restart Neovim required after installation!"
			require("packer").sync()
		end

	end

	packer_init()

	local packer = require "packer"
	packer.init(conf)
	packer.startup(plugins)
end

return M
