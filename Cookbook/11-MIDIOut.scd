
( // _SETUP_
Require("../SynthDefs/*")
)

// NEW CLASSES/METHODS:
// Event.addEventType(\name, function)  - create custom event types
// MIDIOut.newByName(device, port)      - create MIDI output connection

(
Event.addEventType(\midicc, {
    var event;
    127.do {
        |i|
        var event, name, value;
        
        name = "cc%".format(i + 1).asSymbol;
        value = currentEnvironment[name] !? _.value;
        value !? {
            event = currentEnvironment.copy
                .putAll((
                    type: \midi,
                    midicmd: \control,
                    ctlNum: i,
                    control: (value * 127.0).asInteger,
                ));
            event.play
        }
    };
});

Event.addEventType(\midinote, {
    var event;
    
    event = currentEnvironment.copy
        .put(\type, \midicc);
    event.play;
    
    event = currentEnvironment.copy
        .put(\type, \midi)
        .put(\midicmd, \noteOn);
    event.play;
});
)

(
Ndef(\test, Pbind(
    type: \midi,
    midicmd: \noteOn,
    midiout: MIDIOut.newByName("IAC Driver", "Bus 1"),
    dur: 1/6,
    octave: 3,
    legato: Pwnrand([0.4, 0.6, 2.67], [2, 2, 1], inf),
    velocity: 127 * Pseq([1, 0.2, 0.7], inf),
    degree: Pseq([0, 4, 1, 6, -2], inf) + Pseq([0, -1, -2, 1], inf).durStep(2),
    scale: Scale.melodicMinor,
    legato: 0.7, 
    finish: {
        currentEnvironment.postln;
    } 
)).play;

Ndef(\ctrl, Pbind(
    type: \midi,
    midicmd: \control,
    midiout: MIDIOut.newByName("IAC Driver", "Bus 1"),
    dur: 1/2,
    chan: 0,
    ctlNum: 2,
    control: Pwhite(60.0, 127.0),
)).play;


Ndef(\ctrl2, Pbind(
    type: \midi,
    midicmd: \control,
    midiout: MIDIOut.newByName("IAC Driver", "Bus 1"),
    dur: 1/2,
    chan: 0,
    ctlNum: 1,
    control: Pwhite(0.0, 127.0),
)).play
)


(
Pdef(\test).clear;
Pdef(\test, Pbind(
    type: \midinote,
    midiout: MIDIOut.newByName("IAC Driver", "Bus 1"),
    dur: 1 / 6,
    octave: Pwnrand.choose(
        3 -> 5,
        6 -> 1,
    ),
    
    legato: Pwnrand([0.4, 0.6, 4.67], [2, 2, 1], inf),
    velocity: 127 * Pseq([1, 0.2, 0.7], inf),
    degree: [0, 3] + Pseq([0, 4, 1, 6, -2], inf) + Pseq([0, -1, -2, 1], inf).durStep(2),    
    strum: 1/16,
    
    cc2: Pseq([0.6, 0.8, 0.1], inf),
    cc3: Pseg([0.1, 0.6], [Pwhite(2, 6)], \lin, repeats: inf),
)).play
)