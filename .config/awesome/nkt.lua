config_dir = awful.util.getdir("config")
script_dir = table.concat({config_dir, "scripts"}, "/")

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function log(data) io.stderr:write( data .. "\n") end

function spawn_script(path, ...)
  local the_file = awful.util.spawn(script_dir .. "/" .. path)
  if not awful.util.file_readable(the_file) then
    local warning = "W: " .. the_file .. " does not exist or is not readable."
    return warning
  end
  return awful.util.spawn(path .. table.join(arg, ' '))
end

function run_script(path)
  local the_file = script_dir .. "/" .. path
  if not awful.util.file_readable(the_file) then
    local warning = "W: " .. the_file .. " does not exist or is not readable."
    log(warning)
    return warning
  end
  return awful.util.pread(the_file)
end


function color(str, color)
  -- TODO ...
  return "<span color=\"" .. color .. "\">" .. str .. "</span>"
end
