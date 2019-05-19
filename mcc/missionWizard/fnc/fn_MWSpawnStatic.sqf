/*=================================================MCC_fnc_MWSpawnStatic=========================================================================================================
	Spawn infantry groups in the zone.
	Example:[_totalEnemyUnits,_missionCenter,_radius,_arrayUnits,_priceGroup,_priceUnit,_side,_artillery] call MCC_fnc_MWSpawnStatic;
	Return - handler
================================================================================================================================================================================*/
private ["_side","_unitPlaced","_totalEnemyUnits","_radius","_arrayUnits","_group","_init","_perSpawn","_spawnPos","_zone","_marker","_priceGroup","_priceUnit","_price","_artillery","_pos","_missionCenter","_availablePos","_vehicleClass","_vehicle","_time","_enableMarkers"];
_totalEnemyUnits	= _this select 0;
_missionCenter		= _this select 1;
_radius				= _this select 2;
_arrayUnits			= _this select 3;
_priceGroup			= _this select 4;
_priceUnit			= _this select 5;
_side				= _this select 6;
_artillery			= _this select 7;	///0 - none, 1 - mortar, 2 - self propelled artillery, 3 - Random, 999 - not artillery piece
_zone				= _this select 8;
_enableMarkers 			= param [9,false,[false]];

_unitPlaced = 0;

//We have an artillery piece
if (_artillery != 999) then	{
	switch (_side) do  {
		case west: {_arrayUnits = ["B_Mortar_01_F","B_MBT_01_arty_F"]};
		case east: {_arrayUnits = ["O_Mortar_01_F","O_MBT_02_arty_F"]};
		case resistance: {_arrayUnits = ["I_Mortar_01_F","I_Mortar_01_F"]};
		default {_arrayUnits = ["B_Mortar_01_F","B_MBT_01_arty_F"]};
	};

	_vehicleClass = if (_artillery != 3) then {_arrayUnits select (_artillery-1)} else {_arrayUnits call BIS_fnc_selectRandom};
	_perSpawn = 2;
} else {
	_vehicleClass = (_arrayUnits call BIS_fnc_selectRandom) select 1;
	_perSpawn = 1;
};

_availablePos = selectBestPlaces [_missionCenter, _radius, "meadow * (2*hills)", 10, 5];

if (count _arrayUnits > 0) then {

	_time = time + 3;

	while {(_unitPlaced < (_totalEnemyUnits)) && (count _availablePos > 0) && (time < _time)} do {

		_pos = [((_availablePos select 0) select 0) select 0, ((_availablePos select 0) select 0) select 1,0];
		_availablePos set [0, -1];
		_availablePos = _availablePos - [-1];
		_group = createGroup _side;

		//Spawn the static pieces
		for "_x" from 1 to _perSpawn step 1 do {
			_radius = 40;
			_spawnPos = _pos findEmptyPosition [20,_radius,_vehicleClass];

			while {count _spawnPos == 0} do {
				_radius = _radius +40;
				_spawnPos = _pos findEmptyPosition [20,_radius,_vehicleClass];
				sleep 0.1;
			};

			_vehicle = [_spawnPos, (random 360), _vehicleClass, _group] call MCC_fnc_spawnVehicle;
			{_x addCuratorEditableObjects [[_vehicle select 0],true]} forEach allCurators;
			(_vehicle select 2) setVariable ["GAIA_ZONE_INTEND",[str _zone,"NOFOLLOW"], true];
		};

		//Add a markers to artiilery
		if (getNumber (configfile >> "CfgVehicles" >> _vehicleClass >> "artilleryScanner") > 0 && _enableMarkers) then {

			private _markers = [];
			private _range = 50 + (random 200);
			_pos = (_pos getPos [_range,random 360]);
			_marker = createMarker [format ["MCC_MWArtillery_%1",(["MCC_MWArtillery",1] call BIS_fnc_counter)],_pos];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "mil_warning";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerText "Artillery";

			_markers pushBack _marker;

			_marker = createMarker [format ["MCC_MWArtillery_%1",(["MCC_MWArtillery",1] call BIS_fnc_counter)],_pos];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerType "hd_marker";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerBrush  "DiagGrid";
			_marker setMarkerSize [_range, _range];

			_markers pushBack _marker;

			[_group,_markers] spawn {
				params ["_group","_markers"];

				while {(alive leader _group) && (vehicle leader _group != leader _group)} do {sleep 60};

				{deleteMarker _x} foreach _markers;
			};
		};

		_unitPlaced = _unitPlaced + (_priceUnit*_perSpawn);
	};
} else {
	diag_log "MCC: Mission Wizard Error: No vehicles available in the selected enemy faction";
};
_unitPlaced;





