//==================================================================MCC_fnc_requestDropOff===============================================================================================
// Request player or AI to drop off a cargo group in a specific place - shold run localy on the requestor
// Example:[] call MCC_fnc_requestDropOff
//=================================================================================================================================================================================
private ["_prePos","_command","_vehicPlayer"];
 openMap true;
 cutText ["Mark your drop-off point", "PLAIN DOWN",1,true];
 MCC_mapClick 	= nil; 
 _vehicPlayer 	= vehicle player;
 _prePos 		= getpos _vehicPlayer; 

 ["MCC_requestDropOffEH", "onMapSingleClick", {
	MCC_mapClick = _pos; 
}] call BIS_fnc_addStackedEventHandler;

//send WP
waituntil {!isnil "MCC_mapClick"};
openMap false;
cutText ["", "PLAIN DOWN",1,true];

[format ["%1 Request Drop-off at X-ray: %2 Yankee: %3",name player, floor (MCC_mapClick select 0), floor (MCC_mapClick select 1)],"PLAIN DOWN"] remoteExec ["titleText", driver _vehicPlayer];
60 remoteExec ["titleFadeOut", driver _vehicPlayer];

[1,MCC_mapClick,[9,"NO CHANGE","NO CHANGE","FULL","UNCHANGED","", {},0],[group driver _vehicPlayer]] remoteExec ["MCC_fnc_manageWp", driver _vehicPlayer];

if (_vehicPlayer isKindof "air") then
{
	[0,MCC_mapClick,[17,"NO CHANGE","NO CHANGE","FULL","UNCHANGED","", {},0],[group driver _vehicPlayer]] remoteExec ["MCC_fnc_manageWp", driver _vehicPlayer];
	[0,_prePos,[0,"NO CHANGE","NO CHANGE","FULL","UNCHANGED","", {},0],[group driver _vehicPlayer]] remoteExec ["MCC_fnc_manageWp", driver _vehicPlayer];
	[0,_prePos,[17,"NO CHANGE","NO CHANGE","FULL","UNCHANGED","", {},0],[group driver _vehicPlayer]] remoteExec ["MCC_fnc_manageWp", driver _vehicPlayer];
};

//Clean up
MCC_mapClick = nil;
["MCC_requestDropOffEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;