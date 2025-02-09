#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_isMainCategory"];
private _category = _self get Q(CurrentCategory);
if (!_isMainCategory) then {
    _category = _category * (_self get Q(CurrentSubCategory));
};

DBG_ "Cat: %1, Subcat: %2", _self get Q(CurrentCategory), _self get Q(CurrentSubCategory) EOL;
_self get Q(ItemPools) set [_category, []];

if (dzn_AdvDialog2 get Q(DialogID) in [DIALOG_ID_ITEM_POOL, DIALOG_ID_SUBCAT_ITEM_POOL]) then {
    DBG_ "Display is opened - closig: %1" EOL;
    dzn_AdvDialog2 call ["Close", []];
};
