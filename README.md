# dzn_gear

- Allows to choose gear and create gear kit for infantry units
- Allows to create cargo gear kits for vehicles and ammoboxes
- Allows to use created kits to assign gear via: Synchronization with GameLogic or setVariable for unit

<h2>How To</h2>
Download files (except "shemes" folder - it's only shows structure of kits for design purposes) to your mission folder. If you already have "init.sqf", then update it with lines from downloaded "init.sqf". To use 'EDIT' mode use "true" as argument in line <tt>[true] execVM "dzn_gear_init.sqf";</tt>.
<h3>EDIT mode</h3>
<br>In 'EDIT' mode open mission in Editor and click "Preview": inside the mission you'll see a new actions at the action menu:
 <ul>
  <li><tt>Open Virtual Arsenal</tt> -- Simply opens VA with all available gear</li>
  <li><tt>Copy Current Gear to Clipboard</tt> -- Copy current gear to clipboard for inserting to <tt>dzn_gear_kit.sqf</tt> file</li>
  <li><tt>Copy and Assign Gear of Cursor Unit</tt> -- Shows up when you staring on infantryman, action will copy unit's gear to player and additionally copy kit to the clipboard</li>
  <li><tt>Copy Gear of Cursor Vehicle or Box</tt> -- Shows up when you staring on vehicle or ammobox, action will copy vehicle's cargo to the clipboard in vehicle kit's format</li>
  <li><tt>Kit with (mission time) (primary weapon classname)</tt> -- After any infanty's kit copied, new action will be added. On action - copied kit will be assigned to player.</li>
  <li><tt>Kit for Vehicle/Box (mission time)</tt> -- After any vehicle's kit copied, new action will be added. Shows up when you starung on vehicle or box, action will assign kit to pointed vehicle/box.</li>
</ul> 
<br>Basic flow of usage is: Open Virtual Arsenal, choose any gear you need, quit Arsenal and use Copy Current Gear to Clipboard. Than open <tt>dzn_gear_kit.sqf</tt> and paste kit. It will be something like:
<br><tt>_kitName = ["U_B_CombatUniform_mcam", ... ];</tt>
<br>Change <tt>_kitName</tt> to some unique kit name, e.g. <tt>riflemanNATO</tt>, <tt>SF_Demo_NATO</tt>, <tt>OPFOR_OfficerWithMG</tt>. It's preffered to use global variable as name of kit.

<h3>Prepare kits</h3>
There are several types of gear kits are presented:
<ul>
 <li><ul>Gear Kit (for infantries)
  <li>Simple Kits</li>
  <li>Randomized Kits</li>
  <li>Simple Kits</li>
 </ul></li>
 <li>Cargo Kit (for vehicle and ammoboxes)</li>
</ul>

