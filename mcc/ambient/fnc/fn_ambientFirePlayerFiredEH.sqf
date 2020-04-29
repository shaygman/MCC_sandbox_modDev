/*============================================================MCC_fnc_ambientFirePlayerFiredEH======================================================================= 	Init EH on each client to have a small chance projectiles will start fire

	<IN>
		Nothing

	<OUT>
		Nothing
==============================================================================================================================================================*/
if (!hasInterface) exitWith {};

player addEventHandler ["firedMan", {
							if ((missionNamespace getVariable ["MCC_ambientFire",false]) && (missionNamespace getVariable ["MCC_ambientFireSettingIndex",true])) then {
								_this spawn {
									params [
										        "_unit",
										        "_weapon",
										        "_muzzle",
										        "_mode",
										        "_ammo",
										        "_magazine",
										        "_projectile"
										    ];
									private ["_exChance","_pos"];

									if (isNull _projectile) exitWith {};
									_exChance = ((getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive")) max 0.01)* (missionNamespace getVariable ["MCC_fnc_ambientFireInitExplosivesBurnChance",2]);

									if (random 100 < _exChance) then {
										while {!isNull _projectile} do {
											_pos = getPosATL _projectile;
											sleep 0.01;
										};

										if (!isNil "_pos") then {
											[_pos] remoteExec ["MCC_fnc_ambientFireStart",2];
										};
									};
								};
							};
						}];