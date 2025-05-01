#include "defines.h"
#define DBG_FUNC_PREFIX "setFilters"

DBG_1("Invoked. Params: %1", _this);
params ["_personal", "_cargo", "_composed"];

private _filters = _self get Q(Filters);
_filters set [HISTORY_PERSONAL_KIT /*"PERSONAL_KIT"*/, _personal];
_filters set [HISTORY_CARGO_KIT /*"CARGO_KIT"*/, _cargo];
_filters set [HISTORY_COMPOSED/*"COMPOSED"*/, _composed];

DBG_1("Filters after: %1", _self get Q(Filters));
