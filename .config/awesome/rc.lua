-- Standard awesome library
local gears = require("gears")
awful       = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
--
--
-- N.B.:  Lua has 1-base indices
-- N.B.:  Lua is fugly
--
-- TODO: Strip out the embedded lua and do this in python.  Subtle has
-- done it in ruby but the tiling sucks.  The widget manager is pimp tho

local naughty = require("naughty")
local menubar = require("menubar")


local vicious   = require("vicious")
vicious.contrib = require("vicious.contrib")
local gnarly    = require("gnarly")
gnarly.cmus     = require("gnarly.cmus")
-- vicious.helpers = require("vicious.helpers")

-- my stuff
-- nkt = require("nkt")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

config_dir = awful.util.getdir("config")
script_dir = table.concat({config_dir, "scripts"}, "/")

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(config_dir .. "/themes/theme.lua")
--                                    ^ symlink
--
-- N.B. colors defined in theme.lua are available as properties of
-- beautiful (e.g., beautiful.border_color)

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
terminal_no_client = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
-- modkey = "Mod4"
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- get tag names from file
--
tag_names = {}
for line in io.lines(table.concat({config_dir, "tags.txt"}, "/")) do
  table.insert(tag_names, line)
end

-- number the tag names
for T = 1, #tag_names do
  tag_names[T] = (T .. " " .. tag_names[T])
end
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tag_names, s, layouts[1]) 
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create widgets
-- mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mytopwibox = {}
mybotwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag)
                    -- awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    -- awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- widgets
delimiter   = wibox.widget.textbox()
delimiter:set_text("   ")

datebox     = wibox.widget.textbox()
membox      = wibox.widget.textbox()
uptimebox   = wibox.widget.textbox()
volbox      = wibox.widget.textbox()
wifibox     = wibox.widget.textbox()
musicbox    = wibox.widget.textbox()

cpugraph    = awful.widget.graph()
cpugraph:set_width(50)
cpugraph:set_color(beautiful.bg_focus)
-- cpugraph:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })


for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mytopwibox[s] = awful.wibox({ position = "top",     screen = s })
    mybotwibox[s] = awful.wibox({ position = "bottom",  screen = s })

    -- Widgets that are aligned to the left
    local top_left_layout = wibox.layout.fixed.horizontal()
    top_left_layout:add(mylauncher)
    top_left_layout:add(mytaglist[s])
    top_left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local top_right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then 
      top_right_layout:add(wibox.widget.systray()) 
    end

    top_right_layout:add(delimiter)
    top_right_layout:add(uptimebox)
    top_right_layout:add(delimiter)
    top_right_layout:add(cpugraph)
    top_right_layout:add(delimiter)
    top_right_layout:add(membox)
    top_right_layout:add(delimiter)
    top_right_layout:add(datebox)
    top_right_layout:add(delimiter)
    top_right_layout:add(mylayoutbox[s])


    -- define bottom layout
    local bot_left_layout = wibox.layout.fixed.horizontal()
    bot_left_layout:add(delimiter)
    bot_left_layout:add(musicbox)
    bot_left_layout:add(delimiter)
    bot_left_layout:add(volbox)
    -- local bot_middle_layout = wibox.layout.fixed.horizontal()
    local bot_right_layout = wibox.layout.fixed.horizontal()
    bot_right_layout:add(delimiter)
    bot_right_layout:add(wifibox)
    bot_right_layout:add(delimiter)


    -- Now bring it all together (with the tasklist in the middle)
    --     ^
    -- //... these default comments are dumb ...//
    local top_layout = wibox.layout.align.horizontal()
    top_layout:set_left(top_left_layout)
    top_layout:set_middle(mytasklist[s])
    top_layout:set_right(top_right_layout)

    local bot_layout = wibox.layout.align.horizontal()
    bot_layout:set_left(bot_left_layout)
    -- bot_layout:set_middle(mytasklist[s])
    bot_layout:set_right(bot_right_layout)

    mytopwibox[s]:set_widget(top_layout)
    mybotwibox[s]:set_widget(bot_layout)
end
-- }}}

-- {{{ Mouse bindings
-- root.buttons(awful.util.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey, "Control" }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "j", function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey,           }, "k", function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(1)
            if client.focus then
              client.focus:raise()
            end
        end),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function() awful.util.spawn(terminal_no_client, false) end),
    awful.key({ modkey,           }, "e", function() awful.util.spawn("nautilus", false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- keybindings
    awful.key({         }, "Print", function () awful.util.spawn("gnome-screenshot -a -i", false)end),
    awful.key({ "Shift" }, "Print", function () awful.util.spawn("gnome-screenshot -w", false)end),

    -- winamp-stylez
    -- volume
    --  Up:      Num Pad up
    --  Down:    Num Pad down
    -- playlist
    --  Next:    Page Down
    --  Prior:   Page Up
    --  Home:    Home key
    awful.key({ modkey, "Control", }, 
              "Up",     function () vicious.contrib.pulse.add(1,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
    awful.key({ modkey, "Control", }, 
              "Down",   function () vicious.contrib.pulse.add(-1,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
    awful.key({ modkey, "Control", }, 
                "Next",   function () awful.util.spawn(script_dir .. "/playback.sh next",false) end),
    awful.key({ modkey, "Control", }, 
                "Prior",  function () awful.util.spawn(script_dir .. "/playback.sh prev",false) end),
    awful.key({ modkey, "Control", }, 
                "Home",   function () awful.util.spawn(script_dir .. "/playback.sh pause",false)    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- run lua code.  what anyone would use this for I have no idea
    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run({ prompt = "Run Lua code: " },
    --               mypromptbox[mouse.screen].widget,
    --               awful.util.eval, nil,
    --               awful.util.getdir("cache") .. "/history_eval")
    --           end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    -- awful.key({ modkey,           }, "n",
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
                        -- eliminate gaps between applications
                        size_hints_honor = false,
                        --
                        border_width = beautiful.border_width,
                        border_color = beautiful.border_normal,
                        focus = awful.client.focus.filter,
                        keys = clientkeys,
                        buttons = clientbuttons } },
    -- { rule = { class = "xboard" },      properties = { floating = true } },
    { rule = { class = "chromium" },        properties = { floating = false } },
    { rule = { class = "Chromium" },        properties = { floating = false } },
    { rule = { class = "free-jin-JinApplication" },     properties = { floating = false } },
    { rule = { class = "gimp" },            properties = { floating = true } },
    { rule = { class = "google-chrome" },   properties = { floating = false } },
    { rule = { class = "libreoffice-calc" },properties = { floating = false } },
    { rule = { class = "mplayer" },         properties = { floating = false } },
    { rule = { class = "MPlayer" },         properties = { floating = false } },
    { rule = { class = "pinentry" },        properties = { floating = true } },
    { rule = { class = "gimp" },            properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    -- c:connect_signal("mouse::enter", function(c)
    --     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --         and awful.client.focus.filter(c) then
    --         client.focus = c
    --     end
    -- end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled =   false
    --                          ^ false, so following block never
    --                          executed
    -- if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    --     -- Widgets that are aligned to the left
    --     local top_left_layout = wibox.layout.fixed.horizontal()
    --     top_left_layout:add(awful.titlebar.widget.iconwidget(c))

    --     -- Widgets that are aligned to the right
    --     local top_right_layout = wibox.layout.fixed.horizontal()
    --     top_right_layout:add(awful.titlebar.widget.floatingbutton(c))
    --     top_right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    --     top_right_layout:add(awful.titlebar.widget.stickybutton(c))
    --     top_right_layout:add(awful.titlebar.widget.ontopbutton(c))
    --     top_right_layout:add(awful.titlebar.widget.closebutton(c))

    --     -- The title goes in the middle
    --     local title = awful.titlebar.widget.titlewidget(c)
    --     title:buttons(awful.util.table.join(
    --             awful.button({ }, 1, function()
    --                 client.focus = c
    --                 c:raise()
    --                 awful.mouse.client.move(c)
    --             end),
    --             awful.button({ }, 3, function()
    --                 client.focus = c
    --                 c:raise()
    --                 awful.mouse.client.resize(c)
    --             end)
    --             ))

    --     -- Now bring it all together
    --     local top_layout = wibox.layout.align.horizontal()
    --     top_layout:set_left(top_left_layout)
    --     top_layout:set_right(top_right_layout)
    --     top_layout:set_middle(title)

    --     awful.titlebar(c):set_widget(top_layout)
    -- end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- table of async timers

-- local c = beautiful.border_focus
--   d[1]:set_markup(f())

vicious.register(datebox, vicious.widgets.date, "%Y-%m-%d %H:%M:%S %Z", 2)

vicious.register(uptimebox, vicious.widgets.uptime,
    function (widget, args)
        return string.format("up%2dd %02dh %02dm", args[1], args[2], args[3])
    end, 71)

vicious.register(membox, vicious.widgets.mem,    
    function(widget, args)
        return string.format("mem %d%% (%d/%d GB)", args[1], args[2]/1024.0, args[3]/1024.0)
    end, 13)

vicious.register(wifibox,   vicious.widgets.wifi,   "${ssid} ${link}% ${rate} MB/s", 16, "wlp3s0")
vicious.register(cpugraph, vicious.widgets.cpu, "$1", 3)
vicious.register(volbox, vicious.contrib.pulse, "vol $1%", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
volbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end),
    awful.button({ }, 5, function () vicious.contrib.pulse.add(1,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
    awful.button({ }, 4, function () vicious.contrib.pulse.add(-1,"alsa_output.pci-0000_00_1b.0.analog-stereo") end)
))

vicious.register(musicbox, gnarly.cmus, 
  function(widget, T)
    if T["{error}"] then return "error: " .. T["{status}"] end
    if T["{status}"] == "stopped" or T["{status}"] == "not running" then 
      return string.format("♫ %s", T["{status_symbol}"]) 
    end

    return string.format("♫  %s %s %s %s", 
                            T["{status_symbol}"],
                            T["{song}"],
                            T["{remains_pct}"],
                            T["{CRS}"]
                        )
  end, 2)
