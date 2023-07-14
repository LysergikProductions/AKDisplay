/* *
 *  About: Backend class for AKDisplay Plugin. Contains various functions for the plugin.
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

// Need to add detection for double respawn, retiring, and map change (ak resets)

namespace Utils {
    string GetStrAK(uint16 _value) {
        if (_value == loc_ak0) return "No Ak";
        else if (_value == loc_ak1) return "AK1";
        else if (_value == loc_ak2) return "AK2";
        else if (_value == loc_ak3) return "AK3";
        else if (_value == loc_ak4) return "AK4";
        else if (_value == loc_ak5) return "AK5";
        else return "Unrecognized memory location";
    }
    
    void resetAKs() {
        AK0 = false; AK1 = false; AK2 = false;
        AK3 = false; AK4 = false; AK5 = false;

        released = loc_ak0;
    }
}

namespace Core {
    void INIT() {
        print('Initializing AK Display..');
        // check if plugin is up-to-date and check for other potential issues
        init = true;
        print('AK Display successfully initialized!');
    }

    void SetLastPressed(uint16 _pressed) {
        if (_pressed != released) released = _pressed;
    }

    void SetAK(uint16 _value) {
        last_set = _value;
        
        // set global ak status booleans here
        
        str_released = Utils::GetStrAK(_value);
    }
    
    const uint16 OFFSET_ARENA_INTERFACE_AK_PRESSED = 0x10b0;
    
    uint16 ReadAKPressed() {
        auto cp = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        if (cp is null || cp.ArenaInterface is null) {
            throw('Check that CurrentPlayground and ArenaInterface are not null before calling.');
        }
        return Dev::GetOffsetUint16(cp.ArenaInterface, OFFSET_ARENA_INTERFACE_AK_PRESSED);
    }

    CSmScriptPlayer@ Get_ControlledPlayer_ScriptAPI(CGameCtnApp@ app) {
        try {
            auto ControlledPlayer = cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].ControlledPlayer);
            if (ControlledPlayer is null) return null;
            return cast<CSmScriptPlayer>(ControlledPlayer.ScriptAPI);
        } catch {
            return null;
        }
    }

    CSmScriptPlayer@ Get_GUIPlayer_ScriptAPI(CGameCtnApp@ app) {
        try {
            auto GUIPlayer = cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer);
            if (GUIPlayer is null) return null;
            return cast<CSmScriptPlayer>(GUIPlayer.ScriptAPI);
        } catch {
            return null;
        }
    }
    
    int Get_Player_StartTime(CGameCtnApp@ app) {
        try {
            return Get_GUIPlayer_ScriptAPI(app).StartTime;
        } catch {}
        try {
            return Get_ControlledPlayer_ScriptAPI(app).StartTime;
        } catch {}
        return -1;
    }
    
    int GetCurrentRaceTime(CGameCtnApp@ app) {
        if (app.Network.PlaygroundClientScriptAPI is null) return 0;
        int gameTime = app.Network.PlaygroundClientScriptAPI.GameTime;
        int startTime = Get_Player_StartTime(GetApp());
        //if (startTime < 0) return 0;
        return gameTime - startTime;
        // return Math::Abs(gameTime - startTime);  // when formatting via Time::Format, negative ints don't work.
    }
}
