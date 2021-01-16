--connection = dbConnect("mysql", "dbname=clubeclub;host=127.0.0.1;charset=utf8", "root", "", "share=1");
local connection = exports.cc_mysql:getConnection();

local cardealer = createPed(141, 1581.50769, -1357.66199, 16.48438, 270);
setElementFrozen(cardealer, true)
setElementData(cardealer, "ped:type", "carseller");

function buyvehicle(vehicle, price, money)
    setPlayerMoney(client, money-price)
    outputChatBox("Sikeresen vásároltál egy járművet")
    local veh = tonumber(vehicle)
    local car = createVehicle(veh, 1546.30786, -1353.28479, 329.48099)
    warpPedIntoVehicle(client, car)
    local x, y, z = getElementPosition(car)
    local rotx, roty, rotz = getElementRotation(car)
    local r, g, b = getVehicleColor(car, true)
    local dimension = getElementDimension(car)
    local interior = getElementInterior(car)
    local health = getElementHealth(car)
    local serial = getPlayerSerial(client)
    local vehiclename = getVehicleName(car)
    local qh = dbQuery(connection, "INSERT INTO vehicles SET ownerserial=?, model=?, x=?, y=?, z=?, rotx=?, roty=?, rotz=?, r=?, g=?, b=?, dimension=?, interior=?, health=?", serial, vehicle, x, y, z, rotx, roty, rotz, r, g, b, dimension, interior, health)
    local res = dbPoll(qh, 150, true);
    if (res) then 
        outputChatBox("Sikeresen megvásároltad a "..vehiclename.." járművet")
        setElementData(car, "veh:id", res[1][3])
        iprint(res[1][3])
        setElementData(car, "owner", serial)
    else 
        destroyElement(car)
        setElementData(client, "vehowner", false)
    end 
    dbFree(qh)
end 
addEvent("buyvehicle", true)
addEventHandler("buyvehicle", resourceRoot, buyvehicle)

function getVehicleId(player, cmd)
	local veh = getPedOccupiedVehicle(player);
	if (veh) then
		local id = getElementData(veh, "veh:id");
		outputChatBox("A jármű ID-je: "..id, client);
	end
end
addCommandHandler("vehid", getVehicleId, false, false);



addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
	function()
		local qh = dbQuery(connection, "SELECT * FROM vehicles");
		local vehicles = dbPoll(qh, -1);
		if (vehicles) then
			if (#vehicles > 0) then
				for i, vehicle in ipairs(vehicles) do
					local x, y, z = vehicle["x"], vehicle["y"], vehicle["z"]
					local vehRot = vehicle["rotx"], vehicle["roty"], vehicle["rotz"]
					local r, g, b = vehicle["r"], vehicle["g"], vehicle["b"]
					local veh = createVehicle(vehicle["model"], vehicle["x"], vehicle["y"], vehicle["z"], vehicle["rotx"], vehicle["roty"], vehicle["rotz"])
					setVehicleColor(veh, vehicle["r"], vehicle["g"], vehicle["b"])
					setElementData(veh, "veh:id", vehicle["id"])
					setElementData(veh, "owner", vehicle["ownerserial"])
				end
			end
		end
	end
);


function parkVehicle(player, cmd)
	local veh = getPedOccupiedVehicle(player);
	if (veh) then
		local serial = getPlayerSerial(player);
		local owner = getElementData(veh, "owner");
		if (owner == serial) then
			local vehId = getElementData(veh, "veh:id");
			local x,y,z = getElementPosition(veh);
            local rotx, roty, rotz = getElementRotation(veh);
            local r, g, b = getVehicleColor(veh, true)
            local dimension = getElementDimension(veh)
            local interior = getElementInterior(veh)
            local health = getElementHealth(veh)
			setVehicleRespawnPosition(veh, x,y,z, rx, ry, rz);
			local exec = dbExec(connection, "UPDATE vehicles SET x=?, y=?, z=?, rotx=?, roty=?, rotz=?, r=?, g=?, b=?, dimension=?, interior=?, health=?  WHERE id=?", x, y, z, rotx, roty, rotz, r, g, b, dimension, interior, health, vehId);
			if (exec) then
				outputChatBox("Járműved sikeresen leparkoltad.", player);
			else
				outputChatBox("Járművedet nem sikerült leparkolni.", player);
			end
		else
			outputChatBox("A jármű nem a tiéd!", player);
		end
	end
end
addCommandHandler("park", parkVehicle, false, false);


function makeveh(player, vehicle) 
    outputChatBox("Sikeresen vásároltál egy járművet")
    local veh = tonumber(vehicle)
    local car = createVehicle(veh, 1546.30786, -1353.28479, 329.48099)
    -- warpPedIntoVehicle(client, car)
    local x, y, z = getElementPosition(car)
    local rotx, roty, rotz = getElementRotation(car)
    local r, g, b = getVehicleColor(car, true)
    local dimension = getElementDimension(car)
    local interior = getElementInterior(car)
    local health = getElementHealth(car)
    local serial = getPlayerSerial(player)
    local vehiclename = getVehicleName(car)
    local qh = dbQuery(connection, "INSERT INTO vehicles SET ownerserial=?, model=?, x=?, y=?, z=?, rotx=?, roty=?, rotz=?, r=?, g=?, b=?, dimension=?, interior=?, health=?", serial, vehicle, x, y, z, rotx, roty, rotz, r, g, b, dimension, interior, health)
    local res = dbPoll(qh, 150, true);
    if (res) then 
        outputChatBox("Sikeresen lehívtad a "..vehiclename.." járművet")
        setElementData(car, "veh:id", res[1][3])
        iprint(res[1][3])
        setElementData(car, "owner", serial)
    else 
        destroyElement(car)
        setElementData(client, "vehowner", false)
    end 
    dbFree(qh)
end


function playerEnterVehicle ( theVehicle, seat, jacked )
    -- Get the colors of the car and store them to 4 seperate variables
    local color1, color2, color3 = getVehicleColor ( theVehicle, true )
    -- Output the four retrieved car colors into the chatbox
    outputChatBox (color1.." "..color2.." "..color3 )
end
addEventHandler ( "onPlayerVehicleEnter", root, playerEnterVehicle )

function color(player)
    local veh = getPedOccupiedVehicle(player)
    setVehicleColor(veh, 0, 0, 0)
end 
addCommandHandler("asd", color)