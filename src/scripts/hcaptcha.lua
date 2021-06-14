_M = {}

local url = require("url")
local http = require("http")
local utils = require("utils")
local cookie = require("cookie")
local json = require("json")

local captcha_secret = os.getenv("HCAPTCHA_SECRET")
local captcha_sitekey = os.getenv("HCAPTCHA_SITEKEY")

-- HaProxy Lua is not capable of FQDN resolution :(
local captcha_provider_domain = "hcaptcha.com"
local captcha_provider_ip = utils.resolve_fqdn(captcha_provider_domain)

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
        response_body = string.format(response_body, captcha_sitekey)
        response_status_code = 200
    elseif applet.method == "POST" then
        local parsed_body = url.parseQuery(applet.receive(applet))

        if parsed_body["h-captcha-response"] then
            local url =
                string.format(
                "https://%s/siteverify?secret=%s&response=%s",
                captcha_provider_ip,
                captcha_secret,
                parsed_body["h-captcha-response"]
            )
            local res, err = http.get{url=url, headers={host=captcha_provider_domain} }
            local status, api_response = pcall(res.json, res)

            if not status then
                local original_error = api_response
                api_response = {}
                core.Warning("Received incorrect response from Captcha Provider: " .. original_error)
            end

            if api_response.success == true then
                local floating_hash = utils.generate_secret{context=applet, mode='service'}
                core.Debug("HCAPTCHA SUCCESSFULLY PASSED")
                applet:add_header(
                    "set-cookie",
                    string.format("z_ddos_protection=%s; Max-Age=14400; Path=/", floating_hash)
                )
            else
                core.Debug("HCAPTCHA FAILED: " .. json.encode(api_response))
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
    local expected_cookie = utils.generate_secret{context=txn, mode='service'}

    core.Debug("RECEIVED SECRET COOKIE: " .. parsed_request_cookies["z_ddos_protection"])
    core.Debug("OUR SECRET COOKIE: " .. expected_cookie)

    if parsed_request_cookies["z_ddos_protection"] == expected_cookie then
        core.Debug("CAPTCHA STATUS CHECK SUCCESS")
        return txn:set_var("txn.captcha_passed", true)
    end
end

return _M