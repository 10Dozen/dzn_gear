#include "defines.h"
#define DBG_FUNC_PREFIX "onShow"

DBG_ "Invoked" EOL;

params ["_dialogCOB"];

(_dialogCOB call ["GetValueByTag", "d_entities"]) params ["","","_content"];
(_dialogCOB call ["GetByTag", "ia_content"]) ctrlSetText _content;