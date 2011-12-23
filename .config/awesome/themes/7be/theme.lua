---------------------------
-- esq awesome theme --
---------------------------

theme = {}
theme.font          = "Monaco 11"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg -a /home/noah/img/lauves_bw.jpg" }   
-- theme.wallpaper_cmd = { "feh --bg-scale /home/noah/img/background" }

theme.bg_normal     = "#121212"
theme.bg_focus      = "#000000"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#d7ff00"
theme.fg_urgent     = "#b84eef"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#808080"
theme.border_marked = "#91231c"

-- There are another variables sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
-- taglist_bg_focus = #ff0000

-- Display the taglist squares
theme.taglist_squares_sel = "/home/noah/.config/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/home/noah/.config/awesome/themes/default/taglist/squarew.png"

theme.tasklist_floating_icon = "/home/noah/.config/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/home/noah/.config/awesome/themes/default/submenu.png"
theme.menu_height   = "15"
theme.menu_width    = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
-- bg_widget    = #cc0000

-- Define the image to load
theme.titlebar_close_button_normal = "/home/noah/.config/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/home/noah/.config/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/noah/.config/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/home/noah/.config/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/noah/.config/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/home/noah/.config/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/noah/.config/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/home/noah/.config/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/noah/.config/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/home/noah/.config/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/noah/.config/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/home/noah/.config/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/noah/.config/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/home/noah/.config/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/noah/.config/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/home/noah/.config/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/noah/.config/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/home/noah/.config/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = "/home/noah/.config/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/home/noah/.config/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating = "/home/noah/.config/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/home/noah/.config/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/home/noah/.config/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/home/noah/.config/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/home/noah/.config/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft = "/home/noah/.config/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/home/noah/.config/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/home/noah/.config/awesome/themes/default/layouts/tiletopw.png"

theme.awesome_icon = "/home/noah/.config/awesome/icons/n0ah16.png"

return theme
-- vim: filetype=lua
