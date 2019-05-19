/* ============================================ MCC_fnc_addComponentsACECondition ===========================================================================
check if components are available for this vehicle

Parameter(s):
	_this select 0: OBJECT vehicle

Returns:
	true if components are available

=============================================================================================================================================================
*/

params [
	["_vehicle",objNull,[objNull]]
];

count ("getText (_x >> 'source') == 'user' && getText (_x >> 'displayName') != ''" configClasses (configFile >> "CfgVehicles" >> typeof _vehicle >> "AnimationSources")) > 0;