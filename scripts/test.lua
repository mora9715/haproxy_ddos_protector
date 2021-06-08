package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"
test = {}
local redis = require 'redis'
client = redis.connect('redis', 6379)
-- response = client:ping()
-- print(response)
function test.ratelimit(applet)
    host = applet.headers.host[0]
    current = client:llen(host)
    if current > 3 then
        applet:set_status(200)
        local response = string.format([[<html><body>powel naxyi %s, current - %s\n</body></html>]], host, current, message);
            applet:add_header("content-type", "text/html");
            applet:add_header("content-length", string.len(response))
            applet:start_response()
            applet:send(response)
    else
        client:rpush(host,host)
        client:expire(host, 10)
        applet:set_status(200)
        local response = string.format([[<html><body>lox %s, current - %s\n</body></html>]], host, current, message);
        applet:add_header("content-type", "text/html");
        applet:add_header("content-length", string.len(response))
        applet:start_response()
        applet:send(response)
    end
end