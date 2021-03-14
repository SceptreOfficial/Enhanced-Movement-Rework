#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Checks if a unit can drop from a ledge

	Returns:
	0: Can drop <BOOL>
	1: Drop depth <SCALAR>
	2: True if too high of a fall <BOOL>
*/

params ["_unit"];

if (!isTouchingGround _unit) exitWith {[false,0,false]};

private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;
private _heightAboveTerrain = getPosATL _unit # 2;

if (_heightAboveTerrain < 1) exitWith {[false,0,false]};

// Minimum required empty space
private _minBeg1 = _pos vectorAdd [0,0,0.4];
private _minEnd1 = (_pos vectorAdd [0,0,0.4]) vectorAdd (_dir vectorMultiply 1.2);
private _minBeg2 = (_pos vectorAdd [0,0,1.2]) vectorAdd (_dir vectorMultiply 1);
private _minEnd2 = (_pos vectorAdd [0,0,-1.2]) vectorAdd (_dir vectorMultiply 2);

if ((
	lineIntersectsSurfaces [_minBeg1,_minEnd1,_unit,objNull,true,-1,"GEOM","NONE"] + 
	lineIntersectsSurfaces [_minBeg2,_minEnd2,_unit,objNull,true,-1,"GEOM","NONE"]
) isNotEqualTo []) exitWith {
	DEBUG_R(_minBeg1,_minEnd1)
	DEBUG_R(_minBeg2,_minEnd2)
	[false,0,false]
};

DEBUG_B(_minBeg1,_minEnd1)
DEBUG_B(_minBeg2,_minEnd2)

// Depth detection
private _beg = (_pos vectorAdd [0,0,0.4]) vectorAdd (_dir vectorMultiply 1.3);
private _end = (_pos vectorAdd [0,0,-GVAR(maxDropHeight)]) vectorAdd (_dir vectorMultiply 1.3);
private _surfaces = lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"];

if (_surfaces isEqualTo []) exitWith {
	DEBUG_R(_beg,_end)
	[false,0,true]
};

DEBUG_B(_beg,_end)

[true,((_surfaces # 0 # 0 # 2) - (_pos # 2)) max -2.8,false]
