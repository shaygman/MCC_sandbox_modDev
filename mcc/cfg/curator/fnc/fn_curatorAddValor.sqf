//==================================================================MCC_fnc_curatorAddValor============================================================================
// Add valor to the selected units
//==============================================================================================================================================================
private ["_module","_valor","_object","_side","_resualt"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["valor",true]) isEqualTo typeName 100) then {
	if (!isServer) exitWith {};

	_valor = _module getVariable ["valor",100];

	//Find all units
	{
		if (_x isKindOf "CAMANBASE") then {
			_x setVariable ["MCC_valorPoints",_valor,true];
		};
	} forEach (synchronizedObjects _module);

} else {

	//Not curator exit
	if (!(local _module) || isnull curatorcamera) exitWith {};

	_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

	//if no object selected run it on all players
	if (count _object <2) then {
		_resualt = ["Add Credit",[
				["Credits",5000],
				["Player Side",["East","West","Resistance","Civilians"]]
			  ]] call MCC_fnc_initDynamicDialog;

		if (count _resualt == 0) exitWith {deleteVehicle _module};

		_valor = (_resualt select 0);
		_side = (_resualt select 1) call BIS_fnc_sideType;

		{
			if (side _x isEqualTo _side) then {
				_x setVariable ["MCC_valorPoints",(_x getVariable ["MCC_valorPoints",50]) + _valor,true];
			};
		} forEach (allPlayers);

	} else {

		//if unit selected
		_object = _object select 1;

		_resualt = ["Add Credit",[
				["Credits",5000]
			  ]] call MCC_fnc_initDynamicDialog;

		if (count _resualt == 0) exitWith {deleteVehicle _module};

		_valor = (_resualt select 0);

		//If is player
		if (isPlayer _object) then {
			_object setVariable ["MCC_valorPoints",(_object getVariable ["MCC_valorPoints",50]) + _valor,true];
		} else {
			[objNull, localize "STR_GENERAL_ERROR_NOUNITSELECTED"] call bis_fnc_showCuratorFeedbackMessage;
		};
	};
};

deleteVehicle _module;
