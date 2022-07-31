class CfgFunctions {
	delete BABE_CORE;
	delete BABE_EM;
	delete BABE_INT;
};

class CfgModSettings {
	delete babe_EM;
};

class CBA_Extended_EventHandlers;
class CfgVehicles {
	class AllVehicles;
	class Air: AllVehicles {
		class EventHandlers {
			delete babe_int_initEH;
			class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
		};
	};

	class LandVehicle;
	class Car: LandVehicle {
		class EventHandlers {
			delete babe_int_initEH;
			class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
		};
	};
	class Tank: LandVehicle {
		class EventHandlers {
			delete babe_int_initEH;
			class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
		};
	};
};

delete BABE_core_List;
