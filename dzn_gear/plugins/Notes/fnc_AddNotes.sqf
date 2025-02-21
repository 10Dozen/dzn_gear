#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [];

private _output = _self call [F(getTotals), [player]];

player createDiaryRecord ["Diary", [_self get Q(Settings) get "Personal" get "title", _output]];
