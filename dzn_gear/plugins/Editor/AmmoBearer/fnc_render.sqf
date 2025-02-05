#include "defines.h"
#define DBG_FUNC_PREFIX "render"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;

_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
_self call [F(renderMagazinesListDropdown), [_dialogCOB]];
_self call [F(renderMagazinesInfoLabels), [_dialogCOB]];
