package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"
test = {}
local redis = require 'redis'
client = redis.connect('redis', 6379)
local expire_time = 120

function test.ratelimit(txn)
    local host = txn.sf:hdr("Host")
    client:rpush(host,host)
    client:expire(host, expire_time)
end