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

DBG_ "Params: %1", _this EOL;

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
    DBG_
        "(%5) On Left Tab content selected: Category: %1, SubCategory: %2, Item Left: %3, Item Right: %4",
        _self get Q(CurrentCategory),
        _self get Q(CurrentSubCategory),
        _self get Q(CurrentSelectedLeftItem),
        _self get Q(CurrentSelectedRightItem),
        diag_frameNo
    EOL;
} else {
    _updateUI = !(_self get Q(SkipSelChangeEvent));

    _self set [Q(CurrentSubCategory), ace_arsenal_currentRightPanel];
    _self set [Q(CurrentSelectedRightItem), _ctrl lbData _idx];

    DBG_
        "(%5) On Right Tab content selected: Category: %1, SubCategory: %2, Item Left: %3, Item Right: %4",
        _self get Q(CurrentCategory),
        _self get Q(CurrentSubCategory),
        _self get Q(CurrentSelectedLeftItem),
        _self get Q(CurrentSelectedRightItem),
        diag_frameNo
    EOL;
};

if (!_updateUI || _oldCategory == 0) exitWith {};

private _newCategory = _self get Q(CurrentCategory);
private _newSubCategory = _self get Q(CurrentSubCategory);
private _newLeftItem = _self get Q(CurrentSelectedLeftItem);
private _newRightItem = _self get Q(CurrentSelectedRightItem);

DBG_ "Updating UI" EOL;

DBG_ "(%1) Old Category: %2, New: %3", diag_frameNo, _currentCategory, _newCategory EOL;
DBG_ "(%1) Old SubCategory: %2, New: %3", diag_frameNo, _currentSubCategory, _newSubCategory EOL;
DBG_ "(%1) Old Left item: %2, New: %3", diag_frameNo, _currentLeftItem, _newLeftItem EOL;
DBG_ "(%1) Old Right item: %2, New: %3", diag_frameNo, _currentRightItem, _newRightItem EOL;

// -- Update UI on tab switch
private _display = _self get Q(Display);

// -- Hide right buttons for some categories
private _showRightButtons = ((_self get Q(CurrentCategory)) in CATS_WITH_SUBCAT);//  && (_self get Q(CurrentSubCategory)) != 0;
["MODIFY", _display, "btnSub*", [["show", _showRightButtons]]] call dzn_fnc_HandleControl;

// -- Update opened tab category
if (isNil "dzn_AdvDialog2") exitWith {
    DBG_ "No dzn_AdvDialog2 initialized - exit" EOL;
    false
};

DBG_ "Current menu opened: %1", dzn_AdvDialog2 get Q(DialogID) EOL;
private _dialogID = dzn_AdvDialog2 get Q(DialogID);

// No dialog opened
if (_dialogID == "") exitWith {
    DBG_ "No opened dialog - exit" EOL;
    false
};

if (_dialogID == DIALOG_ID_ITEM_POOL) exitWith {
    DBG_ "Category menu opened. Checking for update case" EOL;
    if (_currentCategory != _newCategory) exitWith {
        DBG_ "Update category opened menu!" EOL;
        _self call [F(onShowButtonClick),[true]];
    };
};

// -- If RIGHT menu opened
if (_dialogID == DIALOG_ID_SUBCAT_ITEM_POOL) exitWith {
    DBG_ "Subcategory menu opened. Checking for update case" EOL;

    // -- Left menu tab changed -- close current right menu
    if (_currentCategory != _newCategory) exitWith {
        DBG_ "Close RIGHT menu!" EOL;
        dzn_AdvDialog2 call ["Close", []];
    };

    // -- Left item changed -- reset and close
    if (_currentLeftItem != _newLeftItem) exitWith {
        DBG_ "Reset RIGHT item pool!" EOL;
        _self get Q(ItemPools) set [_currentCategory * _currentSubCategory, []];
        dzn_AdvDialog2 call ["Close", []];
    };

    // -- Right menu tab changed - updated
    if (_currentSubCategory != _newSubCategory) exitWith {
        DBG_ "Update subcategory opened menu!" EOL;
        _self call [F(onShowButtonClick),[false]];
    };
};
