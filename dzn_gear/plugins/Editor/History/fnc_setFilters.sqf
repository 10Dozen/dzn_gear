#include "defines.h"
#define DBG_FUNC_PREFIX "setFilters"


DBG_ "Invoked. Params: %1", _this EOL;
params ["_personal", "_cargo", "_composed"];

private _filters = _self get Q(Filters);
_filters set ["PERSONAL_KIT", _personal];
_filters set ["CARGO_KIT", _cargo];
_filters set ["COMPOSED", _composed];

DBG_ "Filters after: %1", _self get Q(Filters) EOL;