#include "defines.h"
#define DBG_FUNC_PREFIX "onClear"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;

_self call [F(clear), []];
// -- Update UI
_self call [F(render), [_dialogCOB]];