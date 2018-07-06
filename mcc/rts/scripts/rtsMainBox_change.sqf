private ["_mccdialog","_comboBox","_tempBox","_array","_displayArray","_displayname","_class","_pic","_resIndex","_valor","_index","_isVirtual"];
#define	TRADERCUT	1.15

disableSerialization;
_index	= param [0,0,[0]];
_mccdialog = uiNamespace getVariable ["MCC_rtsMainBox", displayNull];

//Don't have the box exit
_tempBox = player getVariable ["MCC_interactedBox", objNull];
if (isNull _tempBox) exitWith {};
_playerValor = player getVariable ["MCC_valorPoints",50];

_fnc_addItem = {
	params ["_itemClass","_add"];
	private ["_return","_countStart","_countFinish"];

	([_itemClass] call BIS_fnc_itemType) params ["_category","_type"];

	_return = false;
	_countStart = {_x == _class} count (magazines player + items player + weapons player);
	_countStart = _countStart + ({_x == _class} count [goggles player, backpack player, vest player, headgear player]);

	if (_add) then {
		switch (_category) do
		{
			case "Weapon": {player addWeapon _itemClass};
			case "VehicleWeapon": {player addWeapon _itemClass};
			case "Item": {player addItem _itemClass};
			case "Equipment": {
				switch (_type) do
				{
					case "Glasses":	{if (goggles player =="") then {player addGoggles _itemClass}};
					case "Headgear":	{if (headgear player =="") then {player addHeadgear _itemClass}};
					case "Vest":	{if (vest player =="") then {player addVest _itemClass}};
					case "Uniform":	{if (uniform player =="") then {player forceAddUniform _itemClass}};
					case "Backpack":	{if (backpack player =="") then {player addBackpack _itemClass}};
				};
			};
			case "Magazine": {player addMagazine _itemClass};
			case "Mine": {player addMagazine _itemClass};
		};
	} else {

		//Is it wearable item
		if (_class in [goggles player, headgear player, vest player, uniform player,backpack player]) then {
			switch (_type) do
			{
				case "Glasses":	{removeGoggles player};
				case "Headgear":{removeHeadgear player};
				case "Vest":	{
					{
						[_x,true] call _fnc_addItem;
					} forEach (vestItems player + vestMagazines player);

					removeVest player;
				};
				case "Uniform":	{
					{
						[_x,true] call _fnc_addItem;
					} forEach (uniformItems player + uniformMagazines player);

					removeUniform player;
				};
				case "Backpack":{
					{
						[_x,true] call _fnc_addItem;
					} forEach (backpackItems player + backpackMagazines player);

					removeBackpack player;
				};
			};
		} else {
			if (_class in weapons player) then {player removeWeapon _itemClass} else {player removeItem _itemClass};
		};
	};

	_countFinish = {_x == _class} count (magazines player + items player + weapons player);
	_countFinish = _countFinish + ({_x == _class} count [goggles player, backpack player, vest player, headgear player]);
	_return = if (_add) then {_countFinish > _countStart} else {_countFinish < _countStart};
	_return
};

_fnc_addRemoveItemFromBox = {
	params ["_tempBox", "_class","_add","_item","_isVirtual"];
	private ["_tempArray"];

	if (_isVirtual) then {
		switch (_item) do
		{
			case "magazine":
			{
				if (_add) then {
					[_tempBox, _class] call MCC_fnc_addVirtualMagazineCargo;
				} else {
					[_tempBox, _class] call MCC_fnc_removeVirtualMagazineCargo;
				};
			};

			case "weapon":
			{
				if (_add) then {
					[_tempBox, _class] call MCC_fnc_addVirtualweaponCargo;
				} else {
					[_tempBox, _class] call MCC_fnc_removeVirtualweaponCargo;
				};
			};

			default
			{
				if (_add) then {
					[_tempBox, _class] call MCC_fnc_addVirtualItemCargo;
				} else {
					[_tempBox, _class] call MCC_fnc_removeVirtualItemCargo;
				};
			};
		};
	} else {
		switch (_item) do
		{
			case "magazine":
			{
				if (_add) then {
					_tempBox addMagazineCargoGlobal [_class, 1];
				} else {
					//Bruth force since BI never gave a command to remove one item from a create
					_tempArray = magazineCargo _tempBox;
					_tempArray deleteAt (_tempArray find _class);
					clearMagazineCargoGlobal _tempBox;
					{
						_tempBox addMagazineCargoGlobal [_x, 1];
					} forEach _tempArray;
				};
			};

			case "weapon":
			{
				if (_add) then {
					_tempBox addWeaponCargoGlobal [_class, 1];
				} else {
					//Bruth force since BI never gave a command to remove one item from a create
					_tempArray = weaponCargo _tempBox;
					_tempArray deleteAt (_tempArray find _class);
					clearWeaponCargoGlobal _tempBox;
					{
						_tempBox addWeaponCargoGlobal [_x, 1];
					} forEach _tempArray;
				};
			};

			default
			{
				if (_add) then {
					_tempBox addItemCargoGlobal [_class, 1];
				} else {
					//Bruth force since BI never gave a command to remove one item from a create
					_tempArray = itemCargo _tempBox;
					_tempArray deleteAt (_tempArray find _class);
					clearItemCargoGlobal _tempBox;
					{
						_tempBox addItemCargoGlobal [_x, 1];
					} forEach _tempArray;
				};
			};
		};
	};
};

_fnc_errorMessage = {
	params ["_text"];
	private _str = "<t size='1' t font = 'puristaLight' color='#FFFFFF'>" + _text + "</t>";
	[_str,0,1,1,0.1,0.1] spawn bis_fnc_dynamictext;
	player globalRadio "SentCommandFailed";
};

//Are we dealing with real or virtual box
_isVirtual = (_tempBox getVariable ["MCC_virtualBox",false]);

switch (_index) do {
    case (21): //sell
    {
    	_class = lbData [1, (lbCurSel 1)];
    	if (_class == "") exitWith {};

    	_valor = [_class] call MCC_fnc_getWeaponCost;

    	private _isItem = (_class in (items player));

    	//sell
    	if ([_class, false] call _fnc_addItem) then {
    		switch (true) do {

				case (isClass (configFile >> "CfgMagazines" >> _class)) : {
					[_tempBox, _class, true, "magazine", _isVirtual] call _fnc_addRemoveItemFromBox;
				};

				case (isClass (configFile >> "CfgWeapons" >> _class)) : {
					if (_isItem) then {
						[_tempBox, _class, true, "item", _isVirtual] call _fnc_addRemoveItemFromBox;
					} else {
						[_tempBox, _class, true, "weapon", _isVirtual] call _fnc_addRemoveItemFromBox;
					};

					//add funds
					if ((getText(configFile >> "CfgWeapons" >> _class >> "mcc_surviveType")) != "") then {
				    	_resIndex = switch (getText(configFile >> "CfgWeapons" >> _class >> "mcc_surviveType")) do
				    			{
						    	    case "repair":  {1};
						    	    case "fuel":  {2};
						    	    case "food":  {3};
						    	    case "med":  {4};
						    	    default {0};
						    	};
						_resources = missionNamespace getVariable [format ["MCC_res%1", playerSide],[500,500,200,200,100]];
						_resources set [_resIndex, ((_resources select _resIndex)+_valor)];
						publicVariable (format ["MCC_res%1", playerSide,_resources]);
					};
				};

				default
				{
					[_tempBox, _class, true, "weapon", _isVirtual] call _fnc_addRemoveItemFromBox;
				};
			};

			player setVariable ["MCC_valorPoints",_playerValor + _valor];
		} else {
			["Can't remove item from player inventory"] spawn _fnc_errorMessage;
		};
    };

    case (20): //Buy
    {
    	_class = lbData [0, (lbCurSel 0)];
    	if (_class == "") exitWith {};
    	_valor = 0;

    	//Weapon or magazine
    	_valor = [_class] call MCC_fnc_getWeaponCost;
    	_valor = round (_valor * TRADERCUT);

    	if (_playerValor >= _valor) then {

    		if ([_class,true] call _fnc_addItem) then {
	    		switch (true) do {

					case (isClass (configFile >> "CfgMagazines" >> _class)) : {
						[_tempBox, _class, false, "magazine", _isVirtual] call _fnc_addRemoveItemFromBox;
					};

					case (isClass (configFile >> "CfgWeapons" >> _class)) : {
						if (_class in (items player)) then {
							[_tempBox, _class, false, "item", _isVirtual] call _fnc_addRemoveItemFromBox;
							[_tempBox, _class, false, "weapon", _isVirtual] call _fnc_addRemoveItemFromBox;
						} else {
							[_tempBox, _class, false, "weapon", _isVirtual] call _fnc_addRemoveItemFromBox;
						};
					};

					default
					{
						[_tempBox, _class, false, "weapon", _isVirtual] call _fnc_addRemoveItemFromBox;
					};
				};

				player setVariable ["MCC_valorPoints",_playerValor - _valor];
			} else {
				["Not Enough Space"] spawn _fnc_errorMessage;
			};
		} else {
			["No Enough Money"] spawn _fnc_errorMessage;
		};
    };
};

//Update arrays
if (_index in [20,21]) then {
	[_tempBox, (_tempBox getVariable ["MCC_prices",0.5])] call MCC_fnc_mainBoxInitRefreshBox;
};

if (_index <20) then {
	missionNamespace setVariable ["MCC_rtsMainBoxIndex",_index];
} else {
	_index = missionNamespace getVariable ["MCC_rtsMainBoxIndex",0];
};

private ["_isShop"];
{
	_displayArray = [];

	_isShop = !(isplayer _x);

	//If show only magazines for the selected weapon
	if (_index == 5) then {
		_array = [_index, _x,(lbData [1, (lbCurSel 1)])] call MCC_fnc_boxMakeWeaponsArray;
		_index = 0;
	} else {
		//save time and get the preloaded array
		if (_isShop) then {
			_array = missionNamespace getVariable [format ["MCC_fnc_mainBoxInit_tempBox_%1",_index],[]];
		} else {
			_array = [_index, player] call MCC_fnc_boxMakeWeaponsArray;
			_array sort true;
		};
	};


	_array sort true;
	_comboBox = _mccdialog displayCtrl (if (_isShop) then {0} else {1});
	lbClear _comboBox;

	{
		_displayname 	= _x select 0;
		_class 			= _x select 1;
		_pic 			= _x select 2;
		_valor = [_class] call MCC_fnc_getWeaponCost;
		if (_isShop) then {_valor = round (_valor * TRADERCUT)};

		if !(_displayname in _displayArray) then
		{
			_i = _comboBox lbAdd _displayname;
			_comboBox lbSetPicture [_i, _pic];
			_comboBox lbSetTextRight [_i,format ["%1 $", _valor]];
			_comboBox lbSetData [_i, _class];
			_comboBox lbSetTooltip [_i,str ({_displayname== (_x select 0)} count _array)];
			_displayArray pushback _displayname;
		};

	} foreach _array;
} foreach [_tempBox,player];

//Get valor points
ctrlSetText [4, [(player getVariable ["MCC_valorPoints",50])] call MCC_fnc_formatNumber];