local Window = require("tutorial.window")
local utils = require("tutorial.utils")
local Log = require("tutorial.lib.log")

-- l = Log:new("~/Documents/projects/langs/lua/Lua-Project-Template/tutorial", "debug")
-- l:start()
-- l:trace("bWindow H", string.format("%d", bWin.opts.height))
-- l:dump()

local pos
local win, bWin

local function setBorderWindowCloseHook()
    vim.api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. bWin.buf)
end

local function createBorderLines()
    local lines = { '╔' .. string.rep('═', win.opts.width) .. '╗' }
    local middle = '║' .. string.rep(' ', win.opts.width) .. '║'

    for _=1, win.opts.height do
        table.insert(lines, middle)
    end

    table.insert(lines, '╚' .. string.rep('═', win.opts.width) .. '╝')

    bWin:setBufferLines({
        start = 0, 
        finish = -1, 
        strict_indexing = false, 
        replacement = lines
    })
end

local function createBorderWindow()
    bWin = Window:new() 
    bWin:createBuffer({listed = false, scratch = true})
    bWin:setWindowStyle("minimal")
    bWin:setWindowRelative("editor")
    bWin:setWindowDimensions(
    function()
        local w = vim.api.nvim_get_option("columns")
        local h = vim.api.nvim_get_option("lines")

        local ret_h = math.ceil(h * 0.8 - 4)
        local ret_w = math.ceil(w * 0.8)

        return ret_w + 2, ret_h + 2
    end
    )

    bWin:setWindowCoordinates(
    function(ww, wh)
        local w = vim.api.nvim_get_option("columns")
        local h = vim.api.nvim_get_option("lines")

        local ret_row = math.ceil((h - wh) / 2 - 1)
        local ret_col = math.ceil((w - ww) / 2)

        return ret_row, ret_col
    end
    )

    createBorderLines()
end

local function createWindow()
    win = Window:new() 
    win:createBuffer({listed = false, scratch = true})
    win:setBufferOption({name = 'bufhidden', value = 'wipe'})
    win:setBufferOption({name = 'filetype', value = 'tutorial'})
    win:setWindowStyle("minimal")
    win:setWindowRelative("editor")

    win:setWindowDimensions(
    function()
        local w = vim.api.nvim_get_option("columns")
        local h = vim.api.nvim_get_option("lines")

        local ret_h = math.ceil(h * 0.8 - 4)
        local ret_w = math.ceil(w * 0.8)

        return ret_w, ret_h
    end
    )

    win:setWindowCoordinates(
    function(ww, wh)
        local w = vim.api.nvim_get_option("columns")
        local h = vim.api.nvim_get_option("lines")

        local ret_row = math.ceil((h - wh) / 2 - 1)
        local ret_col = math.ceil((w - ww) / 2)

        return ret_row, ret_col
    end
    )
end

local function openWindow()
    createWindow()
    createBorderWindow()

    bWin:open(true)
    win:open(true)

    win:setWindowOption({name='cursorline', value=true})
    setBorderWindowCloseHook()

    win:setBufferLines({
        start = 0, 
        finish = -1, 
        strict_indexing = false, 
        replacement = { utils.centralizeText('Centralized Text?'), '', ''}
    })
end

local function fetchData()
    local cmd = 'git diff-tree --no-commit-id --name-only -r HEAD~'
    local data = vim.api.nvim_call_function('systemlist', { cmd .. pos })

    if #data == 0 then
        table.insert(data, '')
    end

    for k,v in pairs(data) do
        data[k] = '  ' .. data[k]
    end

    return data
end

local function updateWindow(dir)
    win:setBufferOption({name = 'modifiable', value = true})

    if pos < 0 then
        pos = 0
    else
        pos = pos + dir
    end

    local data = fetchData()

    win:setBufferLines({
        start = 0, 
        finish = -1, 
        strict_indexing = false, 
        replacement = { utils.centralizeText('Centralized Text?'), '', ''}
    })

    win:setBufferLines({
        start = 1, 
        finish = 2, 
        strict_indexing = false, 
        replacement = { utils.centralizeText('HEAD~' .. pos), '', ''}
    })

    win:setBufferLines({
        start = 3, 
        finish = -1, 
        strict_indexing = false, 
        replacement = data
    })

    win:addBufferHI({
        ns_id = -1,
        hl_group = "tutorialHeader",
        line = 0,
        col_start = 0,
        col_end = -1,
    })

    win:addBufferHI({
        ns_id = -1,
        hl_group = "tutorialSubHeader",
        line = 1,
        col_start = 0,
        col_end = -1,
    })

    win:setBufferOption({name = 'modifiable', value = true})
end

local function closeWindow()
    win:close()
end

local function setWindowMappings()
    local mappings = {
        ['['] = 'update(-1)',
        [']'] = 'update(1)',
        ['<cr>'] = 'open_file()',
        h = 'update(-1)',
        l = 'update(1)',
        q = 'close()',
        k = 'move_cursor()'
    }

    local function setMapping(lhs, rhs, extra_opts)
        extra_opts = extra_opts or {nowait = true, noremap = true, silent = true}
        local opts = {
            mode = 'n',
            lhs = lhs,
            rhs = rhs,
            extra_opts = extra_opts,
        }
        win:setBufferMapping(opts)
    end

    for k,v in pairs(mappings) do
        local lhs = k
        local rhs = ':lua require"tutorial.tutorial".' .. v .. '<cr>'
        setMapping(lhs, rhs)
    end

    local other_chars = {
      'a', 'b', 'c', 'd', 'e', 
      'f', 'g', 'i', 'n', 'o', 
      'p', 'r', 's', 't', 'u', 
      'v', 'w', 'x', 'y', 'z'
    }

    for _,v in ipairs(other_chars) do
        setMapping(v, '')
        setMapping(v:upper(), '')
        setMapping('<c-' .. v .. '>', '')
    end
end

local function moveCursor()
    local nPos = win:getWindowCursor()
    win:setWindowCursor({nPos, 0})
end

local function openFile()
    local str = vim.api.nvim_get_current_line()
    closeWindow()
    vim.api.nvim_command('edit ' .. str)
end

local function start()
    pos = 0
    openWindow()
    setWindowMappings()
    updateWindow(0)
    win:setWindowCursor({4, 0})
end

return {
    start = start,
    update = updateWindow,
    open_file = openFile,
    move_cursor = moveCursor,
    close = closeWindow,
}
