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
}

namespace Core {
    void INIT() {
        print('Initializing AK Display..');
        // check if plugin is up-to-date and check for other potential issues
        print('AK Display successfully initialized!');
    }

    void SetLastPressed(uint16 _pressed) {
        if (_pressed != released) released = _pressed;
    }

    void SetAK(uint16 _value) {
        last_set = _value;
        str_released = Utils::GetStrAK(_value);
    }

    // 0x40 -> ak1, 0x80 -> ak2, 0x100 -> ak3, 0x200 -> ak4, 0x400 -> ak5, 0x0 -> nothing
    const uint16 OFFSET_ARENA_INTERFACE_AK_PRESSED = 0x10b0;
    
    uint16 ReadAKPressed() {
        auto cp = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        if (cp is null || cp.ArenaInterface is null) {
            throw('Check that CurrentPlayground and ArenaInterface are not null before calling.');
        }
        return Dev::GetOffsetUint16(cp.ArenaInterface, OFFSET_ARENA_INTERFACE_AK_PRESSED);
    }
}
