/*============================================================MCC_fnc_cover===============================================================================================
//Manage cover mechanics
// Example: [] call MCC_fnc_cover;
//==================================================================================================================================================================*/
private ["_center","_left","_right","_up","_cover","_centerFront","_leftFront","_rightFront","_upFront","_cover","_headPos","_currentAnim","_string","_centerFrontFarLeft","_centerFrontFarRight","_stance","_isWall","_pos","_leftFrontClose","_rightFrontClose","_rightClose","_leftClose","_pelvis","_pelvisFront","_pelvisFrontFarLeft","_pelvisFrontFarRight","_centerpelvis","_upFrontLeft","_upFrontRight","_obstacleLow","_obstacleMed","_obstacleHigh","_openingHigh","_openingMed","_openingLow","_centerpelvisDown","_pelvisDownFront","_pelvisDownFrontFarLeft","_pelvisDownFrontFarRight"];
#define	 MCC_fnc_coverPELVISDOWN	-0.5

if(alive player && vehicle player == player && (missionNamespace getVariable ["MCC_cover",false])) then {

	//get relative positions
	_headPos 		= player selectionPosition "head";
	_center 		= player modelToWorld [(_headPos select 0),(_headPos select 1),(_headPos select 2)];
	_centerFront	= player modelToWorld [(_headPos select 0),(_headPos select 1)+1,(_headPos select 2)];
	_centerFrontFarLeft	= player modelToWorld [(_headPos select 0)-0.3,(_headPos select 1)+1.5,(_headPos select 2)];
	_centerFrontFarRight	= player modelToWorld [(_headPos select 0)+0.3,(_headPos select 1)+1.5,(_headPos select 2)];

	_up 			= player modelToWorld [(_headPos select 0),(_headPos select 1),(_headPos select 2)+0.5];
	_upFront 		= player modelToWorld [(_headPos select 0),(_headPos select 1)+2,(_headPos select 2)+0.5];
	_upFrontLeft	= player modelToWorld [(_headPos select 0)-0.3,(_headPos select 1)+1.5,(_headPos select 2)+0.5];
	_upFrontRight	= player modelToWorld [(_headPos select 0)+0.3,(_headPos select 1)+1.5,(_headPos select 2)+0.5];

	_pelvis			= player selectionPosition "pelvis";

	_centerpelvis	= player modelToWorld [(_pelvis select 0),(_pelvis select 1),(_pelvis select 2)];
	_pelvisFront	= player modelToWorld [(_pelvis select 0),(_pelvis select 1)+1.2,(_pelvis select 2)];
	_pelvisFrontFarLeft	= player modelToWorld [(_pelvis select 0)-0.3,(_pelvis select 1)+1.5,(_pelvis select 2)];
	_pelvisFrontFarRight = player modelToWorld [(_pelvis select 0)+0.3,(_pelvis select 1)+1.5,(_pelvis select 2)];

	_centerpelvisDown	= player modelToWorld [(_pelvis select 0),(_pelvis select 1),(_pelvis select 2)+MCC_fnc_coverPELVISDOWN];
	_pelvisDownFront	= player modelToWorld [(_pelvis select 0),(_pelvis select 1)+1.2,(_pelvis select 2)+MCC_fnc_coverPELVISDOWN];
	_pelvisDownFrontFarLeft	= player modelToWorld [(_pelvis select 0)-0.3,(_pelvis select 1)+1.5,(_pelvis select 2)+MCC_fnc_coverPELVISDOWN];
	_pelvisDownFrontFarRight = player modelToWorld [(_pelvis select 0)+0.3,(_pelvis select 1)+1.5,(_pelvis select 2)+MCC_fnc_coverPELVISDOWN];


	_left 			= player modelToWorld [(_headPos select 0)-0.4,(_headPos select 1),(_headPos select 2)];
	_leftClose		= player modelToWorld [(_headPos select 0)-0.2,(_headPos select 1),(_headPos select 2)];
	_right 			= player modelToWorld [(_headPos select 0)+0.4,(_headPos select 1),(_headPos select 2)];
	_rightClose		= player modelToWorld [(_headPos select 0)+0.2,(_headPos select 1),(_headPos select 2)];


	_leftFront 		= player modelToWorld [(_headPos select 0)-0.4,(_headPos select 1)+2,(_headPos select 2)];
	_leftFrontClose	= player modelToWorld [(_headPos select 0)-0.2,(_headPos select 1)+2,(_headPos select 2)];
	_rightFront 	= player modelToWorld [(_headPos select 0)+0.4,(_headPos select 1)+2,(_headPos select 2)];
	_rightFrontClose= player modelToWorld [(_headPos select 0)+0.2,(_headPos select 1)+2,(_headPos select 2)];

	_stance 		= stance player;

	if (missionNamespace getVariable ["MCC_fnc_coverDebug",false]) then {

		{
			_color = if !(lineIntersects [ATLtoASL _center, ATLtoASL _x]) then {[1,1,1,1]} else {[1,0,0,1]};
			drawLine3D [_center,_x,_color];
		} forEach [_centerFrontFarLeft,_centerFrontFarRight];

		{
			_color = if !(lineIntersects [ATLtoASL _centerpelvis, ATLtoASL _x]) then {[1,1,1,1]} else {[1,0,0,1]};
			drawLine3D [_centerpelvis,_x, _color];
		} forEach [_pelvisFrontFarLeft,_pelvisFrontFarRight];

		{
			_color = if !(lineIntersects [ATLtoASL _centerpelvisDown, ATLtoASL _x]) then {[1,1,1,1]} else {[1,0,0,1]};
			drawLine3D [_centerpelvisDown,_x, _color];
		} forEach [_pelvisDownFrontFarLeft,_pelvisDownFrontFarRight];

		{
			_color = if !(lineIntersects [ATLtoASL _up, ATLtoASL _x]) then {[1,1,1,1]} else {[1,0,0,1]};
			drawLine3D [_up,_x, _color];
		} forEach [_upFrontLeft,_upFrontRight];
	};

	//Are we behind cover
	if (lineIntersects [ATLtoASL _centerpelvisDown, ATLtoASL _pelvisDownFront] ||
		lineIntersects [ATLtoASL _centerpelvis, ATLtoASL _pelvisFront] ||
		lineIntersects [ATLtoASL _center, ATLtoASL _centerFront] ) then {

		player setVariable ["MCC_behindCover", true];
		_cover = switch (true) do
				{
					case (!(lineIntersects [ATLtoASL _up, ATLtoASL _upFront]) && (lineIntersects [ATLtoASL _center, ATLtoASL _centerFront])): {"up"};
					case (!(lineIntersects [ATLtoASL _right, ATLtoASL _rightFront]) && (lineIntersects [ATLtoASL _rightClose, ATLtoASL _rightFrontClose])): {"right"};
					case (!(lineIntersects [ATLtoASL _left, ATLtoASL _leftFront]) && (lineIntersects [ATLtoASL _leftClose, ATLtoASL _leftFrontClose])): {"left"};
					case (!(lineIntersects [ATLtoASL _center, ATLtoASL _centerFront])): {"center"};
					default {"none"}
				};


		_obstacleLow = (lineIntersects [ATLtoASL _centerpelvisDown, ATLtoASL _pelvisDownFront]);
		_obstacleMed= (lineIntersects [ATLtoASL _centerpelvis, ATLtoASL _pelvisFront]);
		_obstacleHigh = (lineIntersects [ATLtoASL _center, ATLtoASL _centerFront]);

		_openingLow = !(lineIntersects [ATLtoASL _centerpelvis, ATLtoASL _pelvisFrontFarLeft]) && !(lineIntersects [ATLtoASL _centerpelvis, ATLtoASL _pelvisFrontFarRight]);
		_openingMed = !(lineIntersects [ATLtoASL _center, ATLtoASL _centerFrontFarLeft]) && !(lineIntersects [ATLtoASL _center, ATLtoASL _centerFrontFarRight]);
		_openingHigh = !(lineIntersects [ATLtoASL _up, ATLtoASL _upFrontLeft]) && !(lineIntersects [ATLtoASL _up, ATLtoASL _upFrontRight]);

		//are we behind a wall
		_isWall = (_stance in ["STAND"] &&
		          (_obstacleLow || _obstacleMed || _obstacleHigh) &&
		 	      (_openingLow || _openingMed || _openingHigh)
		    );


		_wallHigh = "";
		//Wall climbing
		if (_isWall) then {
			_wallHigh = switch (true) do
						{
							case _openingLow:{"low"};
							case _openingMed:{"med"};
							case _openingHigh:{"high"};
							default	{""};
						};
		};

		player setVariable ["MCC_wallAhead", _wallHigh];

		//UI?
		if ((missionNameSpace getVariable ["MCC_coverUI",true]) && (player getVariable ["MCC_mirrorCamOff",true])) then
		{
			_string = "";
			switch (_cover) do
			{
				case "up": {_string = format ["<img align='left' size='1' image='%1data\cover\coverU.paa'/>",MCC_path]};
				case "right": {_string = format ["<img align='left' size='1' image='%1data\cover\coverR.paa'/>",MCC_path]};
				case "left": {_string = format ["<img align='left' size='1' image='%1data\cover\coverL.paa'/>",MCC_path]};
			};

			if ((player getVariable ["MCC_wallAhead", ""])!="") then {
				if (MCC_isCBA) then {
						_string = _string + format ["<br/><t font='puristaMedium' size='0.4' align='left'> Press %1 to climb",["MCC","vaultOver"] call MCC_fnc_getKeyFromCBA];
					} else {
						_string = _string + format ["<br/><t font='puristaMedium' size='0.4' align='left'> Press %1 to climb",keyName ((actionKeys "GetOver") select 0)];
					};
			};

			if (alive player) then {[_string,0.5,1,0.1,0,0,1] spawn BIS_fnc_dynamicText};
		};


		if (cameraView == "GUNNER" && _cover in ["up","left","right"] && speed player == 0 && !(player getVariable ["MCC_fnc_coverInCover",false])) exitWith {

			[_cover] spawn {
				private ["_cover","_currentAnim","_pos"];

				_cover = _this select 0;
				_currentAnim = animationState player;
				_pos = getpos player;

				player setVariable ["MCC_fnc_coverInCover",true];

				switch(_cover) do {
					case "up":
					{
						player playactionNow "AdjustF";
					};
					case "right":
					{
						player playactionNow "AdjustR";
					};
					case "left":
					{
						player playactionNow "AdjustL";
					};
				};

				//Release the stucking anim
				sleep 0.05;
				player playMoveNow animationState player;
				sleep 0.1;

				//Work around for prone
				if (cameraView == "GUNNER") then {

					waituntil {cameraView != "GUNNER" || (_pos distance getpos player)>1.5 || !alive player};

					//player playactionNow format ["player%1",_stance];
					player playmoveNow _currentAnim;

					if (_currentAnim in ["aadjpknlmstpsraswrflddown","aadjpercmstpsraswrflddown","aadjpknlmstpsraswrfldup","aadjppnemstpsraswrfldup"]) then {
						sleep 0.4;
						player switchMove _currentAnim;
					};
				};

				player setVariable ["MCC_fnc_coverInCover",false];
			};
		};
	} else {
		player setVariable ["MCC_behindCover", false];
	};
};