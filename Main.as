bool init = true; // set to false after implementing INIT

// 0x40 -> ak1, 0x80 -> ak2, 0x100 -> ak3, 0x200 -> ak4, 0x400 -> ak5, 0x0 -> nothing
const uint16 loc_ak0 = 0; const uint16 loc_ak1 = 0x40;
const uint16 loc_ak2 = 0x80; const uint16 loc_ak3 = 0x100;
const uint16 loc_ak4 = 0x200; const uint16 loc_ak5 = 0x400;

// will be used for displaying an optional green icon when all AKs are off
bool AK0, AK1, AK2, AK3, AK4, AK5 = false;

uint16 depressed = loc_ak0;
uint16 released = loc_ak0;
uint16 last_set = loc_ak0;

string str_released = 'No AK';
string initMsg = 'an unknown issue';

void AKDetector() {
  while(true) {
      depressed = Core::ReadAKPressed();
      
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
      else if (depressed == 0 && released == 0) {
          Core::SetAK(0);
      }

      // Reset values when all AKs are turned off
      if (last_set == depressed) {
          Utils::resetAKs();
          released = loc_ak0;
      }
      
      print(str_released + ' is active!'); 
      //print('Going to next tick..');
      yield(); // pause loop until next game-tick
  }
}

void Main() {
    
    Core::INIT();
    if (init == true) {
        AKDetector();
    } else {
        print('Uh oh! Ak Display broke because of ' + initMsg);
    }
}
