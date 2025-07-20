local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
        local args = {...}
        for i, v in ipairs(args) do
            if type(v) == "number" and v > 0 and v < 100000 then
                args[i] = math.huge
            end
        end
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
