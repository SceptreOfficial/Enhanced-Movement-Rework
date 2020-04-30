#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define CLIMB_HEIGHTS [0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2,2.2,2.4,2.6,2.8,3,3.2]

#define UNIVERSAL_EXIT_CONDITION \
	!alive _unit || \
	{!(_unit in _unit)} || \
	{stance _unit == "PRONE"} || \
	{((animationState _unit) select [1,3]) in ["bdv","bsw","dve","sdv","ssw","swm","inv"]} || \
	{_player call _x} count GVAR(actionExitConditions) != 0

#define CLIMB_ON_PROCEDURE \
	_animPosASL = (_animPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 0.9); \
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 1.2); \
	_duty = _height * GVAR(climbOnDuty) * load _unit; \
	_actionAnim = switch true do { \
		case (_height >= 1.8) : {"BABE_climbOnHer"}; \
		case (_height >= 1.6) : {"BABE_climbOnH"}; \
		case (_height >= 0.8) : {"BABE_climbOn"}; \
		case (_height >= 0) : {"BABE_stepOn"}; \
		default {""}; \
	}

#define CLIMB_OVER_PROCEDURE \
	_animPosASL = (_animPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 0.8); \
	_targetPosASL = _targetPosASL vectorAdd (_dir vectorMultiply 2); \
	_duty = _height * GVAR(climbOverDuty) * load _unit; \
	_actionAnim = switch true do { \
		case (_height >= 2.2) : {"BABE_climbOverHer"}; \
		case (_height >= 1.4) : {"BABE_climbOverH"}; \
		case (_height >= 1.2) : {"BABE_climbOver"}; \
		case (_height >= 0.6) : {"BABE_vaultover"}; \
		default {""}; \
	}

#define DROP_PROCEDURE \
	_animPosASL = (_animPosASL vectorAdd [0,0,-2.1]) vectorAdd (_dir vectorMultiply 0.8); \
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_depth]) vectorAdd (_dir vectorMultiply 1.3); \
	_duty = -_depth * GVAR(dropDuty) * load _unit; \
	_actionAnim = "BABE_drop"

