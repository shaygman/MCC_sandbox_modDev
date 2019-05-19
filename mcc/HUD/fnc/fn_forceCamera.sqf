/*====================================================================== MCC_fnc_forceCamera =============================================================
	Force first person camera mod

	<IN>
		0: INTEGER - mode, 	0: always force first person
							1: allow 3rd person in all vehicles
							2: allow 3rd person only in air in vehicles
*/

params ["_mode"];

//Force Camera
player setVariable ["MCC_forceCameraMode",_mode];

[] spawn {

	if (missionNamespace getVariable ["MCC_forceCamera",false]) exitWith {};

	missionNamespace setVariable ["MCC_forceCamera",true];

	while {true} do {

		waitUntil {cameraView == "External"};

		switch (player getVariable ["MCC_forceCameraMode",3]) do {

			//Always
		    case 0: {
		    	player switchCamera "Internal";
		    };

		    //vehicles
		    case 1: {
		    	if (vehicle player == player) then {player switchCamera "Internal"};
		    };

		    case 2: {
		     	if (!(vehicle player isKindOf "air") ) then {player switchCamera "Internal"};
		    };
		};

		sleep 0.1;
	};

	missionNamespace setVariable ["MCC_forceCamera",false];
};