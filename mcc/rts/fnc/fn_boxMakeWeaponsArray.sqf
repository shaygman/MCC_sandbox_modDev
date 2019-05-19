/*=================================================================MCC_fnc_boxMakeWeaponsArray========================================================================
 <IN>
    0:      INTEGER -Index for returend values
    1:      OBJECT - player or a cargo object
    2:      STRING - (optional)weapon class if want to filter magazines by it

======================================================================================================================================================================*/

disableSerialization;
private ["_weaponType","_type","_object","_returnArray","_Cfg","_isPlayer","_class","_itemsBox","_fnc_checkACCComp","_fnc_getItems"];
_weaponType = param [0,0,[0]];
_object = param [1,objNull,[objNull]];
_class = param [2,"",[""]];
_prices = param [3,0.5,[0]];

_returnArray = [];



_fnc_checkACCComp = {
    //Find accesories for the selected weapon
    params ["_item","_weapon"];
    private _config = configFile >> "CfgWeapons" >> _weapon >> "WeaponSlotsInfo";
    _item in ((getArray(_config >> "PointerSlot" >> "compatibleItems")) + (getArray(_config >> "CowsSlot" >> "compatibleItems")) + (getArray(_config >> "MuzzleSlot" >> "compatibleItems")) + (getArray(_config >> "UnderBarrelSlot" >> "compatibleItems")));
};

_fnc_getItems = {
    //Get items by filter from an object
    params ["_object","_CfgClass","_filter","_itemsBox"];
    private ["_returnArray","_Cfg"];
    _returnArray = [];

    _Cfg = configFile >> _CfgClass;

    {
        if (isClass(_Cfg >> _x)) then {
            if ((([_x] call BIS_fnc_itemType) select 1) in _filter || "all" in _filter) then {
                _returnArray pushback [getText(_Cfg >> _x >> "displayname"), _x, getText(_Cfg >> _x >> "picture"),[_x,_prices] call MCC_fnc_getWeaponCost];
            };
        };
    } forEach _itemsBox;

    _returnArray

};

//Get all the items, mags and weapons from the object
_itemsBox = switch (true) do
            {
                case (_object isKindOf "man"):
                {
                     magazines _object + items _object + weapons _object;
                };

                case (_object getVariable ["MCC_virtualBox",false]):
                {
                     ([_object] call MCC_fnc_getVirtualWeaponCargo) + ([_object] call MCC_fnc_getVirtualItemCargo) + ([_object] call MCC_fnc_getVirtualMagazineCargo)
                };

                default
                {
                    magazineCargo _object + itemCargo _object + weaponCargo _object;
                };
            };

//Add wearable gear
if (_object isKindOf "man") then {
    {
        if (_x != "") then {_itemsBox pushback _x}
    } forEach [backpack _object, goggles _object, headgear _object, vest _object, uniform _object];
};



switch (_weaponType) do {
     case 0:          //all
    {
        _returnArray = [_object,"CfgWeapons",["all"],_itemsBox, _prices] call _fnc_getItems;
        _returnArray = _returnArray + ([_object,"cfgMagazines",["all"],_itemsBox, _prices] call _fnc_getItems);
        _returnArray = _returnArray + ([_object,"cfgVehicles",["all"],_itemsBox, _prices] call _fnc_getItems);
        _returnArray = _returnArray + ([_object,"CfgGlasses",["all"],_itemsBox, _prices] call _fnc_getItems);
    };

    case 1:         //Rifles
    {
        _returnArray = [_object,"CfgWeapons",["AssaultRifle","MachineGun","Shotgun","Rifle","SubmachineGun","SniperRifle"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 2:         //Launchers
    {
        _returnArray = [_object,"CfgWeapons",["Launcher","GrenadeLauncher","MissileLauncher","RocketLauncher","Mortar"],_itemsBox, _prices] call _fnc_getItems;
    };

     case 3:            //Pistols
    {
        _returnArray = [_object,"CfgWeapons",["Handgun"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 4:         //Magazines
    {
        _returnArray = [_object,"CfgMagazines",["Artillery","Bullet","CounterMeasures","Laser","Missile","Rocket","Shell","ShotgunShell","UnknownMagazine"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 5:         //Magazines by weapon
    {
        _Cfg = configFile >> "cfgMagazines";

        //Get all muzzeles magazines
        private _magazines = getArray(configFile >> "CfgWeapons" >> _class >> "magazines");
        {
            if (count (getArray (configFile >> "CfgWeapons" >> _class >> _x >> "magazines")) > 0) then {
                _magazines = _magazines +  getArray(configFile >> "CfgWeapons" >> _class >> _x >> "magazines");
            };
        } forEach (getArray(configFile >> "CfgWeapons" >> _class >> "muzzles"));

        {
           if (_x in _magazines)  then {
                 _returnArray pushback [getText(_Cfg >> _x >> "displayname"), _x, getText(_Cfg >> _x >> "picture")];
            };
        } forEach _itemsBox;


         _Cfg = configFile >> "cfgWeapons";
        {
             if ([_x,_class] call _fnc_checkACCComp) then {
                 _returnArray pushback [getText(_Cfg >> _x >> "displayname"), _x, getText(_Cfg >> _x >> "picture")];
            };
        } forEach _itemsBox;
    };

    case 6:            //Grenade + Explosives
    {
        _returnArray = [_object,"cfgMagazines",["Flare","Grenade","SmokeShell","Mine","MineBounding","MineDirectional"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 7:            //Accessories
    {
        _returnArray = [_object,"CfgWeapons",["AccessoryMuzzle","AccessoryPointer","AccessorySights","AccessoryBipod"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 8:           //Uniforms
    {
        _returnArray = [_object,"CfgWeapons",["Uniform"],_itemsBox, _prices] call _fnc_getItems;
         _returnArray = _returnArray + ([_object,"CfgGlasses",["Glasses"],_itemsBox, _prices] call _fnc_getItems);
    };

    case 9:         //Vest
    {
        _returnArray = [_object,"CfgWeapons",["Vest"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 10:         //BackPack
    {
        _returnArray = [_object,"cfgVehicles",["Backpack"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 11:         //Headgear
    {
        _returnArray = [_object,"CfgWeapons",["Headgear"],_itemsBox, _prices] call _fnc_getItems;
    };

    case 12:         //Items
    {
        _returnArray = [_object,"CfgWeapons",["Binocular","LaserDesignator","UAVTerminal","Compass","FirstAidKit","GPS","Map","Medikit","MineDetector","Radio","Toolkit","UnknownEquipment","NVGoggles"],_itemsBox, _prices] call _fnc_getItems;

        _Cfg = configFile >> "cfgWeapons";
        {
            _type = getNumber(_Cfg >> _x >> "type");
            if (getText(_Cfg>> _x >> "mcc_surviveType") != "")  then {
                 _returnArray pushback [getText(_Cfg >> _x >> "displayname"), _x, getText(_Cfg >> _x >> "picture")];
            };
        } forEach _itemsBox;
    };
};

_returnArray;
