-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 
---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "obsidian-ember",
    changed_themes = { 
        ["obsidian-ember"] = {
            base_16 = {
                base00 = "#1e1e1e",
                base01 = "#2c2c2c",
                base02 = "#333333",
                base03 = "#3a3a3a",
                base04 = "#ffffff",
                base05 = "#aaaaaA",
                base06 = "#ffffff",
                base07 = "#8FBCBB",
                base08 = "#ff2222",
                base09 = "#ffffff",
                base0A = "#ff2222",
                base0B = "#848484",
                base0C = "#ffffff",
                base0D = "#ffffff",
                base0E = "#ffffff",
                base0F = "#ffffff"
            },
            base_30 = {
                white = "#ffffff",
                darker_black = "#161616",
                black = "#1e1e1e", --  nvim bg
                black2 = "#252525",
                one_bg = "#2c2c2c",
                one_bg2 = "#333333",
                one_bg3 = "#3a3a3a",
                grey = "#414141",
                grey_fg = "#484848",
                grey_fg2 = "#4f4f4f",
                light_grey = "#565656",
                red = "#ff2222",
                baby_pink = "#de878f",
                pink = "#d57780",
                line = "#333333", -- for lines like vertsplit
                green = "#888888",
                vibrant_green = "#76c793",
                blue = "#eeeeee",
                nord_blue = "#ffffff",
                yellow = "#ffaa22",
                sun = "#ffaa22",
                purple = "#555555",
                dark_purple = "#ff2222",
                teal = "#00ffff",
                orange = "#cd6316",
                cyan = "#00c3a5",
                statusline_bg = "#222222",
                lightbg = "#303030",
                pmenu_bg = "#ff2222",
                folder_bg = "#ff2222"
            }
        }
    },
    hl_override = {
        ["@keyword"] = {
            fg = "#ff2222",
            bold = true -- 设为加粗
        },
        ["StorageClass"] = {
            fg = "#ff2222",
            bold = true -- 设为加粗
        },
        ["Keyword"] = {
            fg = "#ff2222",
            bold = true -- 设为加粗
        },
        ["Macro"] = {
            fg = "#ff2222",
            bold = true
        },
        ["Type"] = {
            fg = "#22bbbb",
            bold = true
        },
        ["String"] = {
            fg = "#ffffff",
        },
        ["Variable"] = {
            italic = true
        },
    },
    transparency = true,
}

return M
