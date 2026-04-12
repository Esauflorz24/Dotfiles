local cached_branch = ""
local icon_empty = vim.fn.nr2char(0xf021a)
local last_check = 0
local function git_branch()
	local now = vim.loop.now()
	if now - last_check > 5000 then -- Check every 5 seconds
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return " \u{eafd} " .. cached_branch .. " " -- nf-dev-git_branch
	end

	return ""
end

-- File type with Nerd Font icon
local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620} ", -- nf-dev-lua
		python = "\u{e73c} ", -- nf-dev-python
		javascript = "\u{e74e} ", -- nf-dev-javascript
		typescript = "\u{e628} ", -- nf-dev-typescript
		javascriptreact = "\u{e7ba} ",
		typescriptreact = "\u{e7ba} ",
		html = "\u{e736} ", -- nf-dev-html5
		css = "\u{e749} ", -- nf-dev-css3
		scss = "\u{e749} ",
		json = "\u{e60b} ", -- nf-dev-json
		markdown = "\u{e73e} ", -- nf-dev-markdown
		vim = "\u{e62b} ", -- nf-dev-vim
		sh = "\u{f489} ", -- nf-oct-terminal
		bash = "\u{f489} ",
		zsh = "\u{f489} ",
		rust = "\u{e7a8} ", -- nf-dev-rust
		go = "\u{e724} ", -- nf-dev-go
		c = "\u{e61e} ", -- nf-dev-c
		cpp = "\u{e61d} ", -- nf-dev-cplusplus
		java = "\u{e738} ", -- nf-dev-java
		php = "\u{e73d} ", -- nf-dev-php
		ruby = "\u{e739} ", -- nf-dev-ruby
		swift = "\u{e755} ", -- nf-dev-swift
		kotlin = "\u{e634} ",
		dart = "\u{e798} ",
		elixir = "\u{e62d} ",
		haskell = "\u{e777} ",
		sql = "\u{e706} ",
		yaml = "\u{f481} ",
		toml = "\u{e615} ",
		xml = "\u{f05c} ",
		dockerfile = "\u{f308} ", -- nf-linux-docker
		gitcommit = "\u{f418} ", -- nf-oct-git_commit
		gitconfig = "\u{f1d3} ", -- nf-fa-git
		vue = "\u{fd42} ", -- nf-md-vuejs
		svelte = "\u{e697} ",
		astro = "\u{e628} ",
	}

	if ft == "toggleterm" then
		return ft .. " \u{ebc6}"
	end
	if ft == "neo-tree" then
		return ft .. " \u{ef81} "
	end

	local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0))
	local name = (path == "" and "Empty") or vim.fn.fnamemodify(path, ":t")

	return (icons[ft] or icon_empty .. " ") .. name
end

-- File size with Nerd Font icon
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "StModeNormal", { fg = "#1e1e2e", bg = "#dddddd", bold = true })
		vim.api.nvim_set_hl(0, "StModeInsert", { fg = "#1e1e2e", bg = "#aaaaaa", bold = true })
		vim.api.nvim_set_hl(0, "StModeVisual", { fg = "#1e1e2e", bg = "#7788aa", bold = true })
		vim.api.nvim_set_hl(0, "StModeCommand", { fg = "#1e1e2e", bg = "#789978", bold = true })

		vim.api.nvim_set_hl(0, "StLspWarn", { fg = "#ffaa88", bg = "#242424", bold = true })
		vim.api.nvim_set_hl(0, "StLspHints", { fg = "#7788aa", bg = "#242424", bold = true })
		vim.api.nvim_set_hl(0, "StLspError", { fg = "#f7f7f7", bg = "#242424", bold = true })
		vim.api.nvim_set_hl(0, "StLspInfo", { fg = "#7788aa", bg = "#242424", bold = true })
	end,
})

-- Mode indicators with Nerd Font icons
local function mode_icon()
	local mode = vim.fn.mode()

	local modes = {
		n = { text = " \u{e7c5}  NORMAL ", hl = "%#StModeNormal#" },
		i = { text = " \u{f11c}  INSERT ", hl = "%#StModeInsert#" },
		v = { text = " \u{f06e} VISUAL ", hl = "%#StModeVisual#" },
		V = { text = " \u{f0168} V-LINE ", hl = "%#StModeVisual#" },
		["\22"] = { text = " \u{f0168} V-BLOCK ", hl = "%#StModeVisual#" },
		c = { text = " \u{f120} COMMAND ", hl = "%#StModeCommand#" },
		s = { text = " \u{f0c5} SELECT ", hl = "%#StModeVisual#" },
		R = { text = " \u{f044} REPLACE ", hl = "%#StModeCommand#" },
		t = { text = " \u{f489} TERMINAL ", hl = "%#StModeInsert#" },
	}
	local current = modes[mode] or { text = " \u{f059} " .. mode .. " ", hl = "%#StModeNormal#" }

	return current.hl .. current.text .. "%#StatusLine#"
end

local function print_diagnostic()
	if not rawget(vim, "lsp") then
		return " "
	end

	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winid)

	local error = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
	local warn = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
	local hint = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })

	local hints_msg = (hint > 0) and ("%#StLspHints#" .. "󰠠 " .. hint .. "%*" .. " ") or ""
	local error_msg = (error > 0) and ("%#StLspError#" .. "  " .. error .. "%*" .. " ") or ""
	local warn_msg = (warn > 0) and ("%#StLspWarn#" .. "  " .. warn .. "%*" .. " ") or ""
	local info_msg = (info > 0) and ("%#StLspInfo#" .. "󰋼 " .. info .. "%*" .. " ") or ""

	return " " .. hints_msg .. error_msg .. warn_msg .. info_msg
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size
_G.print_diagnostic = print_diagnostic

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorMoved", "TermOpen" }, {
		callback = function()
			local status_line = {
				"%{%v:lua.mode_icon()%}",
				" ",
				"\u{f413} ~" .. vim.uv.cwd(), -- nf-pl-left_hard_divider
				"%{v:lua.git_branch()}",
				"\u{23fd} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_type()} ",
				"\u{23fd} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_size()}",
				"%=", -- Right-align everything after this
				"%{%v:lua.print_diagnostic()%}",
				"%#StModeInsert#",
				" \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
			}

			local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()

			local bufnr = vim.api.nvim_win_get_buf(winid)

			local ft_status = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

			local win_width = vim.api.nvim_win_get_width(winid)
			local ft_is_different = (ft_status == "neo-tree" or ft_status == "toggleterm")
			local win_is_narrow = (win_width <= 95)

			if ft_is_different or win_is_narrow then
				table.remove(status_line, 3)
				table.remove(status_line, 2)
			end

			--	local win_id = vim.g.statusline_winid or vim.api.nvim_get_current_win()
			--	local win_width = vim.api.nvim_win_get_width(win_id)
			--[[if win_width < 60 then
				MyStatusLine = {
					"%#StatusLine#",
					"%{v:lua.git_branch()}",
					"\u{e0b1} ", -- nf-pl-left_hard_divider
					"%=", -- Right-align everything after this
					" \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
				}
			end]]

			vim.opt_local.statusline = table.concat(status_line)
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	--vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	--	callback = function()
	--		local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	--
	--			local bufnr = vim.api.nvim_win_get_buf(winid)
	--			local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	--			local statusLineFormat = " %f %h%m%r " .. icon .. " %{v:lua.file_type()} %=  %l:%c   %P "
	--
	--
	--			if filetype == "neo-tree" then
	--				statusLineFormat = "\u{ef81} Neo-tree %= %P "
	--			end
	--
	--			vim.opt_local.statusline = statusLineFormat
	--		end,
	--	})
end

setup_dynamic_statusline()
