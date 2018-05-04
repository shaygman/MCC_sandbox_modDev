/*================================================================= MCC_fnc_addComponentsACE =================================================================
Add components childrens to ACE
Internal use onlt
==============================================================================================================================================================
*/
private ["_actions","_cfgAnimationSources","_array","_searchArray","_sides","_airportName","_airportVars"];
_this params [
	["_vehicle", objNull, [objNull]],
	["_player", objNull, [objNull]],
	["_params",[], [[]]]
];


//Search components
_array = [];
_cfgAnimationSources = "getText (_x >> 'source') == 'user' && getText (_x >> 'displayName') != ''" configClasses (configFile >> "CfgVehicles" >> typeof vehicle _player >> "AnimationSources");

{
	_array pushBack
        [
            [
                getText (_x >> "displayName"),
                getText (_x >> "displayName"),
                "",
                compile format ["vehicle player animateSource [%1,%2]",str configName _x, 1-((vehicle player) animationPhase configName _x) ],
                {true}
            ] call ace_interact_menu_fnc_createAction,
            [],
            _player
        ];

} forEach _cfgAnimationSources;

_array