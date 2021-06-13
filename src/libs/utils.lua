local _M = {}

function _M.get_hostname()
    local handler = io.popen ("/bin/hostname")
    local hostname = handler:read("*a") or ""
    handler:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

function _M.resolve_fqdn(fqdn)
    local handler = io.popen(string.format("dig +short %s | head -1", fqdn))
    local result = handler:read("*a")
    handler:close()
    return result:gsub("\n", "")
end

return _M

