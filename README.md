# dzn_gear

- Allows to choose gear and create gear kit for infantry units
- Allows to create cargo gear kits for vehicles and ammoboxes
- Allows to use created kits to assign gear via: Synchronization with GameLogic or setVariable for unit

<h2>How To</h2>
Download files to your mission folder. If you already have "init.sqf", then update it with lines from downloaded "init.sqf".
<br>Open mission in Editor and click "Preview": inside the mission you'll see a new actions at the action menu:
 <ul>
  <li><tt>Open Virtual Arsenal</tt> -- Simply opens VA with all available gear</li>
  <li><tt>Copy Current Gear to Clipboard</tt> -- Copy current gear to clipboard for inserting to dzn_gear_kit.sqf file</li>
  <li><tt>Copy and Assign Gear of Cursor Unit</tt> -- Shows up when you staring on infantryman, action will copy unit's gear to your unit and additionally copy kit to the clipboard</li>
  <li><tt>Copy Gear of Cursor Vehicle or Box</tt> -- Shows up when you staring on vehicle or ammobox, action will copy vehicle's cargo to the clipboard in vehicle kit's format</li>
  <li><tt>Kit with (mission time) (primary weapon classname)</tt> -- After any infanty's kit copied, new action will be added. On action - copied kit will be assigned to player.</li>
  <li><tt>Kit for Vehicle/Box (mission time)</tt> -- After any vehicle's kit copied, new action will be added. On action - kit will be copied again.</li>
</ul> 

