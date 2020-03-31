#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (
	!alive _unit || 
	{!(_unit in _unit)} || 
	{stance _unit == "PRONE"} ||
	{((animationState _unit) select [1,3]) in ["bdv","bsw","dve","sdv","ssw","swm"]}
) exitWith {false};

private _animPosASL = getPosASLVisual _unit;
private _targetPosASL = +_animPosASL;
private _dir = vectorDirVisual _unit;
private _duty = 0;
private _actionAnim = "";

// Climb/drop detection
_unit call FUNC(canClimb) params ["_canClimb","_climbOn","_height"];
_unit call FUNC(canDrop) params ["_canDrop","_depth","_highEdge"];

if (_canClimb) then {
	if (_climbOn) then {
		_animPosASL = (_animPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 0.9);
		_targetPosASL = (_targetPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 1.3);
		_duty = _height * 3.3 * load _unit;
		_actionAnim = switch true do {
			case (_height >= 1.8) : {"BABE_climbOnHer"};
			case (_height >= 1.6) : {"BABE_climbOnH"};
			case (_height >= 0.8) : {"BABE_climbOn"};
			case (_height >= 0) : {"BABE_stepOn"};
			default {""};
		};
	} else {
		_animPosASL = (_animPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 0.8);
		_targetPosASL = _targetPosASL vectorAdd (_dir vectorMultiply 2);
		_duty = _height * 3 * load _unit;
		_actionAnim = switch true do {
			case (_height >= 2.2) : {"BABE_climbOverHer"};
			case (_height >= 1.2) : {"BABE_climbOverH"};
			case (_height >= 1) : {"BABE_climbOver"};
			case (_height >= 0.8) : {"BABE_vaultover"};
			default {""};
		};
	};
};

if (!_canClimb && _canDrop) then {
	_animPosASL = (_animPosASL vectorAdd [0,0,-2.1]) vectorAdd (_dir vectorMultiply 0.8);
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_depth]) vectorAdd (_dir vectorMultiply 1.3);
	_duty = _depth * -0.8 * load _unit;
	_actionAnim = "BABE_drop";
};

// Stop if can't climb or drop (+ Prevent high edge vault)
if (_actionAnim == "") exitWith {_highEdge && GVAR(preventHighVaulting)};

// Stop if out of stamina
if (_unit call FUNC(getStamina) < _duty) exitWith {
	hint "CAN'T CLIMB: NOT ENOUGH STAMINA";
	false
};

// Determine animation types
private _prepAnim = "";
_actionAnim = _actionAnim + (switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {
		if (weaponLowered _unit) then {_prepAnim = "AmovPercMstpSrasWrflDnon";};
		"_rfl"
	};
	case (secondaryWeapon _unit) : {
		_prepAnim = "AmovPercMstpSnonWnonDnon";
		"_ua"
	};
	case (handgunWeapon _unit) : {
		if (weaponLowered _unit) then {_prepAnim = "AmovPercMstpSrasWpstDnon";};
		"_pst"
	};
	default {"_ua"};
});

// Start 'climbing'
_unit setVariable [QGVAR(isClimbing),true];

[_unit,"AnimDone",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_targetPosASL"];

	if !(_unit getVariable [QGVAR(isClimbing),false]) exitWith {
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),nil];
		_unit setAnimSpeedCoef 1;
	};

	if (_animation == _actionAnim) then {
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),nil];
		_unit setPosASL _targetPosASL;
		_unit setAnimSpeedCoef 1;
	};
},[_actionAnim,_targetPosASL]] call CBA_fnc_addBISEventHandler;

[_unit,"AnimChanged",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_animPosASL","_canClimb"];

	if (_animation == _actionAnim) then {
		_unit removeEventHandler [_thisType,_thisID];

		if (
			_canClimb && {!((_unit call FUNC(canClimb)) # 0)} ||
			!_canClimb && {!((_unit call FUNC(canDrop)) # 0)}
		) exitWith {
			_unit switchMove "";
			_unit setVariable [QGVAR(isClimbing),nil];
		};

		_unit setAnimSpeedCoef (1 - (load _unit) * 0.3);
		[{(_this # 0) setPosASL (_this # 1)},[_unit,_animPosASL]] call CBA_fnc_execNextFrame;
		[{
			_this setVelocity [0,0,0];
			!alive _this || !(_this getVariable [QGVAR(isClimbing),false])
		},{},_unit,10,{
			_this setVariable [QGVAR(isClimbing),nil];
			_this setAnimSpeedCoef 1;
		}] call CBA_fnc_waitUntilAndExecute;
	};
},[_actionAnim,_animPosASL,_canClimb]] call CBA_fnc_addBISEventHandler;

if (!isTouchingGround _unit) then {
	_unit switchAction "";

	if (_prepAnim != "") then {
		_unit switchMove _prepAnim;
	};	
} else {
	if (stance _unit != "STAND") then {
		_unit switchAction "PlayerStand";
	};

	if (_prepAnim != "") then {
		_unit playMove _prepAnim;
	};	
};

_unit playMove _actionAnim;
[_unit,-(_duty * GVAR(staminaCoefficient))] call FUNC(setStamina);

true
