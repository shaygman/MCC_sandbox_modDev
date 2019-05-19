//IED small
[
    "MCC_ied_small",
    "EDITBOX",
    ["IEDs small","Array first element is display name, second is the object class"],
    ["MCC Classes", "IED"],
    '[["Plastic Crates","Land_CratesPlastic_F"],["Plastic Canister","Land_CanisterPlastic_F"],["Sack","Land_Sack_F"],["Road Cone","RoadCone"],["Tyre","Land_Tyre_F"],["Radio","Land_SurvivalRadio_F"],["Suitcase","Land_Suitcase_F"],["Grinder","Land_Grinder_F"],["MultiMeter","Land_MultiMeter_F"],["Plastic Bottle","Land_BottlePlastic_V1_F"],["Fuel Canister","Land_CanisterFuel_F"],["FM Radio","Land_FMradio_F"],["Camera","Land_HandyCam_F"],["Laptop","Land_Laptop_F"],["Mobile Phone","Land_MobilePhone_old_F"],["Smart Phone","Land_MobilePhone_smart_F"],["Longrange Radio","Land_PortableLongRangeRadio_F"],["Satellite Phone","Land_SatellitePhone_F"],["Money","Land_Money_F"]]',
    true,
    {
        params ["_value"];
        MCC_ied_small = call compile _value;
    }
] call CBA_Settings_fnc_init;

//IED medium
[
    "MCC_ied_medium",
    "EDITBOX",
    ["IEDs medium","Array first element is display name, second is the object class"],
    ["MCC Classes", "IED"],
    '[["Wheel Cart","Land_WheelCart_F"],["Metal Barrel","Land_MetalBarrel_F"],["Plastic Barrel","Land_BarrelSand_F"],["Pipes","Land_Pipes_small_F"],["Wooden Crates","Land_CratesShabby_F"],["Wooden Box","Land_WoodenBox_F"],["Cinder Blocks","Land_Ytong_F"],["Sacks Heap","Land_Sacks_heap_F"], ["Water Barrel","Land_WaterBarrel_F"],["Water Tank","Land_WaterTank_F"]]',
    true,
    {
        params ["_value"];
        MCC_ied_medium = call compile _value;
    }
] call CBA_Settings_fnc_init;

//IED wrecks
[
    "MCC_ied_wrecks",
    "EDITBOX",
    ["IEDs wrecks","Array first element is display name, second is the object class"],
    ["MCC Classes", "IED"],
    '[["MI-48","Land_UWreck_Heli_Attack_02_F"],["BMP2","Land_Wreck_BMP2_F"],["Car","Land_Wreck_Car_F"],["Car2","Land_Wreck_Car2_F"],["Car Dismantled","Land_Wreck_CarDismantled_F"],["Blackfoot","Land_Wreck_Heli_Attack_01_F"],["HMMW","Land_Wreck_HMMWV_F"],["Hunter","Land_Wreck_Hunter_F"],["Offroad2","Land_Wreck_Offroad2_F"],["Skoda","Land_Wreck_Skodovka_F"],["Slammer","Land_Wreck_Slammer_F"],["T72","Land_Wreck_T72_hull_F"],["Truck","Land_Wreck_Truck_dropside_F"],["Truck2","Land_Wreck_Truck_F"],["UAZ","Land_Wreck_UAZ_F"],["Van","Land_Wreck_Van_F"],["Car Wreck","Land_Wreck_Car3_F"],["BRDM Wreck","Land_Wreck_BRDM2_F"],["Offroad Wreck","Land_Wreck_Offroad_F"],["Truck Wreck","Land_Wreck_Truck_FWreck"]]',
    true,
    {
        params ["_value"];
        MCC_ied_wrecks = call compile _value;
    }
] call CBA_Settings_fnc_init;

//IED Hidden
[
    "MCC_ied_hidden",
    "EDITBOX",
    ["IEDs wrecks","Array first element is display name, second is the object class"],
    ["MCC Classes", "IED"],
    '[["Dirt Small","IEDLandSmall_Remote_Ammo"],["Dirt Big","IEDLandBig_Remote_Ammo"],["Urban Small","IEDUrbanSmall_Remote_Ammo"],["Urban Big","IEDUrbanBig_Remote_Ammo"]]',
    true,
    {
        params ["_value"];
        MCC_ied_hidden = call compile _value;
    }
] call CBA_Settings_fnc_init;

//-======================= Convoy ==========================
//HVT
[
    "MCC_convoyHVT",
    "EDITBOX",
    ["HVT","High value target, array first element is display name, second is the unit class"],
    ["MCC Classes", "Convoy"],
    '[["None","0"],["B.Officer","B_officer_F"],["B. Pilot","B_Helipilot_F"],["O. Officer","O_officer_F"],["O. Pilot","O_helipilot_F"],["I.Commander","I_officer_F"],["Citizen","C_man_polo_1_F"],["C.Pilot","C_man_pilot_F"],["Orestes","C_Orestes"],["Nikos","C_Nikos"],["Hunter","C_man_hunter_1_F"],["Kerry","I_G_Story_Protagonist_F"]]',
    true,
    {
        params ["_value"];
        MCC_convoyHVT = call compile _value;
    }
] call CBA_Settings_fnc_init;

//HVT
[
    "MCC_convoyHVTcar",
    "EDITBOX",
    ["HVT Vehicle","High value target, array first element is display name, second is the vehicle class"],
    ["MCC Classes", "Convoy"],
    '[["Default",""],["Hunter","B_Hunter_F"],["MRAP","I_MRAP_03_F"],["Quadbike","B_Quadbike_F"],["Ifrit","O_Ifrit_F"],["Offroad","C_Offroad_01_F"],["SUV","C_SUV_01_F"],["Hatchback","C_Hatchback_01_F"]]',
    true,
    {
        params ["_value"];
        MCC_convoyHVTcar = call compile _value;
    }
] call CBA_Settings_fnc_init;