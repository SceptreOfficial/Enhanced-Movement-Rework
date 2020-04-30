#include "script_component.hpp"

params ["_unit"];

if (!GVAR(allowMidairClimbing) && !isTouchingGround _unit) exitWith {[false,false,0]};

private _debug = [];
private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;
private _dirVect = _dir vectorMultiply 1.2;
private _height = 0;
private _noIntersectCount = 0;

// Obstacle detection
{
	if (_x > GVAR(maxClimbHeight)) exitWith {};

	private _beg = _pos vectorAdd [0,0,_x];
	private _end = _beg vectorAdd _dirVect;

	if (GVAR(debug)) then {
		[{drawLine3D _this},{},[ASLToATL _beg,ASLToATL _end,[0,1,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	};
	
	private _ix = lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"];

	if (!(_ix isEqualTo []) && {!(typeOf (_ix # 0 # 2) in GVAR(objectClassBlacklist))}) then {
		_height = _x;
		_noIntersectCount = 0;
	} else {
		_noIntersectCount = _noIntersectCount + 1;
	};

	if (_noIntersectCount >= 5) exitWith {};
} forEach CLIMB_HEIGHTS;

// Stop if no obstacle or too tall
if (_height isEqualTo 0 || _height > GVAR(maxClimbHeight)) exitWith {[false,false,_height]};

// Weight check
private _weight = _unit call FUNC(getWeight);
private _overweight = switch true do {
	case (_height >= 1) : {_weight > linearConversion [1,2,_height,GVAR(maxWeightClimb1),GVAR(maxWeightClimb2)]};
	case (_height >= 2) : {_weight > linearConversion [2,3,_height,GVAR(maxWeightClimb2),GVAR(maxWeightClimb3)]};
	default {false};
};

if (GVAR(enableWeightCheck) && _overweight) exitWith {
	hint "CAN'T CLIMB: OVERWEIGHT";
	[false,false,_height]
};

// Ceiling check
if !(lineIntersectsSurfaces [_pos,_pos vectorAdd [0,0,_height + 0.2],_unit,objNull,true,-1,"GEOM","NONE"] isEqualTo []) exitWith {[false,false,_height]};

private _hiPos = +_pos;
private _loPos = +_pos;
_hiPos set [2,_hiPos # 2 + _height + 0.6];
_loPos set [2,_loPos # 2 + 0.6];

// See if it's possible to climb onto the obstacle
private _climbOn = {
	private _beg = _hiPos vectorAdd (_dir vectorMultiply _x);
	private _end = _loPos vectorAdd (_dir vectorMultiply _x);

	if (GVAR(debug)) then {
		[{drawLine3D _this},{},[ASLToATL _beg,ASLToATL _end,[0,1,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	};

	!(lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"] isEqualTo [])
} count [1.8,1.5,1.2] isEqualTo 3;

// Final size checks
private _canClimb = if (_climbOn) then {
	private _checkBeg = (_pos vectorAdd [-0.3 * (_dir # 1),-0.3 * -(_dir # 0),_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _checkEnd = (_pos vectorAdd [0.35 * (_dir # 1),0.35 * -(_dir # 0),_height + 1.7]) vectorAdd (_dir vectorMultiply 1.4);
	
	if (GVAR(debug)) then {
		[{drawLine3D _this},{},[ASLToATL _checkBeg,ASLToATL _checkEnd,[1,0,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	};

	lineIntersectsSurfaces [_checkBeg,_checkEnd,_unit,objNull,true,-1,"GEOM","NONE"] isEqualTo []
} else {
	private _checkBeg = (_pos vectorAdd [-0.3 * (_dir # 1),-0.3 * -(_dir # 0),_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _checkEnd = (_pos vectorAdd [0.35 * (_dir # 1),0.35 * -(_dir # 0),_height + 0.7]) vectorAdd (_dir vectorMultiply 1.4);
	
	if (GVAR(debug)) then {
		[{drawLine3D _this},{},[ASLToATL _checkBeg,ASLToATL _checkEnd,[1,0,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	};

	lineIntersectsSurfaces [_checkBeg,_checkEnd,_unit,objNull,true,-1,"GEOM","NONE"] isEqualTo []
};

[_canClimb,_climbOn,_height]
