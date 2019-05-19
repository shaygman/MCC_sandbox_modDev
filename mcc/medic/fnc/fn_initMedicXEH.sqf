/* =================================================  MCC_fnc_initMedicXEH =========================================================================

	Handles init medic XEH

*/

params ["_unit"];

if (_unit getVariable ["MCC_medicEHstarted",false]) exitWith {};

//Initate medic system and replace BI default items
_unit setVariable ["MCC_medicEHstarted",true,true];
_unit addEventHandler ["HandleDamage", {_this call MCC_fnc_handleDamage}];

if !(isPlayer _unit) then {
	_unit addEventHandler ["HandleHeal",{
		(_this select 0) setVariable ["MCC_medicBleeding",0,true];
		if (!isplayer (_this select 1) && (_this select 1 != (_this select 0))) then {(_this select 0) setVariable ["MCC_medicUnconscious",false,true]};
		false}];
};

//Add effects and AI
_unit setVariable ["MCC_fnc_initMedicXEH",([{_this spawn MCC_fnc_medicEffects}, 3, _unit] call CBA_fnc_addPerFrameHandler)];

[_unit] call MCC_fnc_initMedic;