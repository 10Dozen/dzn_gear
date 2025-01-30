#include "defines.h"
#define DBG_FUNC_PREFIX "onMagazineRemove"

params ["_dialogCOB", "_count"];
DBG_ "Invoked. _count=%1", _count EOL;
private _magClass = (_dialogCOB call ["GetValueByTag", "d_maglist"]) # 2;
_self call [F(removeMagazine), [_magClass, _count]];
_self set [Q(CurrentSelectedMagazine), _magClass];

// -- Update UI
_self call [F(render), [_dialogCOB]];