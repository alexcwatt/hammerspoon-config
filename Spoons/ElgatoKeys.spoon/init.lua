--- === Elgato Key Lights ===
--- Controls multiple Elgato key lights together
--- Inspired by https://github.com/evantravers/hammerspoon-config/blob/master/Spoons/ElgatoKey.spoon/init.lua
local M = {
    name = "Elgato Key Light Controls",
    version = "0.2",
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

                if (keylight.ip ~= nil and keylight.port ~= nil) then
                    table.insert(M.keylights, keylight)
                end
            end
        end)
    end)
end

local function lightsUrl(keylight)
    return "http://" .. keylight.ip .. ":" .. keylight.port .. "/elgato/lights"
end

local function getSettings(keylight)
    local status, body, headers = hs.http.get(lightsUrl(keylight))
    if status ~= 200 or body == nil then
        return nil
    end
    return hs.json.decode(body)
end

local function setSettings(keylight, settings)
    hs.http.asyncPut(lightsUrl(keylight), hs.json.encode(settings), nil, function(code, body, headers)
    end)
end

local function onOff(state)
    for i, keylight in ipairs(M.keylights) do
        local settings = getSettings(keylight)
        if settings then
            settings.lights[1].on = state
            setSettings(keylight, settings)
        else
            print("Failed to retrieve settings for keylight:", keylight.ip)
        end
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
