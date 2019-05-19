#define FACTIONCOMBO 1001
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

#define CIVILIANFACTIONCOMBO 6022
#define MCC_MWAnimalsIDC 6023
#define MCC_MWBattleGroundIDC 6024
#define MCC_MCC_MWMusicIDC 6024

private ["_mccdialog","_comboBox","_displayname","_missionTypeIcons"];
disableSerialization;

uiNamespace setVariable ["MCC_MWDialog", _this select 0];
_mccdialog = _this select 0;

MCC_mcc_screen = 3;


_missionTypeIcons = missionNamespace getVariable ["MCC_MWMissionTypeIcons",[]];

_comboBox = _mccdialog displayCtrl FACTIONCOMBO;		//fill combobox CFG factions
	lbClear _comboBox;
	{
		_displayname = format ["%1(%2)",_x select 0,_x select 1];
		_comboBox lbAdd _displayname;
	} foreach U_FACTIONS;
	_comboBox lbSetCurSel MCC_faction_index;

//------------------------------------------- Civilians -------------------------------------------------------------------------------------------------
_comboBox = _mccdialog displayCtrl CIVILIANFACTIONCOMBO;		//fill combobox CFG factions
	lbClear _comboBox;
	{
		_displayname = format ["%1(%2)",_x select 0,_x select 1];
		_comboBox lbAdd _displayname;
	} foreach U_FACTIONSCIV;
_comboBox lbSetCurSel 0;

//------------------------------------------- ZONES --------------------------------------------------------------------------------------------------
_comboBox = _mccdialog displayCtrl 1023; //fill combobox zone's numbers
lbClear _comboBox;
{
	_displayname = format ["%1",_x];
	_comboBox lbAdd _displayname;
} foreach (missionNamespace getVariable ["MCC_zones_numbers",[]]);
_comboBox lbSetCurSel MCC_zone_index;

//==========================       Mission Wizard ===============================================

//Number of players
_comboBox = _mccdialog displayCtrl MCC_MWPlayersIDC;
_comboBox sliderSetRange [1, MCC_MWmaxPlayers];
_comboBox sliderSetPosition (profileNamespace getVariable ["MCC_MWPlayersIndex",(floor MCC_MWmaxPlayers/2)]);
_comboBox sliderSetSpeed [1, 1];

//Stealth
_comboBox = _mccdialog displayCtrl MCC_MWStealthIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWStealthIndex",2]),true];

//Objective markers
_comboBox = _mccdialog displayCtrl MCC_MWPreciseMarkersComboIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWPreciseMarkersIndex",0]),true];

//General Markers
_comboBox = _mccdialog displayCtrl MCC_MWDebugComboIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWDebugIndex",0]),true];

_comboBox = _mccdialog displayCtrl MCC_MWReinforcementIDC;
lbClear _comboBox;
{
	_displayname = _x;
	_comboBox lbAdd _displayname;
} foreach ["No","Yes - Aerial","Yes - Motorized","Yes - Random"];
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWReinforcementIndex",3]);

//Difficulty
_comboBox = _mccdialog displayCtrl MCC_MWDifficultyIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWDifficultyIndex",0]),true];


//Objective 1
_comboBox = _mccdialog displayCtrl MCC_MWObjective1IDC;
lbClear _comboBox;
{
	_index = _comboBox lbAdd _x;
	_comboBox lbSetPictureRight [_index,(_missionTypeIcons) select _foreachindex]
} foreach MCC_MWMissionType;
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWObjective1Index",0]);

//Objective 2
_comboBox = _mccdialog displayCtrl MCC_MWObjective2IDC;
lbClear _comboBox;
{
	_index = _comboBox lbAdd _x;
	_comboBox lbSetPictureRight [_index,(_missionTypeIcons) select _foreachindex]
} foreach MCC_MWMissionType;
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWObjective2Index",0]);


//Objective 3
_comboBox = _mccdialog displayCtrl MCC_MWObjective3IDC;
lbClear _comboBox;
{
	_index = _comboBox lbAdd _x;
	_comboBox lbSetPictureRight [_index,(_missionTypeIcons) select _foreachindex]
} foreach MCC_MWMissionType;
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWObjective3Index",0]);

//Vehicles
_comboBox = _mccdialog displayCtrl MCC_MWVehiclesIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWVehiclesIndex",2]),true];

//Armor
_comboBox = _mccdialog displayCtrl MCC_MWArmorIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWArmorIndex",2]),true];

//Artillery
_comboBox = _mccdialog displayCtrl MCC_MWArtilleryIDC;
lbClear _comboBox;
{
	_displayname = _x;
	_comboBox lbAdd _displayname;
} foreach ["No","Mortars","Self Propelled Artillery","Random"];
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWArtilleryIndex",3]);

//Music
_comboBox = _mccdialog displayCtrl MCC_MCC_MWMusicIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWMusicIndex",0]),true];

//IED
_comboBox = _mccdialog displayCtrl MCC_MWIEDIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWIEDIndex",2]),true];

//Suicide Bombers
_comboBox = _mccdialog displayCtrl MCC_MWSBIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWSBIndex",2]),true];

//Armed Civilians
_comboBox = _mccdialog displayCtrl MCC_MWArmedCiviliansIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWArmedCiviliansIndex",2]),true];

//CQB
_comboBox = _mccdialog displayCtrl MCC_MWCQBIDC;
lbClear _comboBox;
{
	_displayname = _x;
	_comboBox lbAdd _displayname;
} foreach ["No","Yes Without Civilians","Yes With Civilians","Random"];
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWCQBIndex",3]);

//Roadblocks
_comboBox = _mccdialog displayCtrl MCC_MWRoadBlocksIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWRoadBlockIndex",2]),true];

//Animals
_comboBox = _mccdialog displayCtrl MCC_MWAnimalsIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWAnimalsIndex",2]),true];

//Weather
_comboBox = _mccdialog displayCtrl MCC_MWWeatherComboIDC;
lbClear _comboBox;
{
	_displayname = _x;
	_comboBox lbAdd _displayname;
} foreach ["Don't change","Random","Sandstorm","Blizzard","Snow"];
_comboBox lbSetCurSel (profileNamespace getVariable ["MCC_MWWeatherIndex",1]);

//Mission Area
_comboBox = _mccdialog displayCtrl MCC_MCC_MWAreaComboIDC;
_comboBox ctrlSetChecked [(profileNamespace getVariable ["MCC_MWAreaIndex",0]),true];