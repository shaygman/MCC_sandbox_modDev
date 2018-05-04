/*=================================================================================== MCC_fnc_vehicleRandomAnimation========================================================================
spawn random animations for vehicles

Parameter(s):
	_this select 0: OBJECT vehicle

Returns:
	NOTHING

===============================================================================================================================================================================================
*/

private ["_veh","_cfgAnimationSources"];

_veh = param [0,objNull,[objNull]];

if (isNull _veh) exitWith {diag_log "MCC_fnc_vehicleRandomAnimation: Error try to change animation of null vehicle"};

_cfgAnimationSources = "getText (_x >> 'source') == 'user' && getText (_x >> 'displayName') != ''" configClasses (configFile >> "CfgVehicles" >> typeof _veh >> "AnimationSources") ;

{
	if (random 1 > 0.6) then {_veh animateSource [configName _x,1]};
} forEach _cfgAnimationSources;