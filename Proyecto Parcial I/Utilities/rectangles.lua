local M = {}

function M.createRectImage(sceneGroup, path, sizeX, sizeY, posX, posY)
    local rectImage = display.newImageRect(sceneGroup, path, sizeX, sizeY)
    rectImage.x = posX
    rectImage.y = posY
    return rectImage
end

return M

