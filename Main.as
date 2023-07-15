/* *
 *  About: Main class for AKDisplay Plugin. For use in Trackmania 2020 via Openplanet.
 *
 *  LICENSE: AGPLv3 (https://www.gnu.org/licenses/agpl-3.0.en.html)
 *  Copyright (C) 2023  Lysergik Productions (https://github.com/LysergikProductions)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * */
const float version = 0.1; const int build = 3;
const string testedGameVersion =
     "2023-06-22-11_50 (0C86FF47A34D62F38B6A67008446D990A22DE344B96F62A8ACA97DE0CA1F6D9A)";

bool init = false;
auto app = GetApp();

// 0x40 -> ak1, 0x80 -> ak2, 0x100 -> ak3, 0x200 -> ak4, 0x400 -> ak5, 0x0 -> nothing
const uint16 loc_ak0 = 0; const uint16 loc_ak1 = 0x40;
const uint16 loc_ak2 = 0x80; const uint16 loc_ak3 = 0x100;
const uint16 loc_ak4 = 0x200; const uint16 loc_ak5 = 0x400;

// For globally accessing ak statuses
bool AK0, AK1, AK2, AK3, AK4, AK5;

// For tracking key-press states and storing currently active AK
uint16 depressed = loc_ak0;
uint16 released = loc_ak0;
uint16 last_set = loc_ak0;

// Some debugging variables
string str_released = 'No AK'; string initMsg = 'an unknown issue';

void AKDetector() {
    while(true) {
        int _mapTime = Core::GetCurrentRaceTime(app);
        //print(_mapTime);
        
        // reset go to next tick whenever there is no active map
        if (Core:: isDriving() ==  false) {
            Utils::resetAKs(); yield();
        }
        
        depressed = Core::ReadAKPressed();
        
        // Reset AKs when _mapTime is less than 0
        if (_mapTime < 0) { Core::SetLastPressed(loc_ak0); Core::SetAK(loc_ak0); }
        else {
            // An action key is depressed, so which one?
            if (depressed > loc_ak0) {
                if (depressed == loc_ak1) Core::SetLastPressed(depressed);
                else if (depressed == loc_ak2) Core::SetLastPressed(depressed);
                else if (depressed == loc_ak3) Core::SetLastPressed(depressed);
                else if (depressed == loc_ak4) Core::SetLastPressed(depressed);
                else if (depressed == loc_ak5) Core::SetLastPressed(depressed);
            }

            // An action key is released and the previous *AK value was different*
            else if (depressed == loc_ak0 && released != loc_ak0) {
                if (released == loc_ak1) Core::SetAK(released);
                else if (released == loc_ak2) Core::SetAK(released);
                else if (released == loc_ak3) Core::SetAK(released);
                else if (released == loc_ak4) Core::SetAK(released);
                else if (released == loc_ak5) Core::SetAK(released);
            }

            // An action key is released and the previous *AK value was the same*
            else if (depressed == 0 && released == 0) Core::SetAK(0);

            // Reset values when all AKs are turned off
            if (last_set == depressed && _mapTime >= 0) Utils::resetAKs();
        }

        print(str_released + ' is active!');
        //print('Going to next tick..');
        yield(); // pause loop until next app-tick
    }
}

void Main() {
    
    Core::INIT();
    if (init == true) {
        AKDetector();
    } else {
        throw('Uh oh! Ak Display has a critical exception: ' + initMsg);
        // try catch to add an issue to the repo automatically
    }
}
