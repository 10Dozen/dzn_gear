#include "defines.h"
#define DBG_FUNC_PREFIX "onWeaponSelected"

params ["_dialogCOB", "_weaponId"];
DBG_1("Invoked. _weaponId=%1", _weaponId);

// -- Update state
private _mode = _self getOrDefault [Q(CurrentMode), [false, false]];
_mode set [_weaponId, !(_mode # _weaponId)];
DBG_1(" Mode after = %1", _mode);

private _currentDropdwonItem = "";
private _lbCtrl = _dialogCOB call ["GetByTag", "d_maglist"];
private _lbCurSel = lbCurSel _lbCtrl;

if (_lbCurSel > -1 && (_lbCtrl getVariable Q(listValues)) isNotEqualTo []) then {
    DBG_1("listValues = %1", _lbCtrl getVariable Q(listValues));
    DBG_1("_lbCurSel = %1", _lbCurSel);
    _currentDropdwonItem = (_lbCtrl getVariable Q(listValues)) select _lbCurSel;
};

_self set [Q(CurrentSelectedMagazine), _currentDropdwonItem];
DBG_1("_currentDropdwonItem = %1", _currentDropdwonItem);

// -- Update UI
_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
_self call [F(renderMagazinesListDropdown), [_dialogCOB]];
