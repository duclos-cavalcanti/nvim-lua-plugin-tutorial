
local function centralizeText(str)
    local width = vim.api.nvim_win_get_width(0)
    local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
    local c_str = string.rep(' ', shift) .. str

    return c_str
end

return {
    centralizeText,
}
