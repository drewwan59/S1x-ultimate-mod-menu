function drawtext(player, type, font, fontscale, x, y, alignx, aligny, horzalign, vertalign, color, alpha, text)
    local elem = game:newclienthudelem(player)
    elem.elemType = type
    elem.font = font
    elem.fontscale = fontscale
    elem.x = x
    elem.y = y
    elem.alignx = alignx
    elem.aligny = aligny
    elem.horzalign = horzalign
    elem.vertalign = vertalign
    elem.color = color
    elem.alpha = alpha
    elem:settext(text)
    elem.hidewheninmenu = true

    return elem
end

function drawbox(player, type, x, y, alignx, aligny, horzalign, vertalign, color, alpha, material, matwidth, matlength)
    local elem = game:newclienthudelem(player)
    elem.elemType = type
    elem.x = x
    elem.y = y
    elem.alignx = alignx
    elem.aligny = aligny
    elem.horzalign = horzalign
    elem.vertalign = vertalign
    elem.color = color
    elem.alpha = alpha
    elem:setmaterial(material, matwidth, matlength)
    elem.hidewheninmenu = true

    return elem
end