local Log = {}
Log.__index = Log

function Log:new(path, level)
    local l = level or "prod"
    return setmetatable({
            path = path .. '.log',
            messages = {},
            level = l,
        }, self)
end

function Log:start()
    os.execute(string.format("rm -f %s", self.path))
    os.execute(string.format("touch %s", self.path))
end

function Log:trace(header, str)
    local l = string.format("[%s] : %s", header, str)
    table.insert(self.messages, string.format("%s", l))
end

function Log:dump(str)
    for k,v in ipairs(self.messages) do
        os.execute(string.format("echo %s >> %s", v, self.path))
    end
end

return Log
