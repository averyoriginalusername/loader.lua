local Connections = {}
Connections.__index = Connections

function Connections.new()
    local self = setmetatable({}, Connections)
    self.list = {}
    return self
end

function Connections:Conn(flag, _ConnectionFunc)
    if self.list[flag] then return end
    table.insert(self.list, {flag = flag, connection = _ConnectionFunc})
end

function Connections:Disconnect(connection)
    for i, v in pairs(self.list) do
        if self.list[i].flag == tostring(connection) then
            self.list[i].connection:Disconnect()
            table.remove(self.list, i)
            return true
        end
    end
    return false
end

function Connections:ClearAllCurrent()
    for i,v in pairs(self.list) do
        table.remove(self.list, i)
    end
end

return Connections
