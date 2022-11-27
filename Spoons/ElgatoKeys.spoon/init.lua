--- === Elgato Key Lights ===
--- Controls multiple Elgato key lights together
--- Inspired by https://github.com/evantravers/hammerspoon-config/blob/master/Spoons/ElgatoKey.spoon/init.lua
local M = {
    name = "Elgato Key Light Controls",
    version = "0.1",
    author = "Alex Watt <alex@alexcwatt.com>",
    license = "MIT <https://opensource.org/licenses/MIT>"
}

function M:start()
    M.findServices()

    return self
end

function M.findServices()
    local browser = hs.bonjour.new()
    M.keylights = {}

    browser:findServices('_elg._tcp', function(browserObject, domain, advertised, service, terminated)
        M.service = service
        service:resolve(function(serviceObj, result)
            if result == "resolved" then
                local keylight = {}
                keylight.ip = service:addresses()[1]
                keylight.port = service:port()

                table.insert(M.keylights, keylight)
            end
        end)
    end)
end

local function lightsUrl(keylight)
    return "http://" .. keylight.ip .. ":" .. keylight.port .. "/elgato/lights"
end

local function getSettings(keylight)
    local status, body, headers = hs.http.get(lightsUrl(keylight))
    return hs.json.decode(body)
end

local function setSettings(keylight, settings)
    local status, response, header = hs.http.doRequest(lightsUrl(keylight), "PUT", hs.json.encode(settings))
end

local function onOff(state)
    for i, keylight in ipairs(M.keylights) do
        local settings = getSettings(keylight)
        settings.lights[1].on = state

        setSettings(keylight, settings)
    end
end

function M:off()
    onOff(0)

    return self
end

function M:on()
    onOff(1)

    return self
end

return M
