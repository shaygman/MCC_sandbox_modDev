//===========================================================MCC_fnc_pickItem=============================================================================================
//  _objet = object (the picable object)
//======================================================================================================================================================================
private["_object", "_caller", "_index","_displayName","_text","_shared","_delete","_markers","_tittle"];
_object = param [0,objNull,[objNull]];
_caller =  param [1,objNull,[objNull]];
_index 	=  param [2,0,[0]];

if (isNull _object) exitWith {};

//Intel Text
_tittle = (_object getVariable ["MCC_intelObjectText",["",""]]) select 0;
_text = (_object getVariable ["MCC_intelObjectText",["",""]]) select 1;

//Intel Shared with
_shared = switch (_object getVariable ["MCC_intelObjectShared",0]) do
			{
				//Group
				case 0:	{0};
				case 1:	{group _caller};
				default	{side _caller};
			};

//Delete after
_delete = _object getVariable ["MCC_intelObjectDelete",true];

//Marker
_markers = _object getVariable ["MCC_intelObjectMarkerName",[]];

_displayName = getText(configFile >> "CfgVehicles" >> typeof _object >> "displayname");
_object removeaction _index;

//If it is a man then make subtitle
if (_object isKindOf "man") then {
	_delete = false;

	if !(_text isEqualTo "") then {
		[name _object,_text] remoteExec ["BIS_fnc_showSubtitle", _caller];
	};
} else {
	_caller playMoveNow "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
};

["intelAdded",[format ["%1 has acquired %2",name _caller,_displayName],"\A3\ui_f\data\map\markers\military\warning_ca.paa"]] remoteExec ["bis_fnc_showNotification", _shared];

//Add intel
if !(_text isEqualTo "") then {
	[_tittle,_text,_markers] remoteExec ["MCC_fnc_rxAddIntel", _shared];
};

//Hint we are done
missionNamespace setVariable ["MCC_pickItem",playerSide];
publicvariable "MCC_pickItem";

sleep 1;

//Download Data
if (_object getVariable ["MCC_intelItem",false]) exitWith {
	_object setVariable ["MCC_intelItemDone",true,true]
};

//Delete after
if (_delete) then {
	deleteVehicle _object;
};