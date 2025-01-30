#include "defines.h"
#define DBG_FUNC_PREFIX "onWeaponSelected"

params ["_dialogCOB", "_weaponId"];
DBG_ "Invoked. _weaponId=%1", _weaponId EOL;

// -- Update state
private _mode = _self getOrDefault [Q(CurrentMode), [false, false]];
_mode set [_weaponId, !(_mode # _weaponId)];
DBG_ " Mode after = %1", _mode EOL;

private _currentDropdwonItem = "";
private _lbCtrl = _dialogCOB call ["GetByTag", "d_maglist"];
private _lbCurSel = lbCurSel _lbCtrl;

if (_lbCurSel > -1 && (_lbCtrl getVariable Q(listValues)) isNotEqualTo []) then {
	DBG_ "listValues = %1", _lbCtrl getVariable Q(listValues) EOL;
	DBG_ "_lbCurSel = %1", _lbCurSel EOL;
	_currentDropdwonItem = (_lbCtrl getVariable Q(listValues)) select _lbCurSel;
};

_self set [Q(CurrentSelectedMagazine), _currentDropdwonItem];
DBG_ "_currentDropdwonItem = %1", _currentDropdwonItem EOL;

// -- Update UI
_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
_self call [F(renderMagazinesListDropdown), [_dialogCOB]];