local Window = {}
Window.__index = Window

function Window:new()
    return setmetatable({
            win = false,
            buf = false,
            opts = {
                style = "",
                relative = "",
                width = 0,
                height = 0,
                row = 0,
                col = 0,
            },
        }, self)
end

function Window:createBuffer(opts)
    self.buf = vim.api.nvim_create_buf(opts.listed, opts.scratch)
end

function Window:setBufferOption(opts)
    vim.api.nvim_buf_set_option(self.buf, opts.name, opts.value)
end

function Window:setBufferLines(opts)
    vim.api.nvim_buf_set_lines(self.buf, 
                               opts.start, 
                               opts.finish, 
                               opts.strict_indexing, 
                               opts.replacement)
end

function Window:setBufferMapping(opts)
    vim.api.nvim_buf_set_keymap(self.buf, 
                                opts.mode, 
                                opts.lhs, 
                                opts.rhs, 
                                opts.extra_opts)
end

function Window:addBufferHI(opts)
    vim.api.nvim_buf_add_highlight(self.buf, 
                               opts.ns_id, 
                               opts.hl_group, 
                               opts.line, 
                               opts.col_start,
                               opts.col_end)
end

function Window:setWindowStyle(sty)
    self.opts.style = sty
end

function Window:setWindowRelative(rel)
    self.opts.relative = rel
end

function Window:setWindowDimensions(f)
    if type(f) ~= "function" then
        error "Needs a function to apply on window dimensions!"
    end
    self.opts.width,self.opts.height = f()
end

function Window:setWindowCoordinates(f)
    if type(f) ~= "function" then
        error "Needs a function to apply on window dimensions!"
    end
    self.opts.row, self.opts.col = f(self.width, self.height)
end

function Window:setWindowOption(opts)
    vim.api.nvim_win_set_option(self.win, opts.name, opts.value)
end

function Window:setWindowCursor(opts)
    vim.api.nvim_win_set_cursor(self.win, opts)
end

function Window:getWindowCursor()
    local pos = math.max(4, vim.api.nvim_win_get_cursor(self.win)[1] - 1)
    return pos
end

function Window:open(enter)
    self.win = vim.api.nvim_open_win(self.buf, enter, self.opts)
end

function Window:close(enter)
    vim.api.nvim_win_close(self.win, true)
end

return Window
