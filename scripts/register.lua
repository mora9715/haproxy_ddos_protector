package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"

require("guard")
require("hcaptcha")
require("test")

--core.register_service("hello-world", "http", guard.hello_world)
--core.register_service("hcaptcha-view", "http", hcaptcha.view)
--core.register_service("test", "http", test.hello_world2)
core.register_service("ratelimit", "http", test.ratelimit)
