/*=========================================================== MCC_fnc_settingsMissionWizard ========================================================================

		Sets default variables for the mission wizard feature of MCC (Eden module MCC_Module_settingsMissionWizard)
		The classes typed in "Variable Class" plus the classes of the synced vehicles replace the chosen Mission Wizard
		list (MCC_MWHVT, MCC_MWTanks...). The synced vehicles are only templates and are deleted.
		Params: 0: OBJECT - the module
		Returns: nothing
*/
#define MCC_MW_DEFAULTCLASSES ["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]

params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

private _varName = switch (_module getvariable ["VariableName",0]) do
			{
				case 0:	{"MCC_MWHVT"};
				case 1:	{"MCC_MWRadio"};
				case 2:	{"MCC_MWFuelTanks"};
				case 3:	{"MCC_MWTanks"};
				case 4:	{"MCC_MWAir"};
				case 5:	{"MCC_MWcache"};
				case 6:	{"MCC_MWradar"};
				case 7:	{"MCC_MWIntelObjects"};
				case 8:	{"MCC_MWIED"};
				case 9:	{"MCC_MWAA"};
				case 10:	{"MCC_MWArtillery"};

				default	{"MCC_MWHVT"};
			};

private _varClases = _module getvariable ["VariableClass","[]"];
if (_varClases isEqualType "") then {
	_varClases = if (_varClases == "") then {[]} else {call compile _varClases};
};
if (isNil "_varClases" || {!(_varClases isEqualType [])}) then {_varClases = []};
_varClases = _varClases select {_x isEqualType ""};

//The default text of "Variable Class" is the HVT list: ignore it for the other lists
if (_varName != "MCC_MWHVT" && {_varClases isEqualTo MCC_MW_DEFAULTCLASSES}) then {_varClases = []};

//Who synced with the module
private _synced = (synchronizedobjects _module) select {!(_x isKindOf "EmptyDetector")};
{
	_varClases pushBackUnique (typeof vehicle _x);
} forEach _synced;

//Wait for init.sqf, which sets the defaults when they are nil
waituntil {missionNamespace getVariable ["MCC_initDone",false]};

if (count _varClases > 0) then {
	missionNamespace setVariable [_varName, _varClases];
};

//The synced vehicles are templates only
if (isServer) then {
	{
		private _veh = vehicle _x;
		{deleteVehicle _x} forEach crew _veh;
		deleteVehicle _veh;
	} forEach _synced;
};
