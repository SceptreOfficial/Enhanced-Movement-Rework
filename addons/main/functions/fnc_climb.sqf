#include "script_component.hpp"

params ["_unit"];

if (
	!alive _unit || 
	{!(_unit in _unit)} || 
	{((animationState _unit) select [1,3]) in ["bdv","bsw","dve","sdv","ssw","swm"]} || 
	{stance _unit != "STAND"}
) exitWith {false};

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

private _weaponType = switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {"_rfl"};
	case (handgunWeapon _unit) : {"_pst"};
	default {"_ua"};
};

_unit call FUNC(canDrop) params ["_canDrop","_depth"];

if (_canDrop) exitWith {
	private _actionAnim = "Babe_drop" + _weaponType;
	private _animPosASL = getPosASLVisual _unit;
	private _targetPosASL = +_animPosASL;
	private _dir = vectorDirVisual _unit;

	_animPosASL = (_animPosASL vectorAdd [0,0,-2]) vectorAdd (_dir vectorMultiply 1);
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_depth]) vectorAdd (_dir vectorMultiply 1.3);

	[_unit,"AnimChanged",{
		params ["_unit","_animation"];
		_thisArgs params ["_actionAnim","_animPosASL"];

		if (_animation == _actionAnim) then {
			_unit removeEventHandler [_thisType,_thisID];
			_unit setVariable [QGVAR(isClimbing),true];
			_unit setPosASL _animPosASL;
			
			[{
				if (!alive _this || !(_this getVariable [QGVAR(isClimbing),false])) then {
					true
				} else {
					_this setVelocity [0,0,0];
					false
				}
			},{},_unit,8,{
				_this setVariable [QGVAR(isClimbing),nil]
			}] call CBA_fnc_waitUntilAndExecute;
		};
	},[_actionAnim,_animPosASL]] call CBA_fnc_addBISEventHandler;

	[_unit,"AnimDone",{
		params ["_unit","_animation"];
		_thisArgs params ["_actionAnim","_targetPosASL"];

		if (_animation == _actionAnim) then {
			_unit removeEventHandler [_thisType,_thisID];
			_unit setVariable [QGVAR(isClimbing),nil];
			_unit setPosASL _targetPosASL;
		};
	},[_actionAnim,_targetPosASL]] call CBA_fnc_addBISEventHandler;

	_unit playMoveNow _actionAnim;

	true
};

_unit call FUNC(canClimb) params ["_canClimb","_climbOn","_height"];

if (!_canClimb) exitWith {false};

private _actionAnim = "";
private _animPosASL = getPosASLVisual _unit;
private _targetPosASL = +_animPosASL;
private _dir = vectorDirVisual _unit;

if (_climbOn) then {
	_animPosASL = (_animPosASL vectorAdd [0,0,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_height + 0.3]) vectorAdd (_dir vectorMultiply 1.3);
	_actionAnim = (switch ([0.7,1,1.3,1.6,1.9,2.2,2.5] find _height) do {
		case 0 : {"Babe_stepOn"};
		case 1;
		case 2 : {"BABE_climbOn"};
		case 3;
		case 4 : {"BABE_climbOnH"};
		case 5 : {"BABE_climbOnHer"};
	}) + _weaponType;
} else {
	_animPosASL = (_animPosASL vectorAdd [0,0,_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	_targetPosASL = _targetPosASL vectorAdd (_dir vectorMultiply 2);
	_actionAnim = (switch ([0.7,1,1.3,1.6,1.9,2.2,2.5] find _height) do {
		case 0;
		case 1 : {"Babe_vaultover"};
		case 2 : {"BABE_climbOver"};
		case 3 : {"BABE_climbOverH"};
		case 4;
		case 5 : {"BABE_climbOverHer"};
	}) + _weaponType;
};

[_unit,"AnimChanged",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_animPosASL"];

	if (_animation == _actionAnim) then {
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),true];
		_unit setPosASL _animPosASL;

		[{
			if (!alive _this || !(_this getVariable [QGVAR(isClimbing),false])) then {
				true
			} else {
				_this setVelocity [0,0,0];
				false
			}
		},{},_unit,8,{
			_this setVariable [QGVAR(isClimbing),nil]
		}] call CBA_fnc_waitUntilAndExecute;
	};
},[_actionAnim,_animPosASL]] call CBA_fnc_addBISEventHandler;

[_unit,"AnimDone",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_targetPosASL"];

	if (_animation == _actionAnim) then {
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),nil];
		_unit setPosASL _targetPosASL;
	};
},[_actionAnim,_targetPosASL]] call CBA_fnc_addBISEventHandler;

_unit playMoveNow _actionAnim;

true