local M = {}

function M.open_current_buffer_to_window(from_window, to_window, enter)
    local bufnr = vim.api.nvim_win_get_buf(from_window)
    local topline = vim.api.nvim_win_call(from_window, function()
        return vim.fn.line "w0"
    end)
    local pos = vim.api.nvim_win_get_cursor(from_window)

    vim.api.nvim_win_set_buf(to_window, bufnr)
    vim.api.nvim_win_set_cursor(to_window, pos)
    vim.api.nvim_win_call(to_window, function()
        vim.fn.winrestview { topline = topline }
    end)

    if enter then
        vim.api.nvim_set_current_win(to_window)
    end
end

function M.move_current_buffer_to_window(from_window, to_window, enter)
    M.open_current_buffer_to_window(from_window, to_window, enter)
    vim.schedule(function()
        vim.api.nvim_win_call(from_window, function()
            vim.cmd [[e#]] --  Jump to previously edited file
        end)
    end)
end

local function get_next_window()
    local all_windows = vim.api.nvim_tabpage_list_wins(0)
    if #all_windows == 1 then
        -- Create vertical split if there is only one window
        vim.cmd [[wincmd v]]
        vim.cmd [[wincmd p]]
        all_windows = vim.api.nvim_tabpage_list_wins(0)
    end
    local current_window_number = vim.api.nvim_win_get_number(0)
    local next_window_number = (current_window_number % #all_windows) + 1
    return vim.fn.win_getid(next_window_number)
end

local function get_current_window()
    local current_window_number = vim.api.nvim_win_get_number(0)
    return vim.fn.win_getid(current_window_number)
end

function M.open_in_next_window(enter)
    M.open_current_buffer_to_window(get_current_window(), get_next_window(), enter)
end

function M.move_to_next_window(enter)
    M.move_current_buffer_to_window(get_current_window(), get_next_window(), enter)
end

return M
