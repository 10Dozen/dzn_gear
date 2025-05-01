#include "defines.h"
#define DBG_FUNC_PREFIX "render"

params ["_dialogCOB"];
DBG("Invoked");

_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
_self call [F(renderMagazinesListDropdown), [_dialogCOB]];
_self call [F(renderMagazinesInfoLabels), [_dialogCOB]];
