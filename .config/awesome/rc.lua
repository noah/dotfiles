-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")

-- N.B.:  Lua has 1-base indices
-- N.B.:  Lua is fugly
--
-- TODO: Strip out the embedded lua and do this in python.  Subtle has
-- done it in ruby but the tiling sucks.  The widget manager is pimp tho

-- notifications
require("naughty")

--  widget library
-- require("vicious")

-- my stuff
require("nkt")

config_dir = awful.util.getdir("config")
script_dir = table.concat({config_dir, "scripts"}, "/")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(config_dir .. "/themes/theme.lua")
--                                    ^ symlink
--
-- N.B. colors defined in theme.lua are available as properties of
-- beautiful (e.g., beautiful.border_color)

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod0, but it may interact with others.
-- modkey = "Mod4"
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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

-- {{{ Tags
tag_names = {}

for line in io.lines(table.concat({config_dir, "tags.txt"}, "/")) do
  table.insert(tag_names, line)
end

-- number the tag names
for T = 1, table.getn(tag_names) do
  tag_names[T] = (T .. " " .. tag_names[T])
end

-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag(tag_names, s, layouts[1])
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ 
  items = {
    {
      "awesome", 
      myawesomemenu, 
      beautiful.awesome_icon 
    },
    { 
      "open terminal", 
      terminal
    },
    { 
      "nautilus", 
      "nautilus"
    }
  }
})

mylauncher = awful.widget.launcher({ 
  image = image(beautiful.awesome_icon),
  menu = mymainmenu 
})

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ 
  align = "right" 
})

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({        }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({        }, 4, awful.tag.viewnext),
  awful.button({        }, 5, awful.tag.viewprev)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
      if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
      end
      client.focus = c
      c:raise()
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ 
      layout = awful.widget.layout.horizontal.leftright 
    })

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
      awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(
                    s, 
                    awful.widget.taglist.label.all, 
                    mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                      return awful.widget.tasklist.label.currenttags(c, s)
                    end, 
                    mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
      {
        mylauncher,
        mytaglist[s],
        mypromptbox[s],
        layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],
      mytextclock,
      s == 1 and mysystray or nil,
      mytasklist[s],
      layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function() awful.util.spawn(terminal, false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)   end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)     end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)     end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,1)end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1)end),

    -- keybindings
    awful.key({ modkey }, "Print", function () awful.util.spawn("gnome-screenshot", false)end),
    awful.key({ modkey, "Shift" }, "Print", function () awful.util.spawn("gnome-screenshot -w", false)end),

    -- winamp-stylez
    -- volume
    --  Up:      Num Pad up
    --  Down:    Num Pad down
    -- playlist
    --  Next:    Page Down
    --  Prior:   Page Up
    --  Home:    Home key
    awful.key({ modkey, "Control", }, 
                "Up",     function () awful.util.spawn(script_dir .. "/volume.sh +",false)  end),
    awful.key({ modkey, "Control", }, 
                "Down",   function () awful.util.spawn(script_dir .. "/volume.sh -",false)  end),
    awful.key({ modkey, "Control", }, 
                "Next",   function () awful.util.spawn(script_dir .. "/playback.sh next",false) end),
    awful.key({ modkey, "Control", }, 
                "Prior",  function () awful.util.spawn(script_dir .. "/playback.sh prev",false) end),
    awful.key({ modkey, "Control", }, 
                "Home",   function () awful.util.spawn(script_dir .. "/playback.sh pause",false)    end),

    -- Prompt
    awful.key({ modkey }, "p",     function () mypromptbox[mouse.screen]:run() end)

    -- run lua code.  what anyone would use this for I have no idea
    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run({ prompt = "Run Lua code: " },
    --               mypromptbox[mouse.screen].widget,
    --               awful.util.eval, nil,
    --               awful.util.getdir("cache") .. "/history_eval")
    --           end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
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
    { rule = { },   properties = { 
                        -- eliminate gaps between applications
                        size_hints_honor = false,
                        --
                        border_width = beautiful.border_width,
                        border_color = beautiful.border_normal,
                        focus = true,
                        keys = clientkeys,
                        buttons = clientbuttons } },
    -- { rule = { class = "MPlayer" },     properties = { floating = true } },
    -- { rule = { class = "xboard" },      properties = { floating = true } },
    { rule = { class = "pinentry" },    properties = { floating = true } },
    { rule = { class = "gimp" },        properties = { floating = true } },
    -- start application on [screen#][tag#] (doesn't work?)
    -- { rule = { class = "google-chrome" }, properties = { tag = tags[1][5] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    -- c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


delim       = ' '
mybwibox    = awful.wibox({ position = "bottom", screen = 1})

yaourtbox   = widget({ type = "textbox", 
  layout    = awful.widget.layout.horizontal.rightleft
})
volbox      = widget({ type = "textbox",
  layout    = awful.widget.layout.horizontal.leftright
})
musicbox    = widget({ type = "textbox", 
  layout    = awful.widget.layout.horizontal.leftright
})
uptimebox   = widget({ type = "textbox", 
  layout    = awful.widget.layout.horizontal.rightleft
})
kbbox       = widget({ type = "textbox", 
  layout    = awful.widget.layout.horizontal.rightleft
})

delimiter   = widget({ type = "textbox" })

mybwibox.widgets = {
        musicbox,
        delimiter,
        volbox,
        delimiter,
        yaourtbox,
        delimiter,
        uptimebox,
        delimiter,
        kbbox,
        layout = awful.widget.layout.horizontal.leftright
}

delimiter.text = delim

-- table of async timers

local c = beautiful.border_focus
timers = {
  -- function   = { target, period}
  --    *functions can be keys*
  --
  -----------------------------------------------------------------------
  [function() return color(' cm ',  c)    .. run_script("cmus.sh")   end] = { musicbox,    1     },
  [function() return color(' vl ',  c)    .. run_script("volume.sh")   end] = { volbox,     1     },
  -- [function() return color(' kb ',  c)    .. run_script("kb.sh")       end] = { kbbox,      10    },
  [function() return color(' up ',  c)    .. run_script("uptime.sh")   end] = { uptimebox,  60    },
  [function() return color(' yt ',  c)    .. run_script("yaourt.sh")   end] = { yaourtbox,  60*60 }
  -----------------------------------------------------------------------
}

-- Register signals:
--  Set text value of d[0] to value of f every d[1] seconds
for f, d in pairs(timers) do
  -- Set initial values
  d[1].text = f()
  
  t = timer({ timeout = d[2] })
  t:add_signal("timeout", function()
    d[1].text = f()
  end)
  t:start()
end
