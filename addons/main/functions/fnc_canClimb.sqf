#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Checks if a unit can climb on or over an object

	Returns:
	0: Can climb <BOOL>
	1: false to climb over, true to climb on top <BOOL>
	2: Climb height <SCALAR>
	3: Target height <SCALAR>
	4: Animation position ASL <ARRAY>
	5: Assistant <OBJECT>
*/

params [["_unit",objNull,[objNull]]];

if (!GVAR(allowMidairClimbing) && !isTouchingGround _unit) exitWith {[false,false,0,0,[0,0,0],objNull]};

private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;

// offset pos to line up with view
_pos = _pos vectorAdd (([_dir] matrixMultiply GVAR(rotVect90) select 0) vectorMultiply 0.1);

private _animPosASL = +_pos;
private _height = 0;
private _targetHeight = 0;
private _endVect = (_dir vectorMultiply 1.2) vectorAdd [0,0,0.05];
private _noIntersectCount = 0;
private _obstacle = objNull;

// Obstacle detection
for "_x" from 0.3 to (GVAR(maxClimbHeight) + 0.1) step 0.1 do {
	private _beg = _pos vectorAdd [0,0,_x];
	private _end = _beg vectorAdd _endVect;
	private _ix = lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"];

	if (_ix isEqualTo []) then {
		DEBUG_G(_beg,_end)
		_noIntersectCount = _noIntersectCount + 1;
	} else {
		private _model = toLower ((getModelInfo (_ix # 0 # 2)) # 0);

		if (!(_model in GVAR(whitelist)) && _model in GVAR(blacklist)) exitWith {DEBUG_R(_beg,_end)};
		DEBUG_B(_beg,_end)

		_animPosASL = _ix # 0 # 0;
		_height = _x;
		_noIntersectCount = 0;
		_obstacle = _ix # 0 # 2;
	};
	
	if (_height > 0 && _noIntersectCount >= 8) exitWith {};
};

private _assistant = objNull;

// Check for assistance
if (_height > GVAR(maxClimbHeight)) then {
	if (GVAR(assistHeight) isEqualTo 0) exitWith {};

	private _posZ = _pos # 2;
	private _assistance = (_unit nearEntities ["CAManBase",GVAR(maxClimbHeight) + GVAR(assistHeight) + 0.3]) select {
		_x getVariable [QGVAR(isAssisting),false] &&
		getPosASLVisual _x # 2 - _posZ > GVAR(maxClimbHeight) &&
		_x distance2D _unit < 2.1
	};

	if (_assistance isEqualTo []) exitWith {};

	_assistant = _assistance # 0;
	private _pos = getPosASLVisual _assistant;
	private _dir = _pos getDir getPosASLVisual _unit;
	private _vectorDir = [sin _dir,cos _dir,0];

	_animPosASL = _pos vectorAdd (_vectorDir vectorMultiply (((_assistant distance2D _unit) * 0.5) min 1));
	_height = _pos # 2 - _posZ;

	DEBUG_R(_pos,_animPosASL);
};

// Stop if no obstacle or too tall
if (_height isEqualTo 0 || (_height > GVAR(maxClimbHeight) && isNull _assistant)) exitWith {[false,false,_height,_targetHeight,_animPosASL,_assistant]};

// Weight check
private _weight = _unit call FUNC(getWeight);
private _overweight = switch true do {
	case (_height >= 1) : {_weight > linearConversion [1,2,_height,GVAR(maxWeightClimb1),GVAR(maxWeightClimb2)]};
	case (_height >= 2) : {_weight > linearConversion [2,3,_height,GVAR(maxWeightClimb2),GVAR(maxWeightClimb3)]};
	default {false};
};

if (GVAR(enableWeightCheck) && _overweight) exitWith {
	if (IS_PLAYER(_unit)) then {LLSTRING(CantClimbOverweight) call FUNC(hint)};
	[false,false,_height,_targetHeight,_animPosASL,_assistant]
};

// Exit here if there is assistance
if (alive _assistant) exitWith {[true,true,_height,_targetHeight,_animPosASL,_assistant]};

// Ceiling check
private _ceilBeg = _pos vectorAdd [0,0,_height - 0.1 max 0.3];
private _ceilEnd = _pos vectorAdd [0,0,_height + 0.5];
if (lineIntersectsSurfaces [_ceilBeg,_ceilEnd,_unit,objNull,true,-1,"GEOM","NONE"] isNotEqualTo []) exitWith {
	DEBUG_R(_ceilBeg,_ceilEnd)
	[false,false,_height,_targetHeight,_animPosASL,objNull]
};

DEBUG_B(_ceilBeg,_ceilEnd)

// See if it's possible to climb onto the obstacle
private _climbOnBeg = _pos vectorAdd [0,0,_height + 0.6];
private _climbOnEnd = _pos vectorAdd [0,0,_height - 0.6 max 0.3];
private _exit = false;
private _climbOn = false;

if (_obstacle isKindOf "CAManBase") then {
	// Climbing should only happen if unit is kneeling/prone or if standing is allowed via settings
	if (stance _obstacle isNotEqualTo "STAND" || GVAR(allowClimbOnStandingUnits)) then {
		_climbOn = true;
	} else {
		_exit = true;
	};
} else {
	_climbOn = {
		private _beg = _climbOnBeg vectorAdd (_dir vectorMultiply _x);
		private _end = _climbOnEnd vectorAdd (_dir vectorMultiply _x);

		if (lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"] isEqualTo []) then {
			DEBUG_G(_beg,_end)
			false
		} else {
			DEBUG_B(_beg,_end)
			true
		};
	} count [1.725,1.4625,1.2] isEqualTo 3
};

if (_exit) exitWith {[false,false,_height,_targetHeight,_animPosASL,objNull]};

// Climb on size checks
private _dX = 0.25 * -(_dir # 0);
private _dY = 0.25 * (_dir # 1);
private _canClimb = false;

if (_climbOn) then {
	private _beg1 = (_pos vectorAdd [-_dY,-_dX,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _end1 = (_pos vectorAdd [-_dY,-_dX,_height + 1.7]) vectorAdd (_dir vectorMultiply 1.4);
	private _beg2 = (_pos vectorAdd [_dY,_dX,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _end2 = (_pos vectorAdd [_dY,_dX,_height + 1.7]) vectorAdd (_dir vectorMultiply 1.4);

	if ((
		lineIntersectsSurfaces [_beg1,_end1,_unit,objNull,true,-1,"GEOM","NONE"] + 
		lineIntersectsSurfaces [_beg2,_end2,_unit,objNull,true,-1,"GEOM","NONE"]
	) isEqualTo []) then {
		DEBUG_B(_beg1,_end1)
		DEBUG_B(_beg2,_end2)
		_canClimb = true;
	} else {
		DEBUG_R(_beg1,_end1)
		DEBUG_R(_beg2,_end2)
		_canClimb = false;
	};
};

// Climb over size checks 
if (!_canClimb) then {
	private _beg1 = (_pos vectorAdd [-_dY,-_dX,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _end1 = (_pos vectorAdd [-_dY,-_dX,_height + 0.7]) vectorAdd (_dir vectorMultiply 1.8);
	private _beg2 = (_pos vectorAdd [_dY,_dX,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _end2 = (_pos vectorAdd [_dY,_dX,_height + 0.7]) vectorAdd (_dir vectorMultiply 1.8);

	if ((
		lineIntersectsSurfaces [_beg1,_end1,_unit,objNull,true,-1,"GEOM","NONE"] + 
		lineIntersectsSurfaces [_beg2,_end2,_unit,objNull,true,-1,"GEOM","NONE"]
	) isEqualTo []) then {
		DEBUG_B(_beg1,_end1)
		DEBUG_B(_beg2,_end2)
		_canClimb = true;

		// Account for objects on the other side of a wall
		private _targetEnd = _pos vectorAdd (_dir vectorMultiply 1.8);
		private _targetBeg = _targetEnd vectorAdd [0,0,_height + 0.6];
		private _ix = lineIntersectsSurfaces [_targetBeg,_targetEnd,_unit,objNull,true,-1,"GEOM","NONE"];

		if (_ix isNotEqualTo []) then {
			_targetHeight = (_ix # 0 # 0 # 2) - (_pos # 2);
		};
		
		DEBUG_B(_targetBeg,_targetEnd)
	} else {
		DEBUG_R(_beg1,_end1)
		DEBUG_R(_beg2,_end2)
		_canClimb = false;
	};
};

[_canClimb,_climbOn,_height,_targetHeight,_animPosASL,objNull]
