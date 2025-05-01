#include "defines.h"

params ["_isMainCategory"];

DBG_1("Params: %1", _isMainCategory);

private _category = _self get Q(CurrentCategory);
private _classname = _self get Q(CurrentSelectedLeftItem);
if (!_isMainCategory) then {
    _category = _category * (_self get Q(CurrentSubCategory));
    _classname = _self get Q(CurrentSelectedRightItem);
};

DBG_2("Category=%1, Adding item: %2", _category, _classname);

if (_category in CAT_WEAPONS) then {
    _self call [F(addWeaponItemToPool), [_category]];
} else {
    _self call [F(addItemToPool), [_category, _classname]];
};

_self call [F(onShowButtonClick), [_isMainCategory]];
