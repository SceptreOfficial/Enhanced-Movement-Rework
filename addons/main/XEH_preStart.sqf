#include "script_component.hpp"
#include "XEH_PREP.hpp"

private _blacklist = [];

{
	if (isNumber (_x >> "EMR_blacklist") && {getNumber (_x >> "EMR_blacklist") > 0}) then {
		private _model = getText (_x >> "model");

		if (_model isEqualTo "") exitWith {};
			
		private _index = (reverse _model) find "\";
		
		if (_index > -1) then {
			_model = _model select [count _model - _index,_index];
		};
		
		_blacklist pushBackUnique toLower _model;
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x",false];

uiNamespace setVariable [QGVAR(preStartBlacklist),_blacklist];
