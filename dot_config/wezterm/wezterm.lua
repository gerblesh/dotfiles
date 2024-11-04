-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")
sessionizer.apply_to_config(config, true)
sessionizer.config.paths = wezterm.read_dir("/home/user/Documents/")
sessionizer.config.command_options.fd_path = "/home/linuxbrew/.linuxbrew/bin/fd"

config.default_prog = { "/bin/fish" }
config.set_environment_variables = {
	SHELL = "/bin/fish",
}

-- appearance
config.font = wezterm.font("JetBrainsMonoNerdFont")
config.font_size = 15.0
config.enable_wayland = true
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = false
config.window_padding = {
	left = 3,
	right = 3,
	top = 3,
	bottom = 3,
}
local gruvbox = wezterm.color.get_builtin_schemes()["GruvboxDark"]
config.color_scheme = "GruvboxDark"
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 20
config.colors = {
	tab_bar = {
		background = "#1d2021",
	},
}
local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[0]
config.front_end = "WebGpu"

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 1.0,
}

wezterm.on("update-right-status", function(window, pane)
	local leader_color = gruvbox.ansi[7]
	if window:leader_is_active() then
		leader_color = gruvbox.ansi[6]
	end
	local elements = {
		{ Foreground = { Color = leader_color } },
		{ Foreground = { Color = gruvbox.background } },
		{ Background = { Color = leader_color } },
		{ Text = "  " },
		{ Foreground = { Color = gruvbox.foreground } },
		{ Background = { Color = gruvbox.background } },
		{ Text = " " .. window:active_workspace() .. " " },
	}

	for _, value in ipairs(wezterm.mux.get_workspace_names()) do
		if value == window:active_workspace() then
			goto continue
		end
		table.insert(elements, { Foreground = { Color = gruvbox.background } })
		table.insert(elements, { Background = { Color = gruvbox.brights[1] } })
		table.insert(elements, { Text = "  " })
		table.insert(elements, { Foreground = { Color = gruvbox.foreground } })
		table.insert(elements, { Background = { Color = gruvbox.background } })
		table.insert(elements, { Text = " " .. value .. " " })
		::continue::
	end
	window:set_right_status(wezterm.format(elements))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	if tab.tab_title and #tab.tab_title > 0 then
		title = tab.tab_title
	end
	title = wezterm.truncate_right(title, max_width - 5)
	local active_color = gruvbox.brights[1]
	if tab.is_active then
		active_color = gruvbox.ansi[7]
	end
	return {
		{ Background = { Color = active_color } },
		{ Foreground = { Color = gruvbox.background } },
		{ Text = " " .. (tab.tab_index + 1) .. " " },
		{ Background = { Color = gruvbox.background } },
		{ Foreground = { Color = gruvbox.foreground } },
		{ Text = " " .. title .. " " },
		{ Foreground = { Color = gruvbox.background } },
	}
end)
-- keymaps

-- local function is_vim(pane)
-- 	-- this is set by the plugin, and unset on ExitPre in Neovim
-- 	return pane:get_user_vars().IS_NVIM == "true"
-- end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}
--
local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "ALT" or "ALT|CTRL",
		action = wezterm.action_callback(function(win, pane)
			if resize_or_move == "resize" then
				win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			end
			-- if is_vim(pane) then
			-- 	-- pass the keys through to vim/nvim
			-- 	win:perform_action({
			-- 		SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
			-- 	}, pane)
			-- else
			-- 	if resize_or_move == "resize" then
			-- 		win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
			-- 	else
			-- 		win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			-- 	end
			-- end
		end),
	}
end
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	{
		mods = "LEADER",
		key = "s",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "v",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "z",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "r",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		mods = "LEADER",
		key = "q",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER|SHIFT",
		key = "q",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.SpawnCommandInNewTab({ args = { "/usr/bin/fish", "-liC", "nvim" } }),
	},
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },

	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "h", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	-- Activate Copy Mode
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	-- Paste from Copy Mode
	{ key = "]", mods = "LEADER", action = wezterm.action.PasteFrom("PrimarySelection") },
	{ key = "s", mods = "CTRL", action = sessionizer.show },
	-- {
	-- 	key = "h",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		-- Here you can dynamically construct a longer list if needed
	-- 		local home = wezterm.home_dir
	-- 		local workspaces = {
	-- 			{ id = home, label = "default" },
	-- 			{ id = home, label = "Home" },
	-- 			{ id = home .. "/Documents/Rust/", label = "Rust" },
	-- 			{ id = home .. "/Documents/Go Projects/", label = "Golang" },
	-- 			{ id = home .. "/Documents/C/", label = "C" },
	-- 			{ id = home .. "/Documents/csharp/", label = "C Sharp" },
	-- 			{ id = home .. "/Documents/Processing/", label = "Processing" },
	-- 			{ id = home .. "/Documents/Godot/", label = "Godot" },
	-- 			{ id = home .. "/Documents/Neorg/", label = "Neorg" },
	-- 			{ id = home .. "/.config/", label = "Config" },
	-- 			{ id = home .. "/Documents/Ublue/", label = "Universal Blue" },
	-- 		}
	--
	-- 		window:perform_action(
	-- 			wezterm.action.InputSelector({
	-- 				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
	-- 					if not id and not label then
	-- 						wezterm.log_info("cancelled")
	-- 					else
	-- 						wezterm.log_info("id = " .. id)
	-- 						wezterm.log_info("label = " .. label)
	-- 						inner_window:perform_action(
	-- 							wezterm.action.SwitchToWorkspace({
	-- 								name = label,
	-- 								spawn = {
	-- 									label = "Workspace: " .. label,
	-- 									cwd = id,
	-- 								},
	-- 							}),
	-- 							inner_pane
	-- 						)
	-- 					end
	-- 				end),
	-- 				title = "Choose Workspace",
	-- 				choices = workspaces,
	-- 				fuzzy = true,
	-- 				fuzzy_description = "Fuzzy find and/or make a workspace 󱝩 ",
	-- 			}),
	-- 			pane
	-- 		)
	-- 	end),
	-- },
}

return config
