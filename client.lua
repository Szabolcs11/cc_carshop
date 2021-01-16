local x, y = guiGetScreenSize()
local vehicles = {
    {411, "Infernus", 8000}, --Infernus
    {400, "Landstalker", 5000}, --Landstalker(NAGY)
    {445, "Admiral", 10000}, --Admiral,
    {410, "Manana", 2500}, --Manana(KICSI)
    {587, "Euros", 1950}, --Euros
}
local currentcar = 1;

function camera (button, state, _, _, _, _, _, clickedElement)
    if ( (button == "right") and (state == "up") ) then
        if (clickedElement) then 
            if (getElementData(clickedElement, "ped:type") == "carseller") then
                local pX, pY, pZ = getElementPosition(localPlayer);
                local pedX, pedY, pedZ = getElementPosition(clickedElement);
                local distance = getDistanceBetweenPoints3D(pX, pY, pZ, pedX, pedY, pedZ);
                if (distance < 5) then 
                    setElementFrozen(localPlayer, true)
                    setCameraMatrix(1556.20984, -1359.84827, 332.39398, 1547.34741, -1354.87048, 329.47842)
                    addEventHandler("onClientKey", root, navigation)
                    addEventHandler("onClientRender", root, panelrender)
                    addEventHandler("onClientClick", getRootElement(), click)
                    vehicle = createVehicle(411, 1546.30786, -1353.28479, 329.48099, 0, 0, 180)
                    setElementFrozen(vehicle, true)
                end
            end 
        end 
    end 
end 
addEventHandler("onClientClick", root, camera)

function navigation (button, state)
    if (button == "backspace" and state == false) then 
        allreset()
    end 
    if (button == "arrow_r" and state == false) then 
        if (currentcar < #vehicles) then 
            currentcar = currentcar + 1
            setElementModel(vehicle, vehicles[currentcar][1])
        end 
    end 

    if (button == "arrow_l" and state == false) then
        if (currentcar > 1) then 
            currentcar = currentcar - 1
            setElementModel(vehicle, vehicles[currentcar][1])
        end 
    end 
end

function allreset()
    setCameraTarget(localPlayer)
    setElementFrozen(localPlayer, false)
    removeEventHandler("onClientKey", root, navigation)
    removeEventHandler("onClientRender", root, panelrender)
    removeEventHandler("onClientClick", getRootElement(), click)
    destroyElement(vehicle)
    currentcar = 1
end 

function reset()
    setCameraTarget(localPlayer)
    destroyElement(vehicle)
    addEventHandler("onClientKey", root, navigation)
    addEventHandler("onClientRender", root, panelrender)
end 
addCommandHandler("reset", reset)

function panelrender ()
    dxDrawRectangle(x*0.75, y*0.78, x*0.23, y*0.2)
    dxDrawText(vehicles[currentcar][2], x*0.7+150, y*0.78, x*0.95, y*0.2, tocolor(255, 0, 0, 255), 4, "diploma", "center")
    if (isMouseInPosition(x*0.76, y*0.88, x*0.10, y*0.09)) then 
        dxDrawRectangle(x*0.76, y*0.88, x*0.10, y*0.09, tocolor(0, 250, 64, 180)) --Vásárlás
    else 
        dxDrawRectangle(x*0.76, y*0.88, x*0.10, y*0.09, tocolor(0, 250, 64, 255)) --Vásárlás
    end 
    dxDrawText("Vásárlás", x*0.63, y*0.9, x*0.99, y*0.09, tocolor(255, 255, 255, 255), 2, "diploma", "center")
    if (isMouseInPosition(x*0.87, y*0.88, x*0.10, y*0.09)) then 
        dxDrawRectangle(x*0.87, y*0.88, x*0.10, y*0.09, tocolor(255, 0, 64, 180)) --Mégse
    else 
        dxDrawRectangle(x*0.87, y*0.88, x*0.10, y*0.09, tocolor(255, 0, 64, 255)) --Mégse
    end 
    dxDrawText("Kilépés", x*0.85, y*0.9, x*0.99, y*0.09, tocolor(255, 255, 255, 255), 2, "diploma", "center")

end 

function click(button, state, x2, y2)
    if (button == "left" and state == "up") then 
        if (isMouseInPosition(x*0.87, y*0.88, x*0.10, y*0.09)) then 
            allreset()
        end 
    end

    if (button == "left" and state == "up") then 
        if (isMouseInPosition(x*0.76, y*0.88, x*0.10, y*0.09)) then 
            local money = getPlayerMoney(localPlayer)
            if(money >= vehicles[currentcar][3]) then 
                local player = getLocalPlayer()
                veh = tonumber(vehicles[currentcar][1])
                triggerServerEvent("buyvehicle", resourceRoot, veh, vehicles[currentcar][3], money)
                allreset()
            else 
                -- outputChatBox("Nincs elég pénzed!")
                exports["cc_infobox"]:addNotification("Nincs elég pénzed!")
            end 
        end 
    end
end 

function cursorInfo()
    if isCursorShowing() then -- if the cursor is showing
       local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
 
       outputChatBox( string.format( "Cursor screen position (relative): X=%.4f Y=%.4f", screenx, screeny ) ) -- make the accuracy of floats 4 decimals
       outputChatBox( string.format( "Cursor world position: X=%.4f Y=%.4f Z=%.4f", worldx, worldy, worldz ) ) -- make the accuracy of floats 4 decimals accurate
    else
       outputChatBox( "Your cursor is not showing." )
    end
 end
 addCommandHandler( "cursorpos", cursorInfo )

 function isMouseInPosition ( x2, y2, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * x ), ( cy * y )
	
	return ( ( cx >= x2 and cx <= x2 + width ) and ( cy >= y2 and cy <= y2 + height ) )
end

function isInBox(x,y,x2,y2)
	if (isCursorShowing()) then
		local cX, cY = getCursorPosition();--
		if ( (cX >= x) and (cY >= y) and (cX <= x2) and (cY <= y2) ) then
			return true;
		else
			return false;
		end
	end
end