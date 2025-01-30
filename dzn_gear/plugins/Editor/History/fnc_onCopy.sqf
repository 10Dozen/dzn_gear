#include "defines.h"
#define DBG_FUNC_PREFIX "onCopy"

DBG_ "Invoked" EOL;
params ["_dialogCOB"];
private _content = _dialogCOB call ["GetValueByTag", "ia_content"];

forceUnicode 1;
copyToClipboard _content;
forceUnicode -1;

["HISTORY_COPIED"] call dzn_fnc_gear_editMode_showNotif;