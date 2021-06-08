package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"
require("redis")

local redis = require 'redis'
local client = redis.connect('127.0.0.1', 6379)
local response = client:ping()
local dummy = client:get('dummy')
print(dummy)
