/*
 * Colour mapping taken from:
 * http://www.vimeo.com/12366587
 *
 * C - Red
 * D - Yellow
 * E - Green
 * F - Light Blue
 * G - Dark Blue
 * A - Purple
 * B - Pink
 */

//byte myByte; // there's some fucked up bug in Arduino where if you
             // don't declare a byte to start; you can't use byte
             // in structs inside of includes :/
#include <stdlib.h>
//#include <math.h>
#include <WProgram.h>
#include "pins.h"
#include "sheetNote.h"
#include "nyancat.h"


boolean bPlayed;
String buf;

void setup() {
  Serial.begin(115200);
//  Serial.println("Starting Nyanduino v0.1");
  bPlayed = false;
  buf = String();
}

void loop() {
  if(bPlayed == false) {
    //bPlayed = true; // play once only
    for(int i = 0; i < (sizeof(tune)/sizeof(sheetNote)); i++) {    
      playNote(tune[i]);
    } // end for()
//    Serial.println("");
//    Serial.println("OK, I'm done.");
//    buf = "Nyanning took: ";
//    buf.concat((millis()));
//    buf.concat(" Millies");
//    Serial.println(buf);
  } // end if bPlayed
} // end loop()

int playNote(sheetNote theNote) {
  // implementation based on 
  // http://itp.nyu.edu/physcomp/Labs/ToneOutput
  int note         = theNote.note;
  int noteDuration = theNote.duration * 0.6;
  int notePause    = noteDuration * 1;
  int notePin      = getNotePin(note);
  int hzVal        = int(getHzFromMidiNote(note));

//  buf = "Playing: ";
    buf = "";
    
//  buf.concat(note);
//  buf.concat(" [ ");
  buf.concat(note);
//  buf.concat(" ] for ");
  buf.concat(",");
  
  buf.concat(noteDuration);
//  buf.concat(" ms.");
  Serial.println(buf);
  
  if(note == REST) {
    noTone(pinSPK);
    delay(noteDuration);
  } else {   
    digitalWrite(notePin,HIGH);
    tone(pinSPK, hzVal, noteDuration);
    digitalWrite(notePin,LOW);
  }
  
  delay(notePause); // a pause between notes
  return 0;
}

int getNotePin(int note) {
  switch(note) {
  case NOTE_DS4:
  case NOTE_D5:
  case NOTE_DS5:
    return pinD;
    break;
  case NOTE_E4:
  case NOTE_E5:
    return pinE;
    break;
  case NOTE_FS4:
  case NOTE_FS5:
    return pinF;
    break;
  case NOTE_GS4:
  case NOTE_GS5:
    return pinG;
    break;
  case NOTE_AS4:
    return pinA;
    break;
  case NOTE_B4:
    return pinB;
    break;
  case NOTE_CS5:
    return pinC;
    break;
  case REST:
  default:
    // no pin
    return -1;
    break;
  }
  return 0;
}

double getHzFromMidiNote(int note) {
  // A440 = 57.
  // exponent = (note - A440)/12
  // radix = 2
  
  double retval;
  float base = 2.0;
  float exponent = ((note - 57.0)/12.0);

  return 440 * pow(base, exponent ); // on Arduino, this is SLOW
                                     // but may be acceptable for this sketch
           // cf http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1267448869
}
