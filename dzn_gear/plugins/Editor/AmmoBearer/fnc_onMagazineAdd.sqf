#include "defines.h"
#define DBG_FUNC_PREFIX "onMagazineAdd"

params ["_dialogCOB", "_count"];
DBG_1("Invoked. _count=%1", _count);
private _magClass = (_dialogCOB call ["GetValueByTag", "d_maglist"]) # 2;
_self call [F(addMagazine), [_magClass, _count]];
_self set [Q(CurrentSelectedMagazine), _magClass];

// -- Update UI
_self call [F(render), [_dialogCOB]];
