// NEW CLASSES/METHODS:
// Pbind(key1: pattern1, key2: pattern2, ...)  - creates event pattern
// Pdef(\name, pattern)                        - named pattern container

// EVENT KEYS (Event Quick Reference)

// [what to play]
// instrument: which SynthDef to play (default: \default)
// type: event type - \note (default), \midi, \rest, \pattern, etc.

// [timbre / volume]
// amp: 0..1 amplitude (or use db for decibels)
// db: volume in decibels (default: -20.0)
// pan: -1 (left) to 1 (right), 0 = center

// [pitch]
// freq: frequency in Hz (overrides degree/note calculations)
// degree: which note on a scale (0=root, 1=second, etc.)
// note: chromatic note (0=C, 1=C#, 2=D, etc.)
// midinote: MIDI note number (60=middle C)
// octave: numeric octave (default: 5.0)
// scale: which scale to use (default: major scale)
//      list all scales: Scale.all.parent.keys.do(_.postln)
// detune: fine tuning offset in Hz

// [timing]
// dur: duration between events (inter-onset time)
// sustain: how long to HOLD the note, in beats
// legato: what FRACTION of the dur to hold the note:
//     1.0 = hold for full dur, 0.5 = half, 2.0 = overlap
//     (legato and sustain are inter-related, use one or the other)
// timingOffset: delay in beats
// strum: time spread for chords (negative = backwards)

( // _SETUP_
Require("../SynthDefs/*")
)

////////////////////////////////////////////////////////////////////////
// 1. Simple Pbind - plays a single note
////////////////////////////////////////////////////////////////////////
( // Pbind example
Pbind(
    instrument: \epiano,
    octave: 3,    // octave number
    degree: 4,    // root note of scale
    dur: 1        // 1 beat duration
).play
)

////////////////////////////////////////////////////////////////////////
// 2. Basic Pdef - named pattern container
////////////////////////////////////////////////////////////////////////
( // Pdef example
Pdef(\myPattern, Pbind(
    instrument: \epiano,
    octave: 3,      // octave number
    degree: 4,      // third of the scale
    dur: 0.5        // half beat
))
)

// Play the Pdef
Pdef(\myPattern).play;

// Stop the Pdef
Pdef(\myPattern).stop;


////////////////////////////////////////////////////////////////////////
// 5. Pdef composition - one pattern calls another
////////////////////////////////////////////////////////////////////////
