#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = CSTRING(EnhancedMovementRework);
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Enhanced-Movement-Rework";
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
			"A3_Anims_F",
			"cba_common",
			"cba_events",
			"cba_keybinding",
			"cba_main",
			"cba_settings",
			"cba_xeh",
			"BaBe_core",
			"babe_core_UI",
			"BABE_CORE_FNC",
			"BaBe_EM",
			"BABE_EM_FNC",
			"babe_EM_UI",
			"babe_EM_gst",
			"BaBe_EM_Anims",
			"BaBe_int",
			"BABE_INT_FNC",
			"babe_int_EHs"
		};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
#include "EMDisable.hpp"
#include "keybinding.hpp"
