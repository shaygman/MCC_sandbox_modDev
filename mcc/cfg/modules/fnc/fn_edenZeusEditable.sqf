/*=================================================== MCC_fnc_edenZeusEditable ===================================================
	Eden object attribute "MCC: Zeus Editable" (Cfg3DEN >> Object, mcc\cfg\cfg3DEN.hpp). Adds the object (and its crew) to
	every curator once MCC is up (MCC creates its own curator, MCC_curator, during init).

	Params:
		0: OBJECT - the object
	Returns: nothing (spawns)
	Example: [this] call MCC_fnc_edenZeusEditable;
*/
params [["_object", objNull, [objNull]]];

if (!isServer || {isNull _object}) exitWith {};

[_object] spawn {
	params ["_object"];

	waitUntil {sleep 0.5; time > 0};
	private _timeout = diag_tickTime + 60;
	waitUntil {sleep 1; (missionNamespace getVariable ["MCC_initDone", false]) || {diag_tickTime > _timeout}};
	if (isNull _object) exitWith {};

	private _objects = [_object] + (crew _object);
	{_x addCuratorEditableObjects [_objects, true]} forEach allCurators;
};
