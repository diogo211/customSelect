local renderingItems = false
local renderGrid = false
local select

local rectangles = {}

local config = {
    rot = 0,
    alphaI = 0,
    alphaF = 255,
    tickAlpha = getTickCount(),
    maxVisible = 8,
    window = { select = 0, scroll = 0 },
    arrowIcon = svgCreate(20, 20, [[
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M5 6L10 11L15 6L17 7L10 14L3 7L5 6Z" fill="#FFFFFF"/>
        </svg>
    ]])
}

local countrys = {
    'Afghanistan',
    'Algeria',
    'Argentina',
    'Australia',
    'Áustria',
    'Azerbaijão',
    'Brazil',
    'Bangladesh',
    'Bélgica',
    'Catar',
    'Chile',
}

local fonts = {
    roboto15 = dxCreateFont('fonts/Roboto-Regular.ttf', 15),
}

local function showSelect()
    if (not renderingItems) then
        addEventHandler('onClientRender', root, customSelect)
        renderingItems = true
    end
end

local function hideSelect()
    if (renderingItems) then
        removeEventHandler('onClientRender', root, customSelect)
        renderingItems = false
    end
end

function customSelect()
    local effectAlpha = interpolateBetween(config.alphaI, 0, 0, config.alphaF, 0, 0, (getTickCount() - config.tickAlpha)/250, 'Linear')

    drawRoundRect('backTitle', 778, 296, 363, 60, 10, tocolor(255, 255, 255, 255))
    dxDrawText((select ~= 0 and select or 'Select Country'), 795, 296, 346, 60, tocolor(0, 0, 0, 255), 1, fonts.roboto15, 'left', 'center')
    dxDrawImage(1101, 316, 20, 20, config.arrowIcon, config.rot, 0, 0, tocolor(0, 0, 0, 255))

    if (renderGrid) then
        drawRoundRect('backItems', 778, 373, 360, 350, 10, tocolor(255, 255, 255, effectAlpha))
        
        for i=1, config.maxVisible do
            if (i <= #countrys) then
                local index = config.window.scroll + i
                local margin = (388 - 40) + 40 * i
                dxDrawText(countrys[index], 795, margin, 332, 40, tocolor(0, 0, 0, effectAlpha), 1, fonts.roboto15, 'left', 'center')
            end
        end
    end
end

addEventHandler('onClientClick', root, function(button, state)
    if (renderingItems) then
        if (button == 'left' and state == 'down') then
            if (isCursorOnElement(1101, 316, 20, 20)) then
                if (not renderGrid) then
                    config.tickAlpha = getTickCount()
                    config.alphaI, config.alphaF = 0, 255
                    config.rot = 180
                    renderGrid = true
                else
                    config.tickAlpha = getTickCount()
                    config.alphaI, config.alphaF = config.alphaF, 0
                    config.rot = 0
                    setTimer(function() 
                        renderGrid = false
                    end, 250, 1)
                end
            end
            for i = 1, config.maxVisible do
                if (i <= #countrys) then
                    local index = config.window.scroll + i
                    local margin = (388 - 40) + 40 * i

                    if (isCursorOnElement(795, margin, 332, 40)) then
                        if (select ~= countrys[index]) then
                            select = countrys[index]
                        end
                    end
                end
            end
        end
    end
end)

addEventHandler('onClientKey', root, function(button, press)
    if (renderingItems and renderGrid) then
        if (press) then
            if (button == 'mouse_wheel_up' and config.window.scroll > 0) then
                config.window.scroll = config.window.scroll - 1
            elseif (button == 'mouse_wheel_down' and config.window.scroll < (#countrys - config.maxVisible)) then
                config.window.scroll = config.window.scroll + 1
            end
        end
    end
end)

function drawRoundRect(id, x, y, width, height, radius, color, postGUI)
    postGUI = postGUI or false
    if (not rectangles[id]) then
        local rawData = string.format([[
            <svg width="%s" height="%s" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect rx="%s" width="%s" height="%s" fill="#FFFFFF" />
            </svg>
        ]], width, height, radius, width, height)
        rectangles[id] = svgCreate(width, height, rawData)
    end
    if (rectangles[id]) then
        dxSetBlendMode('add')
        dxDrawImage(x, y, width, height, rectangles[id], 0, 0, 0, color, postGUI)
        dxSetBlendMode('blend')
    end
end

bindKey('F3', 'down', function()
    if (not renderingItems) then
        showSelect()
    else
        hideSelect()
    end
end)