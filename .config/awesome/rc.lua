-- N.B.:  Lua has 1-base indices
-- N.B.:  Lua is fugly

-- load core lua modules 
--
--
awful           = require("awful")
awful.rules     = require("awful.rules")
beautiful       = require("beautiful")
menubar         = require("menubar")
require("awful.autofocus")

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
    awful.layout.suit.spiral.dwindle
    --awful.layout.suit.magnifier
}

-- export lua functions
--
--
join            = table.concat
collect         = table.collect
keys            = table.keys
printf          = string.format

-- load my lua modules
--
--
gnarly          = require("gnarly")
require("gnarly.util")

keydoc          = require("keydoc")


-- export my functions
--
--
scandir         = gnarly.util.scandir
log             = gnarly.util.log

-- load modular configs
--
--
config_dir          = awful.util.getdir("config")
script_dir          = join({config_dir, "scripts"}, "/")
local partials_dir  = join({config_dir, "partials"}, "/")
local partials      = scandir(partials_dir)
for i = 1, #partials do
  dofile(join({partials_dir, partials[i]}, "/"))
end
