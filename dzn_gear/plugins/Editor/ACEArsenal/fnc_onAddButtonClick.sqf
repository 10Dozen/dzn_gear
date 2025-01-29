#include "defines.h"

#define DBG_FUNC_PREFIX "onAddButtonClick"

params [];
private _category = _self get Q(CurrentItemPoolId);
private _classname = _self get Q(CurrentItemSelected);

DBG_ "Adding item: %1", _classname EOL;

_self call [F(addItemToPool), [_category, _classname]];
_self call [F(onShowButtonClick)];