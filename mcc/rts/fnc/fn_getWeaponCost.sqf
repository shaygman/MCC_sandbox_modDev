/*================================================= MCC_fnc_getWeaponCost ========================================================
Gets a weapon cost by it's effective DPS, range and ammo
<IN>
	0: STRING: weapon's className

<OUT>
	INTEGER: weapon cost

==================================================================================================================================*/
private ["_class","_baseCost","_prices"];
#define	MCC_PRICE_FACTOR	0.5

_class = param [0,"",[""]];
_prices = param [1,0.5,[0]];

//If we have predefine cost to it
if (isClass (missionConfigFile >> "MCC_itemsCosts" >> _class)) exitWith {
	getNumber (missionConfigFile >> "MCC_itemsCosts" >> _class >> "cost");
};

if (isClass (ConfigFile >> "MCC_itemsCosts" >> _class)) exitWith {
	getNumber (ConfigFile >> "MCC_itemsCosts" >> _class >> "cost");
};


([_class] call BIS_fnc_itemType) params ["_category","_type","_cfgValue"];
_baseCost = (switch (_type) do
			{
				case "AssaultRifle": {500};
				case "BombLauncher": {700};
				case "Cannon": {700};
				case "GrenadeLauncher": {600};
				case "Handgun": {200};
				case "Launcher": {700};
				case "MachineGun": {800};
				case "Magazine": {30};
				case "MissileLauncher": {1000};
				case "Mortar": {800};
				case "RocketLauncher": {1000};
				case "Shotgun": {350};
				case "Throw": {30};
				case "MachineGun": {800};
				case "Rifle": {400};
				case "SubmachineGun": {400};
				case "SniperRifle": {600};
				case "LaserDesignator": {400};
				case "AccessoryMuzzle": {150};
				case "AccessoryPointer": {100};
				case "AccessorySights": {50};
				case "AccessoryBipod": {150};
				case "Binocular": {80};
				case "Compass": {20};
				case "FirstAidKit": {5};
				case "GPS": {60};
				case "Map": {10};
				case "Medikit": {100};
				case "MineDetector": {120};
				case "NVGoggles": {340};
				case "Radio": {80};
				case "Toolkit": {180};
				case "UAVTerminal": {260};
				case "UnknownEquipment": {20};
				case "UnknownWeapon": {300};
				case "Glasses": {40};
				case "Headgear": {40};
				case "Vest": {220};
				case "Uniform": {100};
				case "Backpack": {150};
				case "Artillery": {40};
				case "Bullet": {10};
				case "Magazine": {10};
				case "Flare": {15};
				case "Grenade": {30};
				case "Laser": {30};
				case "Missile": {80};
				case "Rocket": {50};
				case "Shell": {20};
				case "ShotgunShell": {10};
				case "SmokeShell": {15};
				case "UnknownMagazine": {30};
				case "Mine": {90};
				case "MineBounding": {80};
				case "MineDirectional": {60};
				default {20};
			});

_baseCost = _baseCost * MCC_PRICE_FACTOR;

if (_category in ["Weapon","VehicleWeapon"]) then {

	//dexterity
	_cfgValue = 1.7 - (getNumber (configfile >> "CfgWeapons" >> _class >> "dexterity"));
	_baseCost = _baseCost * (1+_cfgValue);

	//dexterity
	_cfgValue = ((getNumber (configfile >> "CfgWeapons" >> _class >> "dispersion")) - 0.00029)*100;
	_baseCost = _baseCost * (1+_cfgValue);

	//dexterity
	_cfgValue = ((getNumber (configfile >> "CfgWeapons" >> _class >> "inertia")) - 0.4);
	_baseCost = _baseCost * (1+_cfgValue);

	//muzzles
	_cfgValue = ( count (getArray (configfile >> "CfgWeapons" >> _class >> "muzzles")) - 1)*0.1;
	_baseCost = _baseCost * (1+_cfgValue);

	//maxZeroing
	_cfgValue = (((getNumber (configfile >> "CfgWeapons" >> _class >> "maxZeroing")) - 600)/1000)*0.2;
	_baseCost = _baseCost * (1+_cfgValue);

};

if (_category in ["Item"]) then {

	switch (_type) do
	{
		case ("AccessorySights"):
		{
			//vision Mods
			_cfgValue = count (configfile >> "CfgWeapons" >> _class >> "ItemInfo" >> "OpticsModes");
			_baseCost = _baseCost * (1 + _cfgValue * 0.2);

			//Max Range
			_cfgValue = 0;
			{
				if (getNumber (_x >> "distanceZoomMax") > _cfgValue) then {_cfgValue = getNumber (_x >> "distanceZoomMax")};
			} forEach ("true" configClasses (configFile >> "cfgWeapons" >> _class >> "ItemInfo" >> "OpticsModes"));
			_baseCost = _baseCost * (1 + (_cfgValue*0.005));

			//NVG
			if (count ("'NVG' in (getArray (_x >> 'visionMode'))" configClasses (configFile >> "cfgWeapons" >> _class >> "ItemInfo" >> "OpticsModes"))>0) then {
				_baseCost = _baseCost *1.3;
			};

			//TI
			if (count ("'Ti' in (getArray (_x >> 'visionMode'))" configClasses (configFile >> "cfgWeapons" >> _class >> "ItemInfo" >> "OpticsModes"))>0) then {
				_baseCost = _baseCost *1.6;
			};
		};

		case ("NVGoggles"):
		{
			//TI
			if ("TI" in (getArray (configfile >> "CfgWeapons" >> _class >> "visionMode"))) then {
				_baseCost = _baseCost *1.6;
			};
		};
	};
};

if (_category in ["Equipment"]) then {
	switch (_type) do
	{
		case "Headgear":
		{
			_cfgValue = 0;
			{
				_cfgValue = _cfgValue + ((getNumber (configfile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "armor"))* (getNumber (configfile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "passThrough")));
			} forEach ["Head","Abdomen","Body","Chest","Diaphragm","Neck","Face","Pelvis","Arms","Hands","Legs"];

			_baseCost = _baseCost + (_cfgValue*3);
		};

		case "Vest":
		{
			_cfgValue = 0;
			{
				_cfgValue = _cfgValue + ((getNumber (configfile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "armor"))* (getNumber (configfile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "passThrough")));
			} forEach ["Head","Abdomen","Body","Chest","Diaphragm","Neck","Face","Pelvis","Arms","Hands","Legs"];

			_baseCost = _baseCost +(_cfgValue*5);
		};

		case "Backpack":
		{
			_cfgValue = (getNumber (configfile >> "CfgVehicles" >> _class >> "maximumLoad"));
			_baseCost = _baseCost +(_cfgValue*0.7);
		};
	};
};


//Survival item
if (getText(configFile >> "cfgWeapons" >> _class >> "mcc_surviveType") != "")  then {
    _baseCost = getNumber (configFile >> "cfgWeapons" >> _class >> "value");
};


round (_baseCost*_prices)