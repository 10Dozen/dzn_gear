#include "defines.h"
#define DBG_FUNC_PREFIX "onKitLoad"

params ["_dialogCOB"];
DBG("Invoked");
_self call [F(resetControls), [_dialogCOB]];

private _kitname = _dialogCOB call ["GetValueByTag", "i_kitname"];
_self call [F(loadKitData), [_kitname]];

// -- Update UI
_self call [F(render), [_dialogCOB]];
