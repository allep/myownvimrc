return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" }, -- enable lazy loading on these commands
    keys = {
        { "<Leader><f2>", "<cmd>Git blame<CR>", desc = "Git blame" },
        { "<Leader><f3>", "<cmd>close<CR>", desc = "Close blame" },
        { "<C-x>d", "<cmd>tab Git diff develop<CR>", desc = "Git diff against develop" },
    },
}
