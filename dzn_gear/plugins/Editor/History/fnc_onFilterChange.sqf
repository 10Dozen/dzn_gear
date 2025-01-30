#include "defines.h"
#define DBG_FUNC_PREFIX "onFilterChange"

DBG_ "Invoked" EOL;
params ["_dialogCOB"];
private _allVals = _dialogCOB call ["GetTaggedValues"];
_self call [F(setFilters), [
	_allVals get "cb_personalKit",
	_allVals get "cb_cargoKit",
	_allVals get "cb_composed"
]];

// -- Update UI
_self call [F(renderEntitiesList), [_dialogCOB]];