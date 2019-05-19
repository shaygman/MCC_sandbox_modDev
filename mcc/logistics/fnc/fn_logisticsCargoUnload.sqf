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

private ["_object","_cargoItems","_item","_dummy","_objectMass","_weapons","_magazines","_items","_classNames","_counter","_pos","_class"];

_object =  player getVariable ["interactWith",objNull];
_objectMass = _object getVariable ["MCC_logisticsObjectMass",_object call MCC_fnc_logisticsCargoGetMass];

if (isNull _object || isNull _ctrl || _index <0) exitWith {};

_cargoItems = _object getVariable ["MCC_logisticsCargo",[]];
_item = _cargoItems select _index;

//Verify it is the right item
if ((_item select 0) == (_ctrl lbData _index)) then {
	_cargoItems deleteAt _index;
	_class = _item select 0;

	_dummy = createVehicle [_class, position player, [], 1, "NONE"];

	_pos = position player findEmptyPosition [1, 8,_class];
	if (count _pos> 0) then {_dummy setPos _pos};


	//_dummy setPos (player modelToworld [-2,0,1]);


	//If it is an ammobox
	_weapons = (_item select 1) select 0;
	_magazines = (_item select 1) select 1;
	_items = (_item select 1) select 2;

	//Clear Cargo
	clearWeaponCargoGlobal _dummy;
	clearMagazineCargoGlobal _dummy;
	clearItemCargoGlobal _dummy;

	{
		_classNames = _x select 0;
		_counter = _x select 1;

		for "_i" from 0 to (count _classNames) step 1 do
		{
			switch (_forEachIndex) do
			{
				case 0:
				{
					_dummy addWeaponCargoGlobal [_classNames select _i,_counter select _i];
				};

				case 1:
				{
					_dummy addMagazineCargoGlobal [_classNames select _i,_counter select _i];
				};

				default
				{
					_dummy addItemCargoGlobal [_classNames select _i,_counter select _i];
				};
			};
		};
	} forEach [_weapons,_magazines,_items];

	//Set damage
	_dummy setDamage (_item select 2);

	//Set Fuel
	_dummy setFuel (_item select 3);
};

lbClear _ctrl;
{
	_index = _ctrl lbAdd (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "displayname"));
	_ctrl lbSetPicture [_index, (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "editorPreview"))];
	_ctrl lbsetData [_index, (_x select 0)];
} forEach _cargoItems;

_object setVariable ["MCC_logisticsCargo",_cargoItems,true];
_object setVariable ["MCC_logisticsObjectMass",(_objectMass + (getMass _dummy)) max 0,true];