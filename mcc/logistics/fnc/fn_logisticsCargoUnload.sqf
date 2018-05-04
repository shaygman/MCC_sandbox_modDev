/*=================================================================== MCC_fnc_logisticsCargoUnload ===================================================================
	Unload an item from the virtual cargo space of a vehicle

	<IN>
	0: CONTROL - control name (must be called from a list box)
	1: INTEGER - List box index number

	<OUT>
		NOTHING

=======================================================================================================================================================================
*/

_this params [
	["_ctrl",controlNull,[controlNull]],
	["_index",-1,[0]]
];

private ["_object","_cargoItems","_item","_dummy","_objectMass"];

_object =  player getVariable ["interactWith",objNull];
_objectMass = _object getVariable ["MCC_logisticsObjectMass",_object call MCC_fnc_logisticsCargoGetMass];

if (isNull _object || isNull _ctrl || _index <0) exitWith {};

_cargoItems = _object getVariable ["MCC_logisticsCargo",[]];
_item = _cargoItems select _index;

//Verify it is the right item
if ((_item select 0) == (_ctrl lbData _index)) then {
	_cargoItems deleteAt _index;

	_dummy = createVehicle [(_item select 0), position player, [], 1, "NONE"];
	_dummy setPos (player modelToworld [-2,0,1]);

	//If it is an ammobox
	if (count (_item select 1) > 0) then {
		clearWeaponCargoGlobal _dummy;
		clearMagazineCargoGlobal _dummy;
		clearItemCargoGlobal _dummy;

		{_dummy addWeaponCargoGlobal _x} forEach ( (_item select 1) select 0);
		{_dummy addMagazineCargoGlobal _x} forEach ( (_item select 1) select 1);
		{_dummy addItemCargoGlobal _x} forEach ( (_item select 1) select 2);
	};
};

lbClear _ctrl;
{
	_index = _ctrl lbAdd (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "displayname"));
	_ctrl lbSetPicture [_index, (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "editorPreview"))];
	_ctrl lbsetData [_index, (_x select 0)];
} forEach _cargoItems;

_object setVariable ["MCC_logisticsCargo",_cargoItems,true];
_object setVariable ["MCC_logisticsObjectMass",(_objectMass - (getMass _dummy)) max 0,true];

systemChat str (_object getVariable ["MCC_logisticsObjectMass",_object call MCC_fnc_logisticsCargoGetMass]);