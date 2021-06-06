package.path = package.path  .. "./?.lua;/usr/local/etc/haproxy/scripts/?.lua"

require("guard")

core.register_service("hello-world", "http", guard.hello_world);