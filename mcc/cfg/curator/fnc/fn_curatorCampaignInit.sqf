//============================================================MCC_fnc_curatorCampaignInit=============================================================================
// Starts MCC Campaign
//=======================================================================================================================================================================
private ["_pos","_module","_factionArray","_resualt","_difficulty","_missionMax","_factionCiv","_factionPlayer","_sidePlayer","_factionEnemy","_sideEnemy","_sidePlayer2","_tickets","_missionRotation","_tileSize","_loadDb","_playMusic"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

if (missionNamespace getVariable ["MCC_isCampaignRuning",false]) exitWith {systemChat "Campaign already running"};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["factionPlayer",true]) == typeName "") exitWith {

	_factionPlayer = _module getVariable ["factionPlayer","BLU_F"];
	_sidePlayer = [(getNumber (configfile >> "CfgFactionClasses" >> _factionPlayer >> "side"))] call BIS_fnc_sideType;
	_factionEnemy = _module getVariable ["factionEnemy","OPF_F"];
	_sideEnemy = [(getNumber (configfile >> "CfgFactionClasses" >> _factionEnemy >> "side"))] call BIS_fnc_sideType;
	_factionCiv	= _module getVariable ["factionCiv","CIV_F"];
	_missionMax = _module getVariable ["missionMax",10];
	_difficulty = _module getVariable ["difficulty",20];
	_sidePlayer2 = [_module getVariable ["factionRivalPlayer",7]] call BIS_fnc_sideType;
	_tickets = _module getVariable ["tickets",100];
	_missionRotation = _module getVariable ["missionRotation",4];
	_tileSize = (_module getVariable ["tileSize",250]) max 200;
	_loadDb = _module getVariable ["loadDB",false];
	_playMusic = _module getVariable ["playMusic",1];

	//Start ambient civilians
	[_sidePlayer,_factionPlayer,_sideEnemy,_factionEnemy,_factionCiv,_missionMax,_difficulty,_sidePlayer2,_tickets,_missionRotation,_tileSize,_loadDb,_playMusic] remoteExec ["MCC_fnc_campaignInit",2];


	//Start day/night cycle
	[[_sidePlayer,_sidePlayer2],"MCC_fnc_dayCycle",false,false] spawn BIS_fnc_MP;
};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

_factionArray = [];
{
	_factionArray pushBack (format ["%1(%2)",_x select 0,_x select 1]);
} forEach U_FACTIONS;

 _resualt = ["Starts MCC Campaign - Need: MCC Start Location",[
 						["Players Faction",_factionArray],
 						["Enemy Faction",_factionArray],
 						["Civilians Faction",_factionArray],
 						["Missions Before Campaign Ends",50],
 						["Difficulty",["Easy","Medium","Hard"]],
 						["Rival Players Side",["East","West","Resistance","None"]],
 						["Tickets",200],
 						["Missions Rotation",10],
 						["Tile Size",500],
 						["Load From DB",false],
 						["Intro",["Cinematic","Pop-Up","None"]]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

_factionPlayer = (U_FACTIONS select (_resualt select 0)) select 2;
_sidePlayer = [(getNumber (configfile >> "CfgFactionClasses" >> _factionPlayer >> "side"))] call BIS_fnc_sideType;
_factionEnemy = (U_FACTIONS select (_resualt select 1)) select 2;
_sideEnemy = [(getNumber (configfile >> "CfgFactionClasses" >> _factionEnemy >> "side"))] call BIS_fnc_sideType;
_factionCiv	= (U_FACTIONS select (_resualt select 2)) select 2;
_missionMax = _resualt select 3;
_difficulty = ((_resualt select 4)+1)*10;
_sidePlayer2 = [east,west,resistance,sideLogic] select (_resualt select 5);
_tickets = _resualt select 6;
_missionRotation = _resualt select 7;
_tileSize = _resualt select 8;
_loadDb = _resualt select 9;
_playMusic = _resualt select 10;

//Start ambient civilians
[_sidePlayer,_factionPlayer,_sideEnemy,_factionEnemy,_factionCiv,_missionMax,_difficulty,_sidePlayer2,_tickets,_missionRotation,_tileSize,_loadDb, _playMusic] remoteExec ["MCC_fnc_campaignInit",2];

//Start day/night cycle
[[_sidePlayer,_sidePlayer2],"MCC_fnc_dayCycle",false,false] spawn BIS_fnc_MP;

deleteVehicle _module;