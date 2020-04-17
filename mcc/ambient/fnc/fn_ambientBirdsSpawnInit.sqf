/*============================================================MCC_fnc_ambientBirdsSpawnInit==============================================================================
// Init birds spawn on server
// <IN> Nothing
// <OUT> Nothing
//==================================================================================================================================================================*/
_module = param [0,objNull,[objNull]];
if (isNull _module) exitWith {};

//If we came here from Zeus run on the server
if ((local _module) && !(isnull curatorcamera)) then {
	[objNull, localize "STR_DISP_CURATOR_AMBIENTBIRDSSPAWN_SUCCESS"] call bis_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
	[] remoteExec ["MCC_fnc_ambientBirdsSpawnInit", 2];
};

if  (!isServer || (missionNamespace getVariable ["MCC_fnc_ambientBirdsSpawnInitRuning",false])) exitWith {};
missionNamespace setVariable ["MCC_fnc_ambientBirdsSpawnInitRuning",true];

private ["_unit"];
while {(missionNamespace getVariable ["MCC_fnc_ambientBirdsSpawnInitRuning",false])} do {
	{
		IF (count units _x > 0) then {
			_unit = (units _x) call BIS_fnc_selectRandom;

			if (typeName _unit isEqualTo typeName objNull) then {
				if ((_unit getVariable ["MCC_fnc_ambientBirdsNextTime",0]) <= time &&
				    !(vehicle _unit isKindOf "air")) then {

					if ((random (speed _unit) min 9) > 2) then {
						_unit setVariable ["MCC_fnc_ambientBirdsNextTime",time+(random 30)];
						[vehicle _unit] spawn MCC_fnc_ambientBirdsSpawn;
					};
				};
			};
		};
	} forEach allGroups;

	sleep (random 60);
};
