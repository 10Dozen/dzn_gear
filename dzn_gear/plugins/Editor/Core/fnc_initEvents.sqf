#include "defines.h"





// -- Arsenal events
dzn_gear_ArsenalComponent call [F(initEvents)];


["loadout", {
	ThisCOB call [F(ShowTotals), [ThisCOB get Q(TotalsTargetDisplay)]];
}, true] call CBA_fnc_addPlayerEventHandler;