// Eden editor top menu: "MCC 5" (works with or without 3den Enhanced; both append to the same menu strip).
class ctrlMenuStrip;
class Display3DEN
{
	class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
				items[] += {"MCC5_Menu"};

				class MCC5_Menu
				{
					text = "MCC 5";
					items[] = {"MCC5_Settings","MCC5_Modules","MCC5_SettingsModules","MCC5_Separator","MCC5_Zeus","MCC5_About"};
				};
				class MCC5_Settings
				{
					text = "MCC 5 Mission Settings...";
					picture = "\mcc_sandbox_mod\data\mod.paa";
					action = "edit3DENMissionAttributes 'MCC5';";
				};
				class MCC5_Modules
				{
					text = "Place MCC Module";
					items[] = {"MCC5_M0","MCC5_M1","MCC5_M2","MCC5_M3","MCC5_M4","MCC5_M5","MCC5_M6","MCC5_M7","MCC5_M8","MCC5_M9","MCC5_M10","MCC5_M11","MCC5_M12"};
				};
				class MCC5_SettingsModules
				{
					text = "Place Settings Module";
					items[] = {"MCC5_S0","MCC5_S1","MCC5_S2","MCC5_S3","MCC5_S4"};
				};
				class MCC5_M0
				{
					text = "Mission Wizard";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_missionWizard',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M1
				{
					text = "Convoy";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_convoy',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M2
				{
					text = "Fire Mission";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_fireMission',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M3
				{
					text = "Music / Sound";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_music',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M4
				{
					text = "Create Zone";
					action = "private _e = create3DENEntity ['Logic','mcc_Module_createZones',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M5
				{
					text = "Campaign Init";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_campaignInit',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M6
				{
					text = "Capture Point";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_captureZone',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M7
				{
					text = "IED / Suicide Bomber";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_createIED',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M8
				{
					text = "Evac Vehicle";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_createEvac',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M9
				{
					text = "Intel";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_createIntel',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M10
				{
					text = "Vehicle Respawn";
					action = "private _e = create3DENEntity ['Logic','MCC_module_vehicleRespawn',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M11
				{
					text = "Start Location";
					action = "private _e = create3DENEntity ['Logic','mcc_sandbox_moduleStartLocations',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_M12
				{
					text = "Access Rights";
					action = "private _e = create3DENEntity ['Logic','mcc_sandbox_module',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_S0
				{
					text = "General";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_settings',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_S1
				{
					text = "GAIA";
					action = "private _e = create3DENEntity ['Logic','mcc_sandbox_moduleGAIASettings',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_S2
				{
					text = "Mission Wizard";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_settingsMissionWizard',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_S3
				{
					text = "Mechanics";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_settingsMechanics',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_S4
				{
					text = "Medical System";
					action = "private _e = create3DENEntity ['Logic','MCC_Module_settingsMedicSystem',screenToWorld [0.5,0.5]]; if (!isNull _e) then {set3DENSelected [_e]; do3DENAction 'OpenAttributes'};";
				};
				class MCC5_Separator
				{
					value = 0;
				};
				class MCC5_Zeus
				{
					text = "In-game: Zeus (Ctrl+Delete / Y) > Modules > MCC";
					action = "['In game, MCC users get Zeus. Press Ctrl+Delete or Y, then Modules > MCC.', 0, 8] call BIS_fnc_3DENNotification;";
				};
				class MCC5_About
				{
					text = "About MCC 5";
					picture = "\mcc_sandbox_mod\data\mod.paa";
					action = "['MCC Sandbox 5 - Mission Control Center. Settings: MCC 5 > Mission Settings. Modules: MCC 5 > Place MCC Module.', 0, 10] call BIS_fnc_3DENNotification;";
				};
			};
		};
	};
};
