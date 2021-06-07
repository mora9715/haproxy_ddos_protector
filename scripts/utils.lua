local _M = {}
local md5 = require("md5")

function _M.get_hostname()
    local f = io.popen ("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

function _M.get_floating_hash()
    -- This ensures that a cookie is rotated every day
    return md5.sumhexa(_M.get_hostname() .. os.date("%d"))
end

return _M

