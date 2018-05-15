/*========================================================================== MCC_fnc_logisticsCargoInit ===========================================================

	Init the virtual logistics cargo dialog - internal use only

	<IN>
		NOTHING

	<OUT>
		NOTHING
====================================================================================================================================================================
*/

private ["_cargoItems","_sparePart","_display","_ctrl","_index","_object"];

_object =  player getVariable ["interactWith",objNull];
_cargoItems = _object getVariable ["MCC_logisticsCargo",[]];

//First time make sure we have at least one spare tire or track
if (count _cargoItems <=0 && !(_object getVariable ["MCC_logisticsCargoInit",false])) then {
	_sparePart =  if (_object isKindOf "car") then {"Tire_Van_02_Cargo_F"} else {"Land_TankTracks_01_long_F"};
	_cargoItems pushBack [_sparePart,[[[],[]],[[],[]],[[],[]]],0,1];
	_object setVariable ["MCC_logisticsCargo",_cargoItems,true];
	_object setVariable ["MCC_logisticsCargoInit",true,true];
};

while {dialog} do {closeDialog 0};
0 = createDialog "MCC_logisticsCargo";
waitUntil {dialog};

disableSerialization;

_display =  uiNamespace getVariable ["MCC_logisticsCargo", displayNull];
_ctrl = _display displayctrl 1500;
_ctrl ctrlAddEventHandler ["LBDblClick",{_this spawn MCC_fnc_logisticsCargoUnload}];
lbClear _ctrl;
{
	_index = _ctrl lbAdd (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "displayname"));
	_ctrl lbSetPicture [_index, (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "editorPreview"))];
	_ctrl lbsetData [_index, (_x select 0)];
} forEach _cargoItems;