#include "defines.h"

params ["_isMainCategory"];

private _category = _self get Q(CurrentCategory);
private _classname = _self get Q(CurrentItemSelected);
if (!_isMainCategory) then {
    _category = _category * (_self get Q(CurrentSubCategory));
    _classname = _self get Q(CurrentSelectedRightItem);
};

forceUnicode 1;
copyToClipboard str(_self get Q(ItemPools) getOrDefault [_category, []]);
forceUnicode -1;