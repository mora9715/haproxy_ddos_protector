package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua;/usr/local/etc/haproxy/libs/?.lua"

local hcaptcha = require("hcaptcha")

core.register_service("hcaptcha-view", "http", hcaptcha.view)
core.register_action("hcaptcha-redirect", { 'http-req', }, hcaptcha.check_captcha_status)
