-- lua/plugins/dap.lua (lazy.nvim spec)
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Adapter: codelldb (scarica il binario da github.com/vadimcn/codelldb)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "/home/alle/.local/share/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = "/media/workspace/workspace/UnrealEngine/Engine/Binaries/Linux/UnrealEditor-Linux-DebugGame",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {"/media/workspace/workspace/BIM3/Dreamcatcher/Dreamcatcher.uproject"},
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    -- Open / closes automatically DAP UI
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- Keymaps
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_into)
    vim.keymap.set("n", "<F12>", dap.step_out)
    vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
  end,
}
