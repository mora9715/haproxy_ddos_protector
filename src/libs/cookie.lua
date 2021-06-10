-- Copyright (C) 2013-2016 Jiale Zhi (calio), CloudFlare Inc.
-- See RFC6265 http://tools.ietf.org/search/rfc6265
-- require "luacov"

local type          = type
local byte          = string.byte
local sub           = string.sub

local EQUAL         = byte("=")
local SEMICOLON     = byte(";")
local SPACE         = byte(" ")
local HTAB          = byte("\t")


local _M = {}
_M._VERSION = '0.01'


function _M.get_cookie_table(text_cookie)
    if type(text_cookie) ~= "string" then
        return {}
    end

    local EXPECT_KEY    = 1
    local EXPECT_VALUE  = 2
    local EXPECT_SP     = 3

    local n = 0
    local len = #text_cookie

    for i=1, len do
        if byte(text_cookie, i) == SEMICOLON then
            n = n + 1
        end
    end

    local cookie_table  = {}

    local state = EXPECT_SP
    local i = 1
    local j = 1
    local key, value

    while j <= len do
        if state == EXPECT_KEY then
            if byte(text_cookie, j) == EQUAL then
                key = sub(text_cookie, i, j - 1)
                state = EXPECT_VALUE
                i = j + 1
            end
        elseif state == EXPECT_VALUE then
            if byte(text_cookie, j) == SEMICOLON
                    or byte(text_cookie, j) == SPACE
                    or byte(text_cookie, j) == HTAB
            then
                value = sub(text_cookie, i, j - 1)
                cookie_table[key] = value

                key, value = nil, nil
                state = EXPECT_SP
                i = j + 1
            end
        elseif state == EXPECT_SP then
            if byte(text_cookie, j) ~= SPACE
                and byte(text_cookie, j) ~= HTAB
            then
                state = EXPECT_KEY
                i = j
                j = j - 1
            end
        end
        j = j + 1
    end

    if key ~= nil and value == nil then
        cookie_table[key] = sub(text_cookie, i)
    end

    return cookie_table
end

return _M
