-----------------------------------------------------------
-- INSTRUCTIONS PLEASE READ OR ELSE SCRIPT WILL NOT WORK --
-----------------------------------------------------------
-- It will be better if the pokemon that you want to level is at least level 8
-- Put the pokemon that you want to level in the FIRST place
-- If your pokemon level is less than 15, start the script on Route 4
-- If your pokemon level between 15 and 24, start the script on Route 10 (Near the Pokecenter at Route 10)
-- If your pokemon level between 25 and 34, start the script in Digletts Cave Entrance 2
-- If your pokemon level between 35 and 54, start the script on Route 13
-- If your pokemon level is greater than 54, start the script on Victory Road 3F

------------------------------------------------
-------------------- Config --------------------
------------------------------------------------
-- If this is true
--    Please set the index of the pokemon that can DIG through mountains
--    Please make sure that you have a pokemon that knows CUT
-- If this is false
--    You will then need a pokemon in your team that can SURF
digMountains = true
digIndex = 2

-- Set your mount
mount = "Bicycle"

-- List of Pokemons that you would like to catch while leveling
catchList = {"Jigglypuff", "Electabuzz", "Chansey"}

--------------------------------------------------------------
-- Only touch the code below if you know what you are doing --
--------------------------------------------------------------
name = "Automated Leveling"
author = "barriot"
description = "Level the first pokemon in your team to level 100"

function onStart ()
	routeTenDig = false
	RouteTwoStop = false
	seafoamEntrance = true

	if digMountains then
		if not hasMove(digIndex, "Dig") then
			fatal ("You have selected to dig through mountains but the pokemon you picked does not know Dig")
		end
	end
end

function onPathAction ()
	pkmLevel = getPokemonLevel (1)

	if pkmLevel < 8 then
		fatal ("The first pokemon in your team is too weak to level on Route 4")
	elseif pkmLevel == 100 then
		fatal ("The first pokemon in your team is already level 100")
	end

	if not isMounted () and hasItem (mount) and isOutside () and not isSurfing () then
		useItem (mount)
      	log ("Getting on mount")
	elseif pkmLevel < 15 then
    	levelOnRouteFour ()
	elseif pkmLevel >= 15 and pkmLevel < 25 then
		if isOnMap ("Route 4") or isOnMap ("Cerulean City") or isOnMap ("Route 9") or
			isOnMap ("Pokecenter Cerulean") then
			moveFromFourToTen ()
		else
			levelOnRouteTen ()
		end 
	elseif pkmLevel >= 25 and pkmLevel < 35 then
		if digMountains then
			if isOnMap ("Route 10") or isOnMap ("Lavender Town") or isOnMap ("Route 12") or
				isOnMap ("Route 11 Stop House") or isOnMap ("Pokecenter Route 10") then
				moveFromTenToEleven ()
			else
				levelOnDiglettsCave ()
			end
		else
			if isOnMap ("Route 10") or isOnMap ("Route 9") or isOnMap ("Cerulean City") or
				isOnMap ("Route 5") or isOnMap ("Route 5 Stop House") or isOnMap ("Saffron City") or
				isOnMap ("Route 6 Stop House") or isOnMap ("Route 6") or isOnMap ("Pokecenter Route 10") then
				moveFromTenToVermilion ()
			else
				levelOnDiglettsCave ()
			end
		end
	elseif pkmLevel >= 35 and pkmLevel < 55 then
		if isOnMap ("Digletts Cave Entrance 2") or isOnMap ("Route 11") or isOnMap ("Route 11 Stop House") or
			isOnMap ("Route 12") or isOnMap ("Vermilion City") or isOnMap ("Pokecenter Vermilion") then
			moveFromDiglettsToThirteen ()
		else
			levelOnRouteThirteen ()
		end
	elseif pkmLevel >= 55 then
		if digMountains then
			if isOnMap ("Route 13") or isOnMap ("Route 12") or isOnMap ("Route 11 Stop House") or
				isOnMap ("Route 11") or isOnMap ("Route 2") or isOnMap ("Route 2 Stop3") or
				isOnMap ("Viridian City") or isOnMap ("Pokecenter Viridian") or isOnMap ("Route 22") or 
				isOnMap ("Pokemon League Reception Gate") or isOnMap ("Victory Road Kanto 1F") or isOnMap ("Victory Road Kanto 2F") or
				isOnMap ("Berry Tower Reception Kanto") then
				moveFromThirteenToVictoryWithDig ()
			else
				levelOnVictoryRoad ()
			end
		else
			if isOnMap ("Route 13") or isOnMap ("Route 14") or isOnMap ("Route 15") or 
				isOnMap ("Route 15 Stop House") or isOnMap ("Fuchsia City") or isOnMap ("Fuchsia City Stop House") or 
				isOnMap ("Route 19") or isOnMap ("Route 20") or isOnMap ("Seafoam 1F") or 
				isOnMap ("Seafoam B1F") or isOnMap ("Cinnabar Island") or isOnMap ("Pokecenter Cinnabar") or 
				isOnMap ("Route 21") or isOnMap ("Pallet Town") or isOnMap ("Route 1") or 
				isOnMap ("Route 1 Stop House") or isOnMap ("Viridian City") or isOnMap ("Pokecenter Viridian") or 
				isOnMap ("Route 22") or isOnMap ("Pokemon League Reception Gate") or isOnMap ("Victory Road Kanto 1F") or 
				isOnMap ("Victory Road Kanto 2F") or isOnMap ("Berry Tower Reception Kanto") then
				moveFromThirteenToVictory ()
			else
				levelOnVictoryRoad ()
			end
		end
	end
end

function onBattleAction ()
	if isWildBattle() and (isOpponentShiny() or not isAlreadyCaught () or isPokemonInList ()) then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	elseif getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end

function onDialogMessage(message)
	if message == "Please select a Pokemon that knows the Dig technique." then
		pushDialogAnswer(digIndex)
	elseif message == "Reselect a different Pokemon?" then
		fatal ("Failed to Dig")
	end
end

-------------------------------------
-- Comparison or Checking Function --
-------------------------------------
function isOnMap (mapName)
	if getMapName () == mapName then
		return true
	else
		return false
	end
end

function isPokemonInList ()
	if catchList[1] ~= "" then
		for i = 1, tableLength (catchList), 1 do
			if getOpponentName() == catchList[i] then
				return true
			end
		end
	end

	return false
end

function tableLength (t)
	local count = 0
		for _ in pairs(t) do 
			count = count + 1 
		end
	return count
end

------------------------
-- Leveling functions --
------------------------
function levelOnRouteFour ()
	if isPokemonUsable (1) then
		if getMapName () == "Pokecenter Cerulean" then
			moveToMap ("Cerulean City")
		elseif getMapName () == "Cerulean City" then
			moveToMap ("Route 4")
		elseif getMapName () == "Route 4" then
			moveToGrass ()
		end
	else
		if getMapName () == "Route 4" then
			moveToMap ("Cerulean City")
		elseif getMapName () == "Cerulean City" then
			moveToMap ("Pokecenter Cerulean")
		elseif getMapName () == "Pokecenter Cerulean" then
			usePokecenter ()
		end
	end
end

function levelOnRouteTen ()
	if isPokemonUsable (1) then
		if getMapName () == "Pokecenter Route 10" then
			moveToMap ("Route 10")
		elseif getMapName () == "Route 10" then
			moveToGrass ()
		end
	else
		if getMapName () == "Route 10" then
			moveToMap ("Pokecenter Route 10")
		elseif getMapName () == "Pokecenter Route 10" then
			usePokecenter ()
		end
	end
end

function levelOnDiglettsCave ()
	if isPokemonUsable (1) then
		if getMapName () == "Pokecenter Vermilion" then
			moveToMap ("Vermilion City")
		elseif getMapName () == "Vermilion City" then
			moveToMap ("Route 11")
		elseif getMapName () == "Route 11" then
			moveToMap ("Digletts Cave Entrance 2")
		elseif getMapName () == "Digletts Cave Entrance 2" then
			moveToRectangle (15, 26, 25, 27)
		end
	else
		if getMapName () == "Digletts Cave Entrance 2" then
			moveToMap ("Route 11")
		elseif getMapName () == "Route 11" then
			moveToMap ("Vermilion City")
		elseif getMapName () == "Vermilion City" then
			moveToMap ("Pokecenter Vermilion")
		elseif getMapName () == "Pokecenter Vermilion" then
			usePokecenter ()
		end
	end
end

function levelOnRouteThirteen ()
	if isPokemonUsable(1) then
		if getMapName() == "Berry Tower Reception Kanto" then
			moveToMap("Route 13")
		elseif getMapName() == "Route 13" then
			moveToGrass ()
		end
	else
		if getMapName() == "Route 13" then
			moveToMap("Berry Tower Reception Kanto")
		elseif getMapName() == "Berry Tower Reception Kanto" then
			talkToNpcOnCell(4, 12)
		end
	end
end

function levelOnVictoryRoad ()
	if isPokemonUsable(1) then
		if getMapName() == "Indigo Plateau Center" then
			moveToMap("Indigo Plateau")
		elseif getMapName() == "Indigo Plateau" then
			moveToMap("Victory Road Kanto 3F")
		elseif getMapName() == "Victory Road Kanto 3F" then
			moveToRectangle(46, 14, 47, 22)
		end
	else
		if getMapName() == "Victory Road Kanto 3F" then
			moveToMap("Indigo Plateau")
		elseif getMapName() == "Indigo Plateau" then
			moveToMap("Indigo Plateau Center")
		elseif getMapName() == "Indigo Plateau Center" then
			talkToNpcOnCell(4, 22)
		end
	end
end

------------------------
-- Movement functions --
------------------------
function moveFromFourToTen ()
	if getMapName () == "Route 4" then
		moveToMap ("Cerulean City")
	elseif getMapName () == "Cerulean City" then
		moveToMap ("Route 9")
	elseif getMapName () == "Route 9" then
		moveToMap ("Route 10")
	elseif getMapName () == "Pokecenter Cerulean" then
		moveToMap ("Cerulean City")
	end
end

function moveFromTenToEleven ()
	if getMapName () == "Route 10" and not routeTenDig then
		talkToNpcOnCell (9, 9)
		routeTenDig = true
	elseif getMapName () == "Route 10" and routeTenDig then
		moveToMap ("Lavender Town")
	elseif getMapName () == "Lavender Town" then
		moveToMap ("Route 12")
	elseif getMapName () == "Route 12" then
		moveToMap ("Route 11 Stop House")
	elseif getMapName () == "Route 11 Stop House" then
		moveToMap ("Route 11")
	elseif getMapName () == "Pokecenter Route 10" then
		moveToMap ("Route 10")
		routeTenDig = false
	end
end

function moveFromTenToVermilion ()
	if getMapName () == "Route 10" then
		moveToMap ("Route 9")
	elseif getMapName () == "Route 9" then
		moveToMap ("Cerulean City")
	elseif getMapName () == "Cerulean City" then
		moveToMap ("Route 5")
	elseif getMapName () == "Route 5" then
		moveToMap ("Route 5 Stop House")
	elseif getMapName () == "Route 5 Stop House" then
		moveToMap ("Saffron City")
	elseif getMapName () == "Saffron City" then
		moveToMap ("Route 6 Stop House")
	elseif getMapName () == "Route 6 Stop House" then
		moveToMap ("Route 6")
	elseif getMapName () == "Route 6" then
		moveToMap ("Vermilion City")
	elseif getMapName () == "Pokecenter Route 10" then
		moveToMap ("Route 10")
	end
end

function moveFromDiglettsToThirteen ()
	if getMapName () == "Digletts Cave Entrance 2" then
		moveToMap ("Route 11")
	elseif getMapName () == "Route 11" then
		moveToMap ("Route 11 Stop House")
	elseif getMapName () == "Route 11 Stop House" then
		moveToMap ("Route 12")
	elseif getMapName () == "Route 12" then
		moveToMap ("Route 13")
	elseif getMapName () == "Pokecenter Vermilion" then
		moveToMap ("Vermilion City")
	elseif getMapName () == "Vermilion City" then
		moveToMap ("Route 11")
	end
end

function moveFromThirteenToVictoryWithDig ()
	if getMapName () == "Route 13" then
		moveToMap ("Route 12")
	elseif getMapName () == "Route 12" then
		moveToMap ("Route 11 Stop House")
	elseif getMapName () == "Route 11 Stop House" then
		moveToMap ("Route 11")
	elseif getMapName () == "Route 11" then
		talkToNpcOnCell (12, 12)
	elseif getMapName () == "Route 2" and not routeTwoStop then
		moveToMap ("Route 2 Stop3")
	elseif getMapName () == "Route 2 Stop3" then
		moveToCell (3, 12)
		routeTwoStop = true
	elseif getMapName () == "Route 2" and routeTwoStop then
		moveToMap ("Viridian City")
	elseif getMapName () == "Viridian City" and not isPokemonUsable (1) then
		moveToMap ("Pokecenter Viridian")
	elseif getMapName () == "Pokecenter Viridian" and not isPokemonUsable (1) then
		usePokecenter ()
	elseif getMapName () == "Pokecenter Viridian" and isPokemonUsable (1) then
		moveToMap ("Viridian City")
	elseif getMapName () == "Viridian City" and isPokemonUsable (1) then
		moveToMap ("Route 22")
	elseif getMapName () == "Route 22" then
		moveToMap ("Pokemon League Reception Gate")
	elseif getMapName () == "Pokemon League Reception Gate" then
		moveToMap ("Victory Road Kanto 1F")
	elseif getMapName () == "Victory Road Kanto 1F" then
		moveToMap ("Victory Road Kanto 2F")
	elseif getMapName () == "Victory Road Kanto 2F" then
		moveToMap ("Victory Road Kanto 3F")
	elseif getMapName () == "Berry Tower Reception Kanto" then
		moveToMap ("Route 13")
	end
end

function moveFromThirteenToVictory ()
	if getMapName () == "Route 13" then
		moveToMap ("Route 14")
	elseif getMapName () == "Route 14" then
		moveToMap ("Route 15")
	elseif getMapName () == "Route 15" then
		moveToMap ("Route 15 Stop House")
	elseif getMapName () == "Route 15 Stop House" then
		moveToMap ("Fuchsia City")
	elseif getMapName () == "Fuchsia City" then
		moveToMap ("Fuchsia City Stop House")
	elseif getMapName () == "Fuchsia City Stop House" then
		moveToMap ("Route 19")
	elseif getMapName () == "Route 19" then
		moveToMap ("Route 20")
	elseif getMapName () == "Route 20" and seafoamEntrance then
		moveToMap ("Seafoam 1F")
	elseif getMapName () == "Seafoam 1F" and seafoamEntrance then
		moveToMap ("Seafoam B1F")
	elseif getMapName () == "Seafoam B1F" then
		seafoamEntrance = false
		moveToCell (85, 22)
	elseif getMapName () == "Seafoam 1F" and not seafoamEntrance then
		moveToMap ("Route 20")
	elseif getMapName () == "Route 20" and not seafoamEntrance then
		moveToMap ("Cinnabar Island")
	elseif getMapName () == "Cinnabar Island" and not isPokemonUsable (1) then
		moveToMap ("Pokecenter Cinnabar")
	elseif getMapName () == "Pokecenter Cinnabar" and not isPokemonUsable (1) then
		usePokecenter ()
	elseif getMapName () == "Pokecenter Cinnabar" and isPokemonUsable (1) then
		moveToMap ("Cinnabar Island")
	elseif getMapName () == "Cinnabar Island" and isPokemonUsable (1) then
		moveToMap ("Route 21")
	elseif getMapName () == "Route 21" then
		moveToMap ("Pallet Town")
	elseif getMapName () == "Pallet Town" then
		moveToMap ("Route 1")
	elseif getMapName () == "Route 1" then
		moveToMap ("Route 1 Stop House")
	elseif getMapName () == "Route 1 Stop House" then
		moveToMap ("Viridian City")
	elseif getMapName () == "Viridian City" and not isPokemonUsable (1) then
		moveToMap ("Pokecenter Viridian")
	elseif getMapName () == "Pokecenter Viridian" and not isPokemonUsable (1) then
		usePokecenter ()
	elseif getMapName () == "Pokecenter Viridian" and isPokemonUsable (1) then
		moveToMap ("Viridian City")
	elseif getMapName () == "Viridian City" and isPokemonUsable (1) then
		moveToMap ("Route 22")
	elseif getMapName () == "Route 22" then
		moveToMap ("Pokemon League Reception Gate")
	elseif getMapName () == "Pokemon League Reception Gate" then
		moveToMap ("Victory Road Kanto 1F")
	elseif getMapName () == "Victory Road Kanto 1F" then
		moveToMap ("Victory Road Kanto 2F")
	elseif getMapName () == "Victory Road Kanto 2F" then
		moveToMap ("Victory Road Kanto 3F")
	elseif getMapName () == "Berry Tower Reception Kanto" then
		moveToMap ("Route 13")
		seafoamEntrance = false
	end
end
