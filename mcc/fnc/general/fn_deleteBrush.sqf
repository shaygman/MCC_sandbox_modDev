/*====================================================MCC_fnc_deleteBrush=================================================================================================

Delete objects/Markers in area radius.

	 Example:[_pos, _radius, _type] call MCC_fnc_deleteBrush;
	 	_pos 					POS ARRAY,  center
		_radius					INTEGER, radius to delete
		_type					INTEGER, ["All","All Units", "Man", "Car", "Tank", "Air", "ReammoBox","Markers","Bodies","Lights","doorsAll","doorsRandom","doorsAllunlock","Buildings","sandstorm","storm","heatwave","clear","N/V","Flashlights"]
		true					BOOLEAN if true will ignore player's unit

	 Return - nothing
//================================================================================================================================================================*/

private ["_pos","_radius","_type","_nearObjects","_crew","_markers","_ignorePlayers"];

_pos = param [0,[0,0,0],[[]]];
_radius = param [1,100,[0]];
_type = param [2,0,[0,""]];

if (typeName _type == typeName "") then {
	_type =  ["All",
			  "All Units",
			  "Man",
			  "Car",
			  "Tank",
			  "Air",
			  "ReammoBox",
			  "Markers",
			  "LightsOff",
			  "LightsOn",
			  "doorsAll",
			  "doorsAllunlock",
			  "doorsRandom",
			  "Buildings",
			  "sandstorm",
			  "storm",
			  "snow",
			  "heatwave",
			  "clear",
			  "N/V",
			  "Flashlights",
			  "Bodies",
			  "campaign"] find _type;
};

_ignorePlayers = param [3, false, [false]];

_nearObjects = [];

switch _type do {

	//"All"
	case 0:
		{
			_nearObjects =  [_pos select 0, _pos select 1, 0] nearObjects _radius;
		};

	//"All Units"
	case 1:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["Man", _radius];
			_nearObjects =_nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["Car", _radius]);
			_nearObjects =_nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["Tank", _radius]);
			_nearObjects =_nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["Air", _radius]);
			_nearObjects =_nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["ReammoBox", _radius]);
			_nearObjects =_nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["ReammoBox_F", _radius]);
		};

	//"Man"
	case 2:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["Man", _radius];
		};

	//"Car"
	case 3:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["Car", _radius];
		};

	//"Tank"
	case 4:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["Tank", _radius];
		};

	//"Air"
	case 5:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["Air", _radius];
		};

	//"ReammoBox"
	case 6:
		{
			_nearObjects = [_pos select 0, _pos select 1, 0] nearObjects ["ReammoBox", _radius];
			_nearObjects = _nearObjects + ([_pos select 0, _pos select 1, 0] nearObjects ["ReammoBox_F", _radius]);
		};

	//"Markers"
	case 7:
		{
			//Markers
			_markers = [];
			{
				if (((getMarkerPos _x distance [_pos select 0, _pos select 1, 0]) < _radius) && !(getMarkerPos _x in mcc_zone_pos))
				then
				{
					_markers set [count _markers, _x];
				};
			} foreach allMapMarkers;

			{
				[2, "", "", "", "", "", _x, []] call MCC_fnc_makeMarker;
			} foreach _markers;
		};

	//"LightsOff"
	case 8:
		{
			private "_lamps";
			//Lights
			{
				_lamps = [_pos select 0, _pos select 1, 0] nearObjects [_x, _radius];
				{[_x, false] call BIS_fnc_switchLamp} foreach _lamps;
			} foreach ["Lamps_Base_F", "PowerLines_base_F"];
		};

	//"LightsOn"
	case 9:
		{
			private "_lamps";
			//Lights
			{
				_lamps = [_pos select 0, _pos select 1, 0] nearObjects [_x, _radius];
				{[_x, true] call BIS_fnc_switchLamp} foreach _lamps;
			} foreach ["Lamps_Base_F", "PowerLines_base_F"];
		};

	//"doorsAll"
	case 10:
		{
			private "_buildings";
			//Buildings
			_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius];

			{
				for [{_i=1},{_i<=15},{_i=_i+1}] do
				{
					_x setVariable [format ["bis_disabled_door_%1",_i],1,true];
				};
			} foreach _buildings;
		};

	//"doorsAllunlock"
	case 11:
		{
			private "_buildings";

			//Buildings
			_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius];

			{
				for [{_i=1},{_i<=15},{_i=_i+1}] do
				{
					_x setVariable [format ["bis_disabled_door_%1",_i],0,true];
				};
			} foreach _buildings;
		};

	//"doorsRandom"
	case 12:
		{
			private "_buildings";
			//Buildings
			_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius];
			{
				for [{_i=1},{_i<=15},{_i=_i+1}] do
				{
					if (random 1 > 0.5) then {_x setVariable [format ["bis_disabled_door_%1",_i],1,true]};
				};
			} foreach _buildings;
		};

	//"Buildings"
	case 13:
		{
			private "_buildings";

			//Buildings
			_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius];
			sleep 1;
			{if ((random 1) > 0.4) then {_x setDamage 1}} forEach _buildings;

			//Objects
			_buildings = (nearestObjects [[_pos select 0, _pos select 1, 0],[], _radius]) - ([_pos select 0, _pos select 1, 0] nearObjects _radius);
			sleep 1;
			{if ((random 1) > 0.4) then {_x setDamage 1}} forEach _buildings;

			//create burning wrecks
			for [{_x=0},{_x<1+(floor _radius/20)},{_x=_x+1}] do
			{
				_wreck = (MCC_ied_wrecks select (random (count MCC_ied_wrecks-1))) select 1;
				_tempPos = [(_pos select 0) + ((random _radius)-(random _radius)) ,(_pos select 1) + ((random _radius)-(random _radius)),0];
				_dummy= _wreck createvehicle _tempPos;
				_dummy setdir (floor random 360);
				if ((random 1) > 0.5) then
				{
					_effect = (["test_EmptyObjectForFireBig","test_EmptyObjectForSmoke"]  call BIS_fnc_selectRandom)  createVehicle (getpos _dummy);
					_effect setpos (getpos _dummy);
				};
			};

			[["bf",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"sandstorm"
	case 14:
		{
			[["sandstorm",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"storm"
	case 15:
		{
			[["storm",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"snow"
	case 16:
		{
			[["snow",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"heatwave"
	case 17:
		{
			[["heatwave",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"clear"
	case 18:
		{
			[["clear",false],"MCC_fnc_ppEffects",true,false] call BIS_fnc_MP;
		};

	//"N/V"
	case 19:
		{
			{
				private _unit = _x;

				if ((position _unit) inArea [_pos, _radius, _radius,0,false]) then {
					if !(_ignorePlayers && isPlayer _unit) then {
						{
							_unit unassignItem _x;
							_unit removeItem _x;
						} foreach ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP","CUP_NVG_HMNVS","CUP_NVG_PVS7"];
					};
				};
			} foreach allUnits;

			_nearObjects = [];
		};

	//"Flashlights"
	case 20:
		{
			{
				private _unit = _x;

				if ((position _unit) inArea [_pos, _radius, _radius,0,false]) then {
					if !(_ignorePlayers && isPlayer _unit) then {

						if ("acc_flashlight" in primaryWeaponItems _unit) then {
							_unit enablegunlights "forceOn";
						} else {
							_unit addPrimaryWeaponItem "acc_flashlight";
							sleep 0.3;
							_unit enablegunlights "forceOn";
						};
					};
				};
			} foreach allUnits;

			_nearObjects = [];
		};

	//"Bodies"
	case 21:
		{
			//Bodies
			{
				if ((_x distance [_pos select 0, _pos select 1, 0]) < _radius) then {_nearObjects set [count _nearObjects, _x]};
			} foreach allDeadMen;
		};

	//"campaign"
	case 22:
		{
			_nearObjects =  [];

			{
				if (_x getVariable ["mcc_delete",true] &&
				    !(isPlayer _x || ({isPlayer _x} count (crew vehicle _x) > 0) || _x getVariable ["MCC_isRTSunit",false] || group _x getVariable ["MCC_canbecontrolled",false])) then {
					if (count crew _x >0) then {
							_crew = crew _x;

							{deletevehicle _x; sleep 0.1} foreach _crew;
					};

					deletevehicle _x;
				};
			} forEach ([_pos select 0, _pos select 1, 0] nearObjects _radius);
		};
};

{
	if (_x getVariable ["mcc_delete",true] &&
	    !(isPlayer _x || isPlayer driver vehicle _x || isPlayer commander vehicle _x || isPlayer gunner vehicle _x )) then {
		if (count crew _x >0) then {
				_crew = crew _x;

				{deletevehicle _x; sleep 0.1} foreach _crew;
		};

		deletevehicle _x;
	};
} foreach _nearObjects;





