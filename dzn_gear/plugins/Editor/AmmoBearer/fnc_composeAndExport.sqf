#include "defines.h"
#define DBG_FUNC_PREFIX "addMagazine"

params [["_applyToPlayer", false, [false]]];
DBG_1("Invoked. Params: %1", _this);
private _data = (_self get Q(CurrentMagPool)) toArray false;

DBG_1("_data: %1", _data);
if (_applyToPlayer) then {
    DBG("Applying to player backpack");
    private _bp = backpackContainer player;
    { _bp addMagazineCargo _x; } forEach _data;
};

private _str = _data joinString ", ";
DBG_1("String : %1", _str);

forceUnicode 0;
copyToClipboard (_str);

ECOB(Editor,History) call [
    F(Add),
    [HISTORY_COMPOSED, "Ammo bearer composition", _str]
];
forceUnicode -1;

ECOB(Editor,Core) call [F(Notify), [NOTIF_BEARER_COPIED, NOTIF_BEARER_ADDED] select _applyToPlayer];
