package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"

require("guard")
require("hcaptcha")
require("test")


core.register_service("hello-world", "http", guard.hello_world)
core.register_service("hcaptcha-view", "http", hcaptcha.view)
core.register_action("hcaptcha-redirect", { 'http-req', }, hcaptcha.check_captcha_status)
core.register_service("ratelimit", "http", test.ratelimit)
