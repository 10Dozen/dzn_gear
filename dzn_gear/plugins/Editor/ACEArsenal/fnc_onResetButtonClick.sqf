#include "defines.h"

DBG_1("Params: %1", _this);

params ["_isMainCategory"];
private _category = _self get Q(CurrentCategory);
if (!_isMainCategory) then {
    _category = _category * (_self get Q(CurrentSubCategory));
};

DBG_2("Cat: %1, Subcat: %2", _self get Q(CurrentCategory), _self get Q(CurrentSubCategory));
_self get Q(ItemPools) set [_category, []];

if (dzn_AdvDialog2 get Q(DialogID) in [DIALOG_ID_ITEM_POOL, DIALOG_ID_SUBCAT_ITEM_POOL]) then {
    DBG_1("Display is opened - closig: %1");
    dzn_AdvDialog2 call ["Close", []];
};
