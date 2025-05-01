#include "defines.h"


/*
    When LEFT opened:
        a) Left item changed - do nothing
        b) Left category changed - UPDATE
        c) Right item changed - do nothing
        d) Right category changed - do nothing

    When RIGHT opened:
        a) Left item changed - close menu
        b) Left category changed - close menu
        c) Right item changed - do nothing
        d) Right category changed - UPDATE

    Left item changed:
        _currentLeftItem !=
*/

DBG_1("Params: %1", _this);

params ["_isLeftTab", "_eventAttrs"];
_eventAttrs params ["_ctrl", "_idx"];
// -- IF _idx == -1 -> tab was switched and temporary no index was set
//    So we can HIDE currently opened menu and re-draw it on next event
//    If _idx > 1 and no event flag -- do not redraw menu!
if (_idx == -1) exitWith {
    _self set [Q(TabSwitched), true];
};

private _updateUI = true;
private _currentCategory = _self get Q(CurrentCategory);
private _currentSubCategory = _self get Q(CurrentSubCategory);
private _currentLeftItem = _self get Q(CurrentSelectedLeftItem);
private _currentRightItem = _self get Q(CurrentSelectedRightItem);

if (_isLeftTab) then {
    _self set [Q(CurrentCategory), ace_arsenal_currentLeftPanel];
    _self set [Q(CurrentSubCategory), 0];
    _self set [Q(CurrentSelectedLeftItem), _ctrl lbData _idx];
    _self set [Q(CurrentSelectedRightItem), ""];

    _self set [Q(SkipSelChangeEvent), true];
    [{ ThisCOB set [Q(SkipSelChangeEvent), false]; }] call CBA_fnc_execNextFrame;
} else {
    _updateUI = !(_self get Q(SkipSelChangeEvent));

    _self set [Q(CurrentSubCategory), ace_arsenal_currentRightPanel];
    _self set [Q(CurrentSelectedRightItem), _ctrl lbData _idx];
};

if (!_updateUI || _oldCategory == 0) exitWith {};

private _newCategory = _self get Q(CurrentCategory);
private _newSubCategory = _self get Q(CurrentSubCategory);
private _newLeftItem = _self get Q(CurrentSelectedLeftItem);
private _newRightItem = _self get Q(CurrentSelectedRightItem);

DBG("Updating UI");

DBG_3("(%1) Old Category: %2, New: %3", diag_frameNo, _currentCategory, _newCategory);
DBG_3("(%1) Old SubCategory: %2, New: %3", diag_frameNo, _currentSubCategory, _newSubCategory);
DBG_3("(%1) Old Left item: %2, New: %3", diag_frameNo, _currentLeftItem, _newLeftItem);
DBG_3("(%1) Old Right item: %2, New: %3", diag_frameNo, _currentRightItem, _newRightItem);

// -- Update UI on tab switch
private _display = _self get Q(Display);

// -- Hide right buttons for some categories
private _showRightButtons = ((_self get Q(CurrentCategory)) in CATS_WITH_SUBCAT);//  && (_self get Q(CurrentSubCategory)) != 0;
["MODIFY", _display, "btnSub*", [["show", _showRightButtons]]] call dzn_fnc_HandleControl;

// -- Update opened tab category
if (isNil "dzn_AdvDialog2") exitWith {
    DBG("No dzn_AdvDialog2 initialized - exit");
    false
};

DBG_1("Current menu opened: %1", dzn_AdvDialog2 get Q(DialogID));
private _dialogID = dzn_AdvDialog2 get Q(DialogID);

// No dialog opened
if (_dialogID == "") exitWith {
    DBG("No opened dialog - exit");
    false
};

if (_dialogID == DIALOG_ID_ITEM_POOL) exitWith {
    DBG("Category menu opened. Checking for update case");
    if (_currentCategory != _newCategory) exitWith {
        DBG("Update category opened menu!");
        _self call [F(onShowButtonClick),[true]];
    };
};

// -- If RIGHT menu opened
if (_dialogID == DIALOG_ID_SUBCAT_ITEM_POOL) exitWith {
    DBG("Subcategory menu opened. Checking for update case");

    // -- Left menu tab changed -- close current right menu
    if (_currentCategory != _newCategory) exitWith {
        DBG("Close RIGHT menu!");
        dzn_AdvDialog2 call ["Close", []];
    };

    // -- Left item changed -- reset and close
    if (_currentLeftItem != _newLeftItem) exitWith {
        DBG("Reset RIGHT item pool!");
        _self get Q(ItemPools) set [_currentCategory * _currentSubCategory, []];
        dzn_AdvDialog2 call ["Close", []];
    };

    // -- Right menu tab changed - updated
    if (_currentSubCategory != _newSubCategory) exitWith {
        DBG("Update subcategory opened menu!");
        _self call [F(onShowButtonClick),[false]];
    };
};
