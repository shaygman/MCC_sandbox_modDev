/*===============================================  MCC_fnc_curatorDrawLine =========================================================================

	Draw a line from object to user designated area
*/
params [
	["_object", objNull, [objNull]],
	["_code",{},[missionNamespace,{}]],
	["_text", ""],
	["_icon", "\a3\ui_f\data\IGUI\Cfg\Cursors\select_target_ca.paa"],
	["_color", [1,0,0,1]]
];

//can't run twice
if (missionNamespace getVariable ["MCC_fnc_curatorDrawLineRuning", false]) exitWith {};

MCC_fnc_curatorDrawLineRuning = true;

// Mouse EH
MCC_fnc_curatorDrawLine_mouseEH = [findDisplay 312, "mouseButtonDown", {
    params ["", "_mouseButton", "", "", "_shift", "_ctrl", "_alt"];

    //LMB clicked
    if (_mouseButton == 0) then {

	    _thisArgs params ["_object", "_code"];

	    // Get mouse position on 2D map or 3D world
	    private _mousePosASL = if (ctrlShown ((findDisplay 312) displayCtrl 50)) then {
	        private _pos2d = (((findDisplay 312) displayCtrl 50) ctrlMapScreenToWorld getMousePosition);
	        _pos2d set [2, getTerrainHeightASL _pos2d];
	        _pos2d
	    } else {
	        AGLToASL (screenToWorld getMousePosition);
	    };

	   [true, _object, _mousePosASL, _shift, _ctrl, _alt] spawn _code;
	   MCC_fnc_curatorDrawLineRuning = false;
   } else {
   	//RMB - cancel
   		MCC_fnc_curatorDrawLineRuning = false;
       	[false, _object, [0,0,0], false, false, false] spawn _code;
   };
}, [_object, _code]] call CBA_fnc_addBISEventHandler;

// Add draw EH for the zeus map - draws the 2D icon and line
MCC_fnc_curatorDrawLine_mapEH = [((findDisplay 312) displayCtrl 50), "draw", {
    params ["_mapCtrl"];

    _thisArgs params ["_object", "_text", "_icon", "_color"];

    private _pos2d = (((findDisplay 312) displayCtrl 50) ctrlMapScreenToWorld getMousePosition);
    _mapCtrl drawIcon [_icon, _color, _pos2d, 30, 30, 0, _text, 1, 0.04, "TahomaB", "center"];
    _mapCtrl drawLine [getPos _object, _pos2d, _color];
}, [_object, _text, _icon, _color, 0]] call CBA_fnc_addBISEventHandler;

// Add draw EH for 3D camera view - draws the 3D icon and line
[{
    (_this select 0) params ["_object", "_code", "_text", "_icon", "_color"];
    if ((isNull _object) || {isNull findDisplay 312} || {!isNull findDisplay 49}) then {
        MCC_fnc_curatorDrawLineRuning = false;
        [false, _object, [0,0,0], false, false, false] spawn _code;
    };
    if (MCC_fnc_curatorDrawLineRuning) then {
        // Draw the 3d icon and line
        private _mousePosAGL = screenToWorld getMousePosition;
        drawIcon3D [_icon, _color, _mousePosAGL, 2, 2, 0, _text];
        drawLine3D [_mousePosAGL, getpos _object, _color];;
    } else {
        (_this select 1) call CBA_fnc_removePerFrameHandler;
        (findDisplay 312) displayRemoveEventHandler ["mouseButtonDown", MCC_fnc_curatorDrawLine_mouseEH];
        ((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["draw", MCC_fnc_curatorDrawLine_mapEH];
        MCC_fnc_curatorDrawLine_mouseEH = nil;
        MCC_fnc_curatorDrawLine_mapEH = nil;
    };
}, 0, [_object, _code, _text, _icon, _color]] call CBA_fnc_addPerFrameHandler;