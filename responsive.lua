local screen = {guiGetScreenSize()}
local resolution = {1920, 1080}
local screenScale = math.min(math.max(0.65, (screen[2]/resolution[2])), 2)

function isCursorOnElement (x, y, w, h)
    if (isCursorShowing ()) then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end

_dxCreateFont = dxCreateFont
function dxCreateFont (path, scale, ...)
    return _dxCreateFont (path, scale * screenScale, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = x * screenScale, y * screenScale, w * screenScale, h * screenScale
    return _dxDrawImage(x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = x * screenScale, y * screenScale, w * screenScale, h * screenScale
    return _dxDrawImageSection(x, y, w, h, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = x * screenScale, y * screenScale, w * screenScale, h * screenScale
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    local x, y, w, h = x * screenScale, y * screenScale, (w + x) * screenScale, (h + y) * screenScale
    return _dxDrawText(text, x, y, w, h, ...)
end

_isCursorOnElement = isCursorOnElement
function isCursorOnElement(x, y, w, h)
    local x, y, w, h = x * screenScale, y * screenScale, w * screenScale, h * screenScale
    return _isCursorOnElement(x, y, w, h)
end