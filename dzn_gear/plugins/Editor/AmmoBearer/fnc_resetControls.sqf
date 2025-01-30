#include "defines.h"
#define DBG_FUNC_PREFIX "resetControls"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;

_self set [Q(CurrentWeapons), []];
_self set [Q(CurrentWeaponsMags), []];
{
	private _btn = _dialogCOB call ["GetByTag", _x];
	_btn ctrlSetText "";
	_btn ctrlSetTooltip "";
	_btn ctrlSetBackgroundColor [0,0,0,1];
} forEach ["btn_primary", "btn_launcher"];

private _magazinesListCtrl = _dialogCOB call ["GetByTag", "d_maglist"];
lbClear _magazinesListCtrl;
_magazinesListCtrl lbSetCurSel -1;
_magazinesListCtrl setVariable [Q(listValues), []];
	