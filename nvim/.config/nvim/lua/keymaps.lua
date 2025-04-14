local wk = require("which-key")

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

-- tmux-navigator
wk.add({
	{ "<c-h>", "<cmd>TmuxNavigateLeft<cr>", icon = "🔀", desc = "Navigate left" },
	{ "<c-j>", "<cmd>TmuxNavigateDown<cr>", icon = "🔀", desc = "Navigate down" },
	{ "<c-k>", "<cmd>TmuxNavigateUp<cr>", icon = "🔀", desc = "Navigate up" },
	{ "<c-l>", "<cmd>TmuxNavigateRight<cr>", icon = "🔀", desc = "Navigate right" },
	{ "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", icon = "🔀", desc = "Navigate previous" },
})

-- which-key
wk.add({
	{
		mode = { "n" },
		{ "<leader>?", group = "Help", icon = "❓", nowait = true, remap = false },
		{
			"<leader>?",
			"<cmd>lua require('which-key').show({ global = false })<cr>",
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
})

-- neo-tree
wk.add({
	{
		mode = { "n" },
		{ "<leader>t", group = "Neotree", icon = "🌲", nowait = true, remap = false },
		{ "<leader>tt", "<cmd>Neotree toggle<cr>", desc = "Neotree: toggle" },
		{ "<leader>tr", "<cmd>Neotree refresh<cr>", desc = "Neotree: refresh" },
		{ "<leader>tf", "<cmd>Neotree find<cr>", desc = "Neotree: find" },
		{ "<leader>tc", "<cmd>Neotree close<cr>", desc = "Neotree: close" },
	},
})

-- telescope
wk.add({
	{
		mode = { "n" },
		{ "<leader>f", group = "Find", icon = "🔍", nowait = true, remap = false },
		{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find: files" },
		{ "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Find: grep" },
		{
			"<leader>fs",
			"<cmd>lua require('auto-session.session-lens').search_session<cr>",
			noremap = true,
			desc = "Find sessions",
		},
	},
})

-- gitsigns
wk.add({
	{ "<leader>g", group = "Gitsigns", icon = "🐙", nowait = true, remap = false },
	{
		mode = { "n" },
		{
			"<leader>gt",
			group = "Gitsigns Toggle",
			icon = "🐙",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gtb",
			"<cmd>lua require('gitsigns').toggle_current_line_blame()<cr>",
			desc = "Gitsigns: toggle line blame",
		},
		{
			"<leader>gtd",
			"<cmd>lua require('gitsigns').toggle_deleted()<cr>",
			desc = "Gitsigns: toggle deleted",
		},
		{
			"<leader>gtw",
			"<cmd>lua require('gitsigns').toggle_word_diff()<cr>",
			desc = "Gitsigns: toggle word diff",
		},
	},
	{
		mode = { "n" },
		{
			"<leader>gh",
			group = "Gitsigns Hunk",
			icon = "🐙",
			nowait = true,
			remap = false,
		},
		{ "<leader>ghs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", desc = "Gitsigns: stage hunk" },
		{ "<leader>ghr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", desc = "Gitsigns: reset hunk" },
		{ "<leader>ghS", "<cmd>lua require('gitsigns').stage_buffer()<cr>", desc = "Gitsigns: stage buffer" },
		{ "<leader>ghR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", desc = "Gitsigns: reset buffer" },
		{ "<leader>ghp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", desc = "Gitsigns: preview hunk" },
		{
			"<leader>ghi",
			"<cmd>lua require('gitsigns').preview_hunk_inline()<cr>",
			desc = "Gitsigns: preview hunk inline",
		},
		{
			"<leader>ghb",
			"<cmd>lua require('gitsigns').blame_line({ full = true })<cr>",
			desc = "Gitsigns: blame line",
		},
		{ "<leader>ghd", "<cmd>lua require('gitsigns').diffthis()<cr>", desc = "Gitsigns: diff this" },
		{
			"<leader>ghD",
			"<cmd>lua require('gitsigns').diffthis('~')<cr>",
			desc = "Gitsigns: diff this all",
		},
		{ "<leader>ghq", "<cmd>lua require('gitsigns').setqflist()<cr>", desc = "Gitsigns: setqflist" },
		{
			"<leader>ghQ",
			"<cmd>lua require('gitsigns').setqflist('all')<cr>",
			desc = "Gitsigns: setqflist all",
		},
	},
	{
		mode = { "v" },
		{
			"<leader>gh",
			group = "Gitsigns Hunk",
			icon = "🐙",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ghs",
			"<cmd>lua require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })<cr>",
			desc = "Gitsigns: stage hunk",
		},
		{
			"<leader>ghr",
			"<cmd>lua require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })<cr>",
			desc = "Gitsigns: reset hunk",
		},
	},
})

-- code actions
wk.add({
	{
		mode = { "n" },
		{ "<leader>c", group = "Code Actions", icon = "💡", nowait = true, remap = false },
		{ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code: actions" },
		{ "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Code: format" },
		{
			"<Leader>cc",
			"<cmd>lua require('neogen').generate()<cr>",
			noremap = true,
			silent = true,
			desc = "Code: comment",
		},
	},
})

-- venv-selector
wk.add({
	{
		mode = { "n" },
		{ "<leader>v", group = "VenvSelector", icon = "🐍", nowait = true, remap = false },
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "VenvSelect: select" },
		{ "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "VenvSelect: select cached" },
	},
})

-- neotest
wk.add({
	{
		mode = { "n" },
		{ "<leader>n", group = "Neotest", icon = "🧪", nowait = true, remap = false },
		{
			"<leader>nr",
			"<cmd>lua require('neotest').run.run()<cr>",
			desc = "Neotest: run nearest test",
		},
		{
			"<leader>nf",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
			desc = "Neotest: run current file",
		},
		{
			"<leader>na",
			"<cmd>lua require('neotest').run.run({ suite = true })<cr>",
			desc = "Neotest: run all tests",
		},
		{
			"<leader>nd",
			"<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>",
			desc = "Neotest: debug nearest test",
		},
		{
			"<leader>ns",
			"<cmd>lua require('neotest').run.stop()<cr>",
			desc = "Neotest: stop test",
		},
		{
			"<leader>nn",
			"<cmd>lua require('neotest').run.attach()<cr>",
			desc = "Neotest: attach to nearest test",
		},
		{
			"<leader>no",
			"<cmd>lua require('neotest').output.open()<cr>",
			desc = "Neotest: show test output",
		},
		{
			"<leader>np",
			"<cmd>lua require('neotest').output_panel.toggle()<cr>",
			desc = "Neotest: toggle output panel",
		},
		{
			"<leader>nt",
			"<cmd>lua require('neotest').summary.toggle()<cr>",
			desc = "Neotest: toggle summary",
		},
		{
			"<leader>nc",
			"<cmd>lua require('neotest').run.run({ suite = true, env = { CI = true } })<cr>",
			desc = "Neotest: run all tests with CI",
		},
	},
})

-- debugger
wk.add({
	{
		mode = { "n" },
		{
			"<leader>d",
			group = "Debugger",
			icon = "🪲",
			nowait = true,
			remap = false,
		},
		{ "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Debugger: toggle breakpoint" },
		{ "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Debugger: continue" },
		{ "<leader>dn", "<cmd>lua require('dap').step_over()<cr>", desc = "Debugger: step over" },
		{ "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Debugger: step into" },
		{ "<leader>do", "<cmd>lua require('dap').step_out()<cr>", desc = "Debugger: step out" },
		{ "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", desc = "Debugger: toggle REPL" },
		{ "<leader>ds", "<cmd>lua require('dap').stop()<cr>", desc = "Debugger: stop" },
		{ "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Debugger: run last" },
		{ "<leader>dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Debugger: toggle UI" },
	},
})

-- lazy tools
wk.add({
	{
		mode = { "n" },
		{ "<leader>l", group = "LazyTools", icon = "🛠", nowait = true, remap = false },
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit: open" },
		{ "<leader>ld", "<cmd>lua require('lazydocker').open()<cr>", desc = "LazyDocker: open" },
	},
})

-- avante
wk.add({
	{
		mode = { "n", "v" },
		{ "<leader>a", group = "Avante", icon = "🚀", nowait = true, remap = true },
	},
})
