package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"

require("guard")
require("hcaptcha")

core.register_service("hello-world", "http", guard.hello_world)
core.register_service("hcaptcha-view", "http", hcaptcha.view)