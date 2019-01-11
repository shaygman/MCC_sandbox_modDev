//Initialize
#define MCC_MWPlayersIDC 6001
#define MCC_MWATMinesIDC 6002
#define MCC_MWAPMinesIDC 6003
#define MCC_MWStealthIDC 6004
#define MCC_MWReinforcementIDC 6005
#define MCC_MWDifficultyIDC 6006
#define MCC_MWObjective1IDC 6007
#define MCC_MWObjective2IDC 6008
#define MCC_MWObjective3IDC 6009
#define MCC_MWVehiclesIDC 6010
#define MCC_MWArmorIDC 6011
#define MCC_MWIEDIDC 6012
#define MCC_MWSBIDC 6013
#define MCC_MWArmedCiviliansIDC 6014
#define MCC_MWCQBIDC 6015
#define MCC_MWRoadBlocksIDC 6016
#define MCC_MWWeatherComboIDC 6017
#define MCC_MCC_MWAreaComboIDC 6018
#define MCC_MWDebugComboIDC 6019
#define MCC_MWPreciseMarkersComboIDC 6020
#define MCC_MWArtilleryIDC 6021

#define FACTIONCOMBO 1001
#define CIVILIANFACTIONCOMBO 6022
#define MCC_MWAnimalsIDC 6023
#define MCC_MCC_MWMusicIDC 6024

private ["_playersNumber","_difficulty","_totalEnemyUnits","_isCQB","_check","_minObjectivesDistance","_maxObjectivesDistance","_enemySide","_enemyfaction","_sidePlayer","_factionPlayer","_obj1","_obj2","_obj3","_wholeMap","_armor","_vehicles","_stealth","_isIED","_isAS","_isRoadblocks","_isCiv","_weatherChange","_isSB","_preciseMarkers","_reinforcement","_artillery","_civFaction","_playMusic","_animals","_markerName","_markers"];

//MCC_MWAnimalsIndex MCC_MWBattleGroundIndex MCC_MWMusicIndex
if (isnil "MCC_MWisGenerating") then {MCC_MWisGenerating = false};
MCC_mcc_screen = 2;
if (MCC_MWisGenerating) exitWith {systemchat "MCC is now generating a mission please try again later"};
MCC_MWisGenerating = true;

//Get params
_playersNumber 		= (sliderPosition  MCC_MWPlayersIDC) + 1;
_civFaction			= (U_FACTIONSCIV select (lbCurSel CIVILIANFACTIONCOMBO)) select 2;
_playMusic			=  profileNamespace getVariable ["MCC_MWMusicIndex",0];
_difficulty 		= ((profileNamespace getVariable ["MCC_MWDifficultyIndex",0])+1) * 2;		//each player == 3 enemy players multiply by difficulty
_stealth 			= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWStealthIndex",2]);
_isIED 				= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWIEDIndex",2]);
_isSB 				= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWSBIndex",2]);
_isAS 				= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWArmedCiviliansIndex",2]);
_isRoadblocks 		= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWRoadBlockIndex",2]);
_armor 				= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWArmorIndex",2]);
_vehicles 			= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWVehiclesIndex",2]);
_animals 			= [false,true,([true,false] call BIS_fnc_selectRandom)] select (profileNamespace getVariable ["MCC_MWAnimalsIndex",2]);
_wholeMap 			= [true,false] select (profileNamespace getVariable ["MCC_MWAreaIndex",0]);
_markers 			= [false,true] select (profileNamespace getVariable ["MCC_MWDebugIndex",0]);
_preciseMarkers 	= [true,false] select (profileNamespace getVariable ["MCC_MWPreciseMarkersIndex",0]);

_weatherChange		= lbCurSel MCC_MWWeatherComboIDC;
_reinforcement		= (lbCurSel MCC_MWReinforcementIDC);
_artillery			= (lbCurSel MCC_MWArtilleryIDC);

//CQB
switch (lbCurSel MCC_MWCQBIDC) do
	{
		case 0:
		{
			_isCQB 	=  false;
			_isCiv	=  false;
		};

		case 1:
		{
			_isCQB 	=  true;
			_isCiv	=  false;
		};

		case 2:
		{
			_isCQB 	=  true;
			_isCiv	=  true;
		};

		case 3:
		{
			_isCQB 	=  [true,false] call BIS_fnc_selectRandom;
			_isCiv	=  [true,false] call BIS_fnc_selectRandom;
		};
	};

//Objectives
_obj1 				= MCC_MWMissionType select (lbCurSel MCC_MWObjective1IDC);
_obj2 				= MCC_MWMissionType select (lbCurSel MCC_MWObjective2IDC);
_obj3 				= MCC_MWMissionType select (lbCurSel MCC_MWObjective3IDC);

//Player depends parmas
_sidePlayer 		= side player;
_factionPlayer 		= faction player;
_enemySide			= mcc_sidename;
_totalEnemyUnits 	= if ((_playersNumber * _difficulty)>10) then {(_playersNumber * _difficulty)} else {20};

_minObjectivesDistance 	= if (_isCQB) then {100} else {200};
_maxObjectivesDistance 	= (_minObjectivesDistance*1.5) + (10*_playersNumber);

//What side and faction are we fighting here,
if (typeName _enemySide == "STRING") then
{
	switch (toLower _enemySide) do
	{
		case "west": {_enemySide =  west};
		case "east": {_enemySide =  east};
		case "guer": {_enemySide =  resistance};
		case "civ": {_enemySide =  civilian};
	};
};

//What faction are we fighiting?
_enemyfaction = getText (configFile >> "CfgVehicles" >> (U_GEN_SOLDIER select 0 select 1) >> "faction");
if (isnil "_enemyfaction") exitWith
{
	diag_log "MCC MW: Faction is empty";
	MCC_MWisGenerating = false;
	["MCC: Mission Wizard Error: Faction doesn't have any units in it"] spawn MCC_fnc_halt;
};

//Build the faction's unitsArrays and send it to the server.
_check = [] call MCC_fnc_MWCreateUnitsArray;
waituntil {_check};

//Send user custom groups to the server
MCC_customGroupsSaveMW = [];
{
	if (_enemyfaction == (_x select 0)) then
	{
		MCC_customGroupsSaveMW set [count MCC_customGroupsSaveMW, [_x select 3,_x select 4,_x select 2]];
	};
} foreach MCC_customGroupsSave;

publicVariableServer "MCC_customGroupsSaveMW";
publicVariableServer "mcc_zone_markposition";
publicVariableServer "mcc_zone_marker_X";
publicVariableServer "mcc_zone_marker_Y";

if (MCC_debug) then {systemchat format ["Total enemy's units: %1", _totalEnemyUnits]};
diag_log format ["MCC Mission Wizard total enemy Count = %1", _totalEnemyUnits];

//------------------------------------------------------------- Here we go  Create loading text----------------------------------------------------------------
while {dialog} do {closedialog 0; sleep 0.2};
[] spawn
	{
		private ["_string","_footer"];
		while {missionNamespace getVariable ["MCC_MWisGenerating",false]} do
		{
			for [{_x=1},{_x<=10},{_x=_x+1}]  do //Create progress bar
			{
				_footer = [_x,10] call MCC_fnc_countDownLine;
				//add header
				_string = "<t color='#E2EEE0' size='0.85' shadow='0' align='center'>" + "Building A Mission <br/>Please Wait" + "</t><br/><br/>";
				//add _footer
				_string = _string + "<t color='#E2EEE0' size='0.85' shadow='0' align='center'>" + _footer + "</t>";
				sleep 0.1;
				[_string,0,0.2,0.5,0,0,4] spawn BIS_fnc_dynamicText;
			};
		};
	};


//Build the mission on the server
[
	[_wholeMap, _totalEnemyUnits,  _minObjectivesDistance, _maxObjectivesDistance, _weatherChange, _preciseMarkers, _playMusic,_markers],
	[_enemySide, _enemyfaction, _sidePlayer, _factionPlayer, _civFaction],
	[_obj1, _obj2, _obj3],
	[_isCQB, _isCiv, _armor, _vehicles, _stealth, _isIED, _isAS, _isSB, _isRoadblocks, _animals],
	[_reinforcement, _artillery]
] remoteExec ["MCC_fnc_MWinitMission",2];
