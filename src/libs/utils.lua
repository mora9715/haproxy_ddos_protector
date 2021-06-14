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

function _M.generate_secret(args)
    --[[ args: {
    --       context: enum(applet, txn),
    --       mode: enum('service', 'action')
    --   }
    --]]
    local context = args.context
    local mode = args.mode or "service"

    local ip = context.sf:src() or ""

    local hostname = _M.get_hostname() or ""

    local user_agent
    if mode == "service" then
        user_agent = context.headers['user-agent'] or {}
        user_agent = user_agent[0]
    else
        user_agent = context.sf:req_hdr('user-agent') or ""
    end

    return context.sc:xxh32(ip .. hostname .. user_agent)
end

return _M

