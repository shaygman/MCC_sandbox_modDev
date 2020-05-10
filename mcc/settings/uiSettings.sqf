if (count (allMissionObjects "MCC_Module_inGameUI") == 0) then {
    //View Distance
    [
        "MCC_Settings_ViewDistance",
        "SLIDER",
        [localize "STR_UI_VIEWDISTANCE", localize "STR_UI_SETVIEWDISTANCE"],
        "MCC User Interface",
        [200, 15000, 5000, 0],
        false,
        {
            params ["_value"];
            setViewDistance _value;
        }
    ] call CBA_Settings_fnc_init;

    //Grass
    [
        "MCC_Settings_grassDetail",
        "SLIDER",
        [localize "STR_UI_GRASSDETAIL",localize "STR_UI_SETGRASSDETAIL"],
        "MCC User Interface",
        [1, 50, 10, 0],
        false,
        {
            params ["_value"];
            setTerrainGrid (50 - _value);
        }
    ] call CBA_Settings_fnc_init;

    //MCC Action in mouse wheel
    [
        "MCC_showActionKey",
        "CHECKBOX",
        ["Action Menu","Show MCC action in mouse wheel actions"],
        "MCC User Interface",
        true,
        true
    ] call CBA_Settings_fnc_init;

    //3D person view
    [
        "MCC_Settings_forceCamera",
        "LIST",
        ["Allow 3rd Person","Force first person camera"],
        "MCC User Interface",
        [[0,1,2,3], ["Never","In all vehicles","In aircrafts only","Always"], 3],
        true,
        {
            params ["_value"];
            [_value] call MCC_fnc_forceCamera;
        }
    ] call CBA_Settings_fnc_init;

    //Compass
    [
        "MCC_Settings_compassEnabled",
        "LIST",
        "Interactive Compass HUD",
        ["MCC User Interface","Compass"],
        [[0,1,2],["Only Compass","Show group's units","Disabled"],2],
        true,
        {
            params ["_value"];
            switch (_value) do
            {
                case 2:
                {
                    missionNamespace setVariable ["MCC_initCompassHUD",false];
                    (["MCC_hud"] call BIS_fnc_rscLayer) cutText ["","Plain"];
                    ["MCC_fnc_compHudEVH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
                };

                default
                {
                    (_value == 1) spawn MCC_fnc_initCompassHUD;
                };
            };
        }
    ] call CBA_Settings_fnc_init;

    //Group Markers
    [
        "MCC_groupMarkers",
        "CHECKBOX",
        ["Group Markers","Group markers show on map"],
        ["MCC User Interface","Map"],
        false,
        true
    ] call CBA_Settings_fnc_init;

    //Group Markers
    [
        "MCC_indevidualMarkers",
        "CHECKBOX",
        ["Unit Markers","Unit markers show on map"],
        ["MCC User Interface","Map"],
        false,
        true
    ] call CBA_Settings_fnc_init;

    //name Tags
    [
        "MCC_nameTags",
        "CHECKBOX",
        ["Name Tags","Show nearby units names"],
        ["MCC User Interface","Name Tags"],
        false,
        false
    ] call CBA_Settings_fnc_init;

    //name Tags Direct
    [
        "MCC_NameTags_direct",
        "CHECKBOX",
        ["Name Tags only when pointing","Show nearby units names only when pointing"],
        ["MCC User Interface","Name Tags"],
        false,
        false
    ] call CBA_Settings_fnc_init;

    //Move to server
    //suppression
    [
        "MCC_suppressionOn",
        "CHECKBOX",
        "Suppression Effects",
        ["MCC User Interface","suppression"],
        false,
        true,
        {
            params ["_value"];

            if (_value) then {
                if !(missionNamespace getVariable ["MCC_initSupression",false]) then {[] spawn MCC_fnc_supressionInit};
            } else {
                missionNamespace setVariable ["MCC_initSupression",false];
                ["MCC_initSupression", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
            };
        }
    ] call CBA_Settings_fnc_init;

    //MCC_hitRadar
    [
        "MCC_hitRadar",
        "LIST",
        "Hit direction Effects",
        ["MCC User Interface","suppression"],
        [[0,1,2],["Realistics","Arcade","Off"],0],
        true,
        {
            params ["_value"];

            if (_value != 2) then {
                if !(missionNamespace getVariable ["MCC_initSupression",false]) then {[] spawn MCC_fnc_supressionInit};
            } else {
                missionNamespace setVariable ["MCC_initSupression",false];
                ["MCC_initSupression", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
            };
        }
    ] call CBA_Settings_fnc_init;

    //MCC_hitRadar
    [
        "MCC_UIModuleTickets",
        "CHECKBOX",
        "PvP Interface",
        "MCC User Interface",
        false,
        true,
        {
            params ["_value"];

            if (_value) then {
                [] spawn MCC_fnc_PvPInterface
            };
        }
    ] call CBA_Settings_fnc_init;
};