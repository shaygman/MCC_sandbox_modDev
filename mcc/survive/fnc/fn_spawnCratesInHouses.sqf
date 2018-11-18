/* ======================================================MCC_fnc_spawnCratesInHouses==============================================================================
	Spawn lootable crates in houeses

	<IN>
		Nothing

	<OUT>
		Nothing
==============================================================================================================================================================*/
if (!isServer) exitWith {};
#define	WEAPONHOLDER "weaponholdersimulated"

systemChat "hello";

private ["_index","_buildings","_availablePos","_buildingPos","_path"];
params [
		["_pos",[0,0,0],[[]]],
		["_radius",300,[0]],
		["_density",1,[0]],
		["_debug",false,[false]]
	];


if (_pos isEqualTo [0,0,0]) exitWith {};

_buildings = _pos nearObjects ["House",_radius];
_index = missionNamespace getVariable ["MCC_itemMarker_index",0];

_path = if (isClass (missionconfigFile >> "CfgMCCspawnItems")) then {(missionconfigFile >> "CfgMCCspawnItems")} else {(configFile >> "CfgMCCspawnItems")};
//Get what we can have in the loot from the server
{
	if (isNil _x) then {
		missionNamespace setVariable [_x,getArray (_path >> _x >> "itemClasses")];
	};
} forEach ["MCC_medItems","MCC_fuelItems","MCC_repairItems","MCC_foodItem","MCC_money","MCC_fruits","MCC_survivalWeapons","MCC_survivalMagazines","MCC_survivalAttachments"];

//No user defined weapons use MCC defaults
if (count (missionNamespace getVariable ["MCC_survivalWeapons",[]]) <= 0) then {
	missionNamespace setVariable ["MCC_survivalWeapons",W_BINOS + W_LAUNCHERS + W_MG + W_PISTOLS + W_RIFLES + W_SNIPER];
};

if (count (missionNamespace getVariable ["MCC_survivalMagazines",[]]) <= 0) then {
	missionNamespace setVariable ["MCC_survivalMagazines",U_MAGAZINES + U_UNDERBARREL +U_GRENADE + U_EXPLOSIVE];
};

if (count (missionNamespace getVariable ["MCC_survivalAttachments",[]]) <= 0) then {
	missionNamespace setVariable ["MCC_survivalAttachments",W_ATTACHMENTS];
};

private ["_randomChance","_randomAmmount","_array","_max","_loot","_class","_magazines"];
//Loop all buildings
{
	_availablePos = [];

	for "_i" from 0 to 20 do {
	    _buildingPos = _x buildingpos _i;
	    if (str _buildingPos == "[0,0,0]") exitwith {};
	    _availablePos pushBack _buildingPos;
	};

	//Increase chance for ammo and weapons in military buildings "Weapon","Ammo","Med","Fuel","Repair","Food","Money","fruit"
	if (["mil",typeOf _x] call BIS_fnc_inString) then {
		_randomChance = [20,20,10,10,20,20,5,1];
		_randomAmmount = [1,4,2,2,2,2,5,1];
	} else {
		_randomChance = [5,10,10,10,20,20,5,1];
		_randomAmmount = [1,2,2,2,2,2,5,1];
	};

	{
		if (random 100 < _density) then {
			//_object = (["Land_Sack_F","Land_MetalBarrel_F","Land_MetalCase_01_small_F","Land_PlasticCase_01_small_F"] call BIS_fnc_selectRandom) createVehicle _x;
			_object = createvehicle [WEAPONHOLDER,_x ,[], 0, "can_Collide"];
			_object setPos _x;
			_object setDir (random 360);
			_index = _index +1;

			//Random Loot
			_loot = [];

			while {count _loot == 0} do
			{
				{
					_array = [MCC_survivalWeapons + MCC_survivalAttachments,
					          MCC_survivalMagazines,
					          MCC_medItems,
					          MCC_fuelItems,
					          MCC_repairItems,
					          MCC_foodItem,
					          MCC_money,
					          MCC_fruits] select _foreachIndex;

					if (count _array > 0 && random 100 < _x) then {
						_max = (floor random (_randomAmmount select _foreachIndex)) +1;

						for "_i" from 0 to _max do {
							_loot pushBack ((_array call BIS_fnc_selectRandom) select 0);
						};
					};
				} forEach _randomChance;
			};


			//Add loot to box
			for "_i" from 0 to (count _loot -1) do {
				_class = _loot select _i;
				switch (true) do {
					case (isClass (configFile >> "CfgMagazines" >> _class)) : {
						_object addMagazineCargoGlobal [_class,1];
					};

					case (isClass (configFile >> "CfgWeapons" >> _class)) : {
						_object addWeaponCargoGlobal [_class,1];

						//Not a weapon must be an item
						if !(_class in weaponCargo _object) then {
							_object addItemCargoGlobal [_class,1];
						} else {

							//Is a weapon add one magazine
							_magazines = getArray (configfile >> "CfgWeapons" >> _class >> "magazines");
							if (count _magazines > 0) then {
								_object addMagazineCargoGlobal [_magazines select 0,1];
							};
						};
					};
				};
			};

			//Debug
			if (_debug) then {
				_eib_marker = createMarker [format ["itemMarker_%1", _index],_x];
				_eib_marker setMarkerType "mil_dot";
				_eib_marker setMarkerColor "ColorRed";
			};
		};
	} forEach _availablePos;
} foreach _buildings;

missionNamespace setVariable ["MCC_itemMarker_index",_index];
//Debug
if (_debug) then {
	systemChat format ["Total of %1 items created", _index];
};


/*
{
	_temploc = [_mapCenter,5000,_x] call MCC_fnc_MWbuildLocations;
	{
		_buildings = (getpos (_x select 0)) nearObjects ["House",500];

	    {
	    	_availablePos = [];

			for "_i" from 0 to 20 do {
			    _buildingPos = _x buildingpos _i;
			    if (str _buildingPos == "[0,0,0]") exitwith {};
			    _availablePos pushBack _buildingPos;
			};

			{
				if (random 100 < 3) then {
					_object = (["Land_Sack_F","Land_MetalBarrel_F","Land_MetalCase_01_small_F","Land_PlasticCase_01_small_F"] call BIS_fnc_selectRandom) createVehicle _x;
					_object setPos _x;
					_object setDir (random 360);
				};
			} forEach _availablePos;
	    } foreach _buildings;
	} forEach _temploc;
} forEach ["city","mil","nature"];
*/