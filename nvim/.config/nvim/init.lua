-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- General
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.guicursor = ""
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.updatetime = 50
vim.o.winborder = "rounded"
vim.o.signcolumn = "no"
vim.o.undofile = true

-- Keymaps
vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<leader>o", ":update<CR> :source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")

-- Buffer cycling
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Window cycling
map("n", "<leader>wn", "<C-w>w", { desc = "Next window" })
map("n", "<leader>wp", "<C-w>W", { desc = "Previous window" })

map({ "n", "v" }, "<leader>y", '"+y"')
map("n", "<leader>y", '"+Y"')

map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'No left for you'<CR>")
map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'No right for you'<CR>")
map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'No up for you'<CR>")
map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'No down for you'<CR>")

map("n", "<leader>dl", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { desc = "Show all diagnostics" })

map("n", "<leader>gt", function()
	vim.cmd("split | terminal")
	vim.cmd("resize 15")
end, { desc = "Open terminal" })

-- Keep visual selection after indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- LSP
map("n", "<leader>lf", function()
	require("conform").format({ async = false, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "<leader>rn", vim.lsp.buf.rename)

vim.lsp.enable({
	"bashls",
	"clangd",
	"lua_ls",
	"ruff",
	"basedpyright",
	"ts_ls",
	"yamlls",
	"marksman",
	"angularls",
	"html",
	"graphql",
})
vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemaStore = { enable = true },
			keyOrdering = false,
		},
	},
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

-- LSP navigation
map("n", "gd", vim.lsp.buf.definition)
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gr", vim.lsp.buf.references)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "K", vim.lsp.buf.hover)

-- Packages
vim.pack.add({
	{ src = "https://github.com/ribru17/bamboo.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", branch = "0.1.x" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/seblyng/roslyn.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/tris203/tree-sitter-razor" },
})

-- Formatters
require("conform").setup({
	formatters_by_ft = {
		cs = { "csharpier" },
		graphql = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		htmlangular = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		lua = { "stylua" },
	},
	formatters = {
		csharpier = {
			args = { "format", "--write-stdout", "--no-cache", "--stdin-path", "$FILENAME" },
		},
	},
})

-- Mason
require("mason-tool-installer").setup({
	ensure_installed = {
		"ruff",
		"angular-language-server",
		"basedpyright",
		"bash-language-server",
		"lua-language-server",
		"clangd",
		"csharpier",
		"roslyn",
		"tree-sitter-cli",
		"html-lsp",
		"htmlbeautifier",
		"marksman",
		"typescript-language-server",
		"yaml-language-server",
		"graphql-language-service-cli",
		"prettier",
		"stylua",
	},
	auto_update = true,
})
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

-- Roslyn
require("roslyn").setup({})

-- Treesitter
require("nvim-treesitter").install({
	"c_sharp",
	"razor",
	"html",
	"lua",
	"vim",
	"vimdoc",
	"bash",
	"python",
	"javascript",
	"typescript",
	"tsx",
	"css",
	"json",
	"yaml",
	"markdown",
	"markdown_inline",
	"graphql",
	"c",
	"cpp",
	"query",
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft)
		if lang and pcall(vim.treesitter.start, args.buf, lang) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
map("n", "<leader>e", ":Oil<CR>")

require("telescope").setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_config = { prompt_position = "top" },
		file_ignore_patterns = { ".git/", "node_modules/" },
	},
	pickers = {
		find_files = { hidden = true },
	},
})
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Resume last picker" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- Colorscheme
require("bamboo").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd("colorscheme bamboo")
vim.cmd(":hi statusline guibg=NONE")
