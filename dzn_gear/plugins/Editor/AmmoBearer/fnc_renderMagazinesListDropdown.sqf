#include "defines.h"
#define DBG_FUNC_PREFIX "renderMagazinesListDropdown"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;
(_self get Q(CurrentMode)) params ["_addPrimaryMags", "_addLauncherMags"];
(_self get Q(CurrentWeapons)) params ["_primary", "_launcher"];
(_self get Q(CurrentWeaponsMags)) params ["_primaryPreferredMag", "_launcherPreferredMag"];

private _selectedMags = keys (_self get Q(CurrentMagPool));
DBG_ "Prefered mags=%1", (_self get Q(CurrentWeaponsMags)) EOL;

private _allMags = _selectedMags;
if (_addPrimaryMags) then {
	private _primaryMags = (compatibleMagazines _primary) - [_primaryPreferredMag] - _selectedMags;
	if (_primaryPreferredMag isNotEqualTo "" && !(_primaryPreferredMag in _selectedMags)) then {
		_allMags pushBack _primaryPreferredMag;
	};
	_allMags append _primaryMags;
};
if (_addLauncherMags) then {
	private _launcherMags = (compatibleMagazines _launcher) - [_launcherPreferredMag] - _selectedMags;;
	if (_launcherPreferredMag isNotEqualTo "" && !(_launcherPreferredMag in _selectedMags)) then {
		_allMags pushBack _launcherPreferredMag;
	};
	_allMags append _launcherMags;
};

DBG_ "_allMags=%1", _allMags EOL;

private _currentSelectedMags = _self get Q(CurrentMagPool);
private _ctrl = _dialogCOB call ["GetByTag", "d_maglist"];

private _currentSelectedItem = _self get Q(CurrentSelectedMagazine);
/*if (lbCurSel _ctrl > -1 && (_ctrl getVariable Q(listValues)) isNotEqualTo []) then {
	_currentSelectedItem = (_ctrl getVariable Q(listValues)) select (lbCurSel _ctrl);
};
*/
DBG_ "_currentSelectedItem: %1", _currentSelectedItem EOL;
lbClear _ctrl;
{
	private _count = _currentSelectedMags getOrDefault [_x, 0];
	DBG_ "_x: %1, _count: %2", _x, _count EOL;

	_ctrl lbAdd format [
		"%1%2",
		getText(configFile >> "CfgMagazines" >> _x >> "displayName"),
		[format [" x%1", _count], ""] select (_count == 0)
	];
	_ctrl lbSetTooltip [_forEachIndex, _x];
	_ctrl lbSetPicture [
		_forEachIndex,
		getText(configFile >> "CfgMagazines" >> _x >> "picture")
	];
	_ctrl lbSetColor [
		_forEachIndex,
		[
			COLOR_DARK_GREEN,
			[
				COLOR_WHITE, COLOR_GOLD
			] select (_x in (_self get Q(CurrentWeaponsMags)))
		] select (_count == 0)
	];
	if (_x isEqualTo _currentSelectedItem) then {

		DBG_ "%3) _x vs _currentSelectedItem = %1 vs %2", _x, _currentSelectedItem, _forEachIndex EOL;
		_ctrl lbSetCurSel _forEachIndex;
	};
} forEach _allMags;

// Update data for dialogCOB
_ctrl setVariable [Q(listValues), _allMags];