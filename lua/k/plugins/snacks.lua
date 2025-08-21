-- Optimized snacks and UI plugins
return {
  -- Icons - Only load when actually needed
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {},
      default = true,
    },
  },
  
  {
    "echasnovski/mini.icons",
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Theme - Load with high priority but don't block startup
  {
    "lunarvim/synthwave84.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Apply colorscheme after a short delay to avoid blocking startup
      vim.defer_fn(function()
        vim.cmd.colorscheme("synthwave84")
      end, 0)
    end,
  },

  -- Snacks - Core utilities with optimized config
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Bigfile handling for performance
      bigfile = {
        enabled = true,
        notify = false, -- Disable notifications for performance
        size = 1.5 * 1024 * 1024, -- 1.5MB
        setup = function(ctx)
          vim.cmd([[NoMatchParen]])
          vim.b.minianimate_disable = true
          vim.schedule(function()
            vim.bo[ctx.buf].syntax = ctx.ft
          end)
        end,
      },
      
      -- Notifier - Minimal configuration
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        level = vim.log.levels.TRACE,
      },

      -- Dashboard - Optimized configuration
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            "██   ██  █████  ███    ██ ██    ██ ██ ███    ███ ",
            "██  ██  ██   ██ ████   ██ ██    ██ ██ ████  ████ ",
            "█████   ███████ ██ ██  ██ ██    ██ ██ ██ ████ ██ ",
            "██  ██  ██   ██ ██  ██ ██  ██  ██  ██ ██  ██  ██ ",
            "██   ██ ██   ██ ██   ████   ████   ██ ██      ██ ",
            "",
            "KANVIM — Kartik's Neovim",
          }, "\n"),
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --porcelain -b | head -10",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },

      -- Quickfile for faster file opening
      quickfile = { enabled = true },
      
      -- Statuscolumn with minimal configuration
      statuscolumn = { enabled = false }, -- Use native for better performance
      
      -- Words highlighting
      words = { enabled = true },
      
      -- Styles for consistent UI
      styles = {
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        }
      }
    },
    
    keys = {
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for easier access
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          if vim.lsp.inlay_hint then
            Snacks.toggle.inlay_hints():map("<leader>uh")
          end
        end,
      })
    end,
  },
}
