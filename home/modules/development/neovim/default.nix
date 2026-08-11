{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;

    extraPackages =
      with pkgs;
      [
        nixd
        statix
        deadnix

        lua-language-server
        pyright
        typescript-language-server
        rust-analyzer
        gopls

        stylua
        nixfmt
        black
        ripgrep
        fd

        golangci-lint
        golangci-lint-langserver

        tree-sitter
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wl-clipboard # for Wayland/Hyprland — swap for `xclip` if you're on X11 instead
      ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim

      obsidian-nvim
      render-markdown-nvim

      # --- Colorscheme ---
      monokai-pro-nvim

      # --- Status line / UI ---
      lualine-nvim
      nvim-web-devicons
      which-key-nvim
      indent-blankline-nvim

      # --- Treesitter ---
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.python
        p.rust
        p.go
        p.typescript
        p.javascript
        p.bash
        p.markdown
        p.json
        p.yaml
      ]))

      nvim-lspconfig

      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets

      conform-nvim

      telescope-nvim
      telescope-fzf-native-nvim

      gitsigns-nvim
      neogit

      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio

      comment-nvim
      nvim-autopairs
      nvim-surround

      nvim-lint

      train-nvim
      mini-ai
      mini-files
      mini-starter
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      vim.opt.clipboard = "unnamedplus"

      vim.opt.list = true
      vim.opt.listchars = {
        tab = "→ ",
        trail = "·",
        nbsp = "␣",
        extends = "…",
        precedes = "…",
        space = "·",
      }

      require("monokai-pro").setup {
        filter = "classic", -- other options: "octagon", "pro", "machine", "ristretto", "spectrum"
      }
      vim.cmd.colorscheme("monokai-pro")

      require("lualine").setup {
        options = { theme = "monokai-pro" },
      }

      require("which-key").setup {}

      require("which-key").add {
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>d", group = "Debug (DAP)" },
        { "<leader>t", group = "Train motions" },
        { "<leader>g", group = "Git" },
        { "<leader>o", group = "Obsidian" },
      }

      require("lint").linters_by_ft = {
        nix = { "statix", "deadnix" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      require("nvim-treesitter").setup {}

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Apply shared settings to every server via the wildcard config
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("nixd", {
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixfmt" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "/Users/harald.wilhelmsen/.dotfiles").nixosConfigurations.tux.options',
              },
              home_manager = {
                expr = '(builtins.getFlake "/Users/harald.wilhelmsen/.dotfiles").homeConfigurations."haraldfw@tux".options',
              },
            },
          },
        },
      })
      vim.lsp.config("golangci_lint_ls", {
        cmd = { "golangci-lint-langserver" },
        root_markers = { ".git", "go.mod" },
        init_options = {
          command = {
            "golangci-lint",
            "run",
            "--output.json.path", "stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          },
        },
      })


      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
        end,
      })

      vim.lsp.enable({ "nixd", "lua_ls", "pyright", "ts_ls", "rust_analyzer", "gopls", "golangci_lint_ls" })

      require("conform").setup {
        formatters_by_ft = {
          nix = { "nixfmt" },
          lua = { "stylua" },
          python = { "black" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }

      require("telescope").setup {}
      require("telescope").load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

      require("gitsigns").setup {}
      require("neogit").setup {}
      vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup {}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })

      require("nvim-autopairs").setup {}
      require("nvim-surround").setup {}
      require("Comment").setup {}
      require("ibl").setup {}

      -- ============================================================
      -- mini.nvim additions
      -- ============================================================
      require("mini.ai").setup {}

      require("mini.files").setup {}
      vim.keymap.set("n", "<leader>e", function()
        require("mini.files").open()
      end, { desc = "Open file explorer" })

      require("mini.starter").setup {}

      -- train.nvim
      vim.keymap.set("n", "<leader>tu", ":TrainUpDown<CR>", { desc = "Train up/down motions" })
      vim.keymap.set("n", "<leader>tw", ":TrainWord<CR>", { desc = "Train word motions" })
      vim.keymap.set("n", "<leader>to", ":TrainTextObj<CR>", { desc = "Train text-object motions" })

      -- obsidian.nvim
      require("obsidian").setup {
        legacy_commands = false,

        ui = {
          enable = false,
        },

        workspaces = {
          {
            name = "main",
            path = "~/notes",
          },
        },

        daily_notes = {
          folder = "dailies",
        },
      }

      require("render-markdown").setup {
        preset = "obsidian",
      }

      vim.keymap.set("n", "<leader>oo", ":Obsidian<CR>", { desc = "Obsidian menu" })
      vim.keymap.set("n", "<leader>on", ":Obsidian new<CR>", { desc = "New note" })
      vim.keymap.set("n", "<leader>os", ":Obsidian search<CR>", { desc = "Search notes" })
      vim.keymap.set("n", "<leader>ot", ":Obsidian today<CR>", { desc = "Today's daily note" })
    '';
  };
}
