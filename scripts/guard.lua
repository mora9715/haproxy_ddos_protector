guard = {}

function guard.hello_world(applet)
    applet:set_status(200)
    local response = string.format([[<html><body>Hello World!</body></html>]], message);
    applet:add_header("content-type", "text/html");
    applet:add_header("content-length", string.len(response))
    applet:start_response()
    applet:send(response)
end