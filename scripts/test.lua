package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"

local redis = require 'redis'
client = redis.connect('127.0.0.1', 6379)
response = client:ping()

