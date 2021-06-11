_M = {}

local url = require("net.url")
local https = require("ssl.https")
local json = require("rapidjson")
local utils = require("utils")
local cookie = require("cookie")

local floating_hash = utils.get_floating_hash()
local hcaptcha_secret = os.getenv("HCAPTCHA_SECRET")
local hcaptcha_sitekey = os.getenv("HCAPTCHA_SITEKEY")

function _M.view(applet)
    local response_body
    local response_status_code

    if applet.method == "GET" then
        response_body =
            [[
        <!DOCTYPE html>
        <html>
            <head>
                <title>Captcha</title>
                <style>
                    body {
                    width: 35em;
                    margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif;
                    }
                </style>
            </head>
            <body>
                <h1>Captcha challenge completion required.</h1>
                <p>We have detected an unusual activity on the requested resource.</p>
                <p>To ensure that the service runs smoothly, it is needed to complete a captcha challenge.</p>
                <form method="POST">
                    <div class="h-captcha" data-sitekey="%s"></div>
                    <script src="https://hcaptcha.com/1/api.js" async defer></script>
                    <input type="submit" value="Submit">
                </form>
                <p><em>Thank you for understanding.</em></p>
            </body>
        </html>
        ]]
        response_body = string.format(response_body, hcaptcha_sitekey)
        response_status_code = 200
    elseif applet.method == "POST" then
        local parsed_body = url.parseQuery(applet.receive(applet))

        if parsed_body["h-captcha-response"] then
            local url =
                string.format(
                "https://hcaptcha.com/siteverify?secret=%s&response=%s",
                hcaptcha_secret,
                parsed_body["h-captcha-response"]
            )
            local body, _, _, _ = https.request(url)
            local api_response = json.decode(body)

            if api_response.success == true then
                core.Debug("HCAPTCHA SUCCESSFULLY PASSED")
                applet:add_header(
                    "set-cookie",
                    string.format("z_ddos_protection=%s; Max-Age=14400; Path=/", floating_hash)
                )
            else
                core.Debug("HCAPTCHA FAILED: " .. body)
            end
        end

        response_body = "Thank you for submitting!"
        response_status_code = 301
        applet:add_header("location", applet.qs)
    end

    applet:set_status(response_status_code)
    applet:add_header("content-type", "text/html")
    applet:add_header("content-length", string.len(response_body))
    applet:start_response()
    applet:send(response_body)
end

function _M.check_captcha_status(txn)
    core.Debug("CAPTCHA STATUS CHECK START")
    txn:set_var("txn.requested_url", "/mopsik?kek=pek")
    local parsed_request_cookies = cookie.get_cookie_table(txn.sf:hdr("Cookie"))

    core.Debug("RECEIVED SECRET COOKIE: " .. parsed_request_cookies["z_ddos_protection"])
    core.Debug("OUR SECRET COOKIE: " .. floating_hash)

    if parsed_request_cookies["z_ddos_protection"] == floating_hash then
        core.Debug("CAPTCHA STATUS CHECK SUCCESS")
        return txn:set_var("txn.captcha_passed", true)
    end
end

return _M