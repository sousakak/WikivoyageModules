local function merge(...)
    local r = {}
    for i = 1, select('#', ...) do
        local arg = (select(i, ...)) or {}
        for k, v in pairs(arg) do
            r[k] = v
        end
    end
    return r
end

--[[
    Create a class.
]]
local function Class( obj )
    local init = obj.__init or function(self, ...) return self end
    obj.__init = nil
    setmetatable(
        obj,
        merge(
            getmetatable(obj),
            {
                __call = function(self, ...)
                    return init(self, ...)
                end,
                __metatable = ""
            }
        )
    )
    return obj
end

local Dog = Class({
    __init = function(self, name)
        self.name = name
        return self
    end,
    getName = function(self)
        return self.name
    end
})
local poti = Dog("poti")
mw.logObject(getmetatable(poti))