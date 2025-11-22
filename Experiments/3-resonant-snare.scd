(
Require("../SynthDefs/resonant_snare");
)

////////////////////////////////////////////////////////////////////////
// BASE PATTERNS - Complete parameter documentation
////////////////////////////////////////////////////////////////////////

( // BASE PATTERN 1
Pdef(\rsBase1, Pbind(
    instrument:        \resonantSnare,
    
    // === TRIGGER ===
    tgate:             1,                  // trigger gate (0 or 1)
    
    octave:            2,
    rfreq:             { ~detunedFreq.value },                // resonator base frequency (25-250 Hz)
    
    // === SNARE DRUM PARAMETERS ===
    snareFreq:         10,                // snare fundamental frequency (20-400 Hz)
    accent:            0.9,                // hit strength (0-1)
    tone:              0.6,                // tone character (0-1, 0=noisy, 1=tonal)
    decay:             0.3,                // snare decay time (0-100, practical 0.1-2)
    snappy:            0.7,                // snare wire brightness (0-1)
    
    // === RESONATOR PARAMETERS ===
    rposition:         0.1,                // resonator position (0-1)
    rstructure:        0.3,                // resonator structure (0-1, 0=simple, 1=complex)
    rbrightness:       0.25,               // resonator brightness (0-0.5)
    rdamping:          1.0,                // resonator damping (0.2-4, low=ringing, high=dead)
    
    // === PROCESSING ===
    resMix:            0.6,                // resonator mix amount (0-1)
    delayMix:          0.4,                // delay effect mix (0-1)
    comp:              0.7,                // compression amount (0-1)
    flag:              0.1,               // frequency lag time (0.001-1)
    tempo:             1.0,                // tempo scaling (0.5-2)
    
    // === OUTPUT ===
    amp:               1.0,                // overall amplitude (0-4)
    pan:               0,                  // stereo panning (-1 to 1)
    out:               0,                  // output bus (0-127)
));

// BASE PATTERN 2
Pdef(\rsBase2, Pbind(
    instrument:        \resonantSnare,
    
    // === TRIGGER ===
    tgate:             1,                  // trigger gate (0 or 1)
    
    octave:            2,
    rfreq:             { ~detunedFreq.value },                // resonator base frequency (25-250 Hz)
    
    // === SNARE DRUM PARAMETERS ===
    snareFreq:         80,                 // lower frequency for bell character
    accent:            0.2,                // gentle hit
    tone:              0.9,                // very tonal
    decay:             1.5,                // longer decay
    snappy:            0.1,                // minimal snare character
    
    // === RESONATOR PARAMETERS ===
    rfreq:             120,                // resonator tuning
    rposition:         0.1,                // near bridge position
    rstructure:        0.8,                // complex structure
    rbrightness:       0.4,                // bright resonance
    rdamping:          0.3,                // long ringing
    
    // === PROCESSING ===
    resMix:            1.0,                // full resonator
    delayMix:          0.6,                // more delay
    comp:              0.1,                // light compression
    flag:              0.1,                // slower frequency changes
    tempo:             1.0,
    
    // === OUTPUT ===
    amp:               0.8,
    pan:               0,
    out:               0,
));

// BASE PATTERN 3
Pdef(\rsBase3, Pbind(
    instrument:        \resonantSnare,
    
    // === TRIGGER ===
    tgate:             1,
    
    octave:            2,
    rfreq:             { ~detunedFreq.value },                // resonator base frequency (25-250 Hz)
    
    // === SNARE DRUM PARAMETERS ===
    snareFreq:         40,                 // very low for kick character
    accent:            0.9,                // hard hit
    tone:              0.3,                // more noise
    decay:             0.8,                // medium decay
    snappy:            0.2,                // minimal snap
    
    // === RESONATOR PARAMETERS ===
    rfreq:             60,                 // low resonant frequency
    rposition:         0.5,                // center position
    rstructure:        0.2,                // simple structure
    rbrightness:       0.1,                // dark resonance
    rdamping:          2.0,                // controlled ringing
    
    // === PROCESSING ===
    resMix:            0.5,                // balanced mix
    delayMix:          0.1,                // minimal delay
    comp:              0.7,                // strong compression
    flag:              0.01,               // fast frequency response
    tempo:             1.0,
    
    // === OUTPUT ===
    amp:               1.5,                // louder for kick
    pan:               0,
    out:               0,
));

// BASE PATTERN 4
Pdef(\rsBase4, Pbind(
    instrument:        \resonantSnare,
    
    // === TRIGGER ===
    tgate:             1,
    
    octave:            2,
    rfreq:             { ~detunedFreq.value },                // resonator base frequency (25-250 Hz)
    
    // === SNARE DRUM PARAMETERS ===
    snareFreq:         300,                // higher frequency
    accent:            0.3,                // gentle
    tone:              0.8,                // tonal but textural
    decay:             2.0,                // long tail
    snappy:            0.9,                // bright snare character
    
    // === RESONATOR PARAMETERS ===
    rfreq:             180,                // mid-range resonance
    rposition:         0.7,                // near edge
    rstructure:        0.6,                // moderately complex
    rbrightness:       0.35,               // balanced brightness
    rdamping:          0.8,                // moderate damping
    
    // === PROCESSING ===
    resMix:            0.4,                // mostly resonated
    delayMix:          0.1,                // heavy delay processing
    comp:              0.3,                // light compression
    flag:              0.05,               // medium lag
    tempo:             0.8,                // slower tempo
    
    // === OUTPUT ===
    amp:               0.6,                // quieter for texture
    pan:               0,
    out:               0,
    warp:              Pseg([Pwhite(0.0, 1.0)], [4], 0, inf)
));

////////////////////////////////////////////////////////////////////////
// GESTURAL PATTERNS - Warped and experimental
////////////////////////////////////////////////////////////////////////

Pdef(\rsGesture1, 
    Pbind(
        dur: Pseq([0.2, 0.3, 0.5], 1),    // irregular timing
        rfreq: Pseq([25, 180, 250], 1),   // wild frequency jumps
        rstructure: Pseq([0.9, 0.1, 0.8], 1), // structure chaos
        delayMix: Pseq([0.9, 0.1, 0.8], 1),   // delay modulation
        amp: Pseq([0.3, 1.2, 0.6], 1)     // dynamic range
    )
);

Pdef(\rsGesture2,
    Pbind(
        octave: Pseq([6, 1, 2, 2], inf),      // dropping octave
        dur: Pseq([0.15, 0.25, 0.4, 0.6], 1), // accelerating hits
        accent: Pseq([0.1, 0.6, 0.9, 1.0], 1), // building intensity
        rdamping: Pseq([0.2, 2.0, 0.4, 3.0], 1), // final damped hit
        rbrightness: Pseq([0.1, 0.2, 0.45, 0.5], 1), // brightness climb
        resMix: Pseq([1.0, 0.8, 0.5, 0.2], 1) // fade resonator
    )
);

// GESTURAL 3 - Pitch dive bomb
Pdef(\rsGesture3,
    Pbind(
        octave: 2,
        dur: Pseq([0.8, 0.3, 0.2], 1),    // slowing down
        snareFreq: Pseq([200, 80, 120], 1), // pitch dive
        tone: Pseq([0.4, 0.4, 0.1], 1),   // becoming noisy
        decay: Pseq([0.2, 0.8, 2.0], 1),  // longer tails
        comp: Pseq([0.9, 0.5, 0.1], 1)    // less compression
    )
).play;

// GESTURAL 4 - Resonator morph
Pdef(\rsGesture4,
    Pbind(
        octave:        6,
        snappy:        1.0,
        decay:         0.03,
        dur:           Pseg([1.0,  0.06], [4], \exp), // irregular rhythm
        rposition:     Pseg([0.8, 0.1], [4]), // irregular rhythm
        rstructure:    Pwhite(1.0, 0.3),
        flag:          Pseg([0.3, 0.1], [4]), // irregular rhythm
    )
);

// GESTURAL 5 - Chaotic burst
Pdef(\rsGesture5,
    Pbind(
        dur: Pseq([0.1, 0.05, 0.15, 0.08, 0.12], 1), // rapid fire
        snareFreq: Pseq([400, 50, 300, 100, 250], 1), // frequency chaos
        accent: Pseq([1.0, 0.2, 0.8, 0.4, 0.9], 1),  // dynamic chaos
        rfreq: Pseq([250, 25, 200, 80, 150], 1),      // resonator chaos
        amp: Pseq([1.0, 0.3, 0.8, 0.4, 0.6], 1)      // amplitude variation
    )
);

// GESTURAL 5 - Chaotic burst
Pdef(\rsGesture6,
    Pbind(
        rposition: 0.02,
        dur: 3.0/8.0 * Pseq([1, 1, 1, 1], inf),
        accent: Pseq([0.9, 0.2, 0.4, 0.4], inf),  // dynamic chaos
        rfreq: 30,
        snareFreq: 120,
        octave: 2,
        decay: 0.2,
        rbrightness: 0.5,
        delayMix: 0,
        snappy: 1,
        amp: Pseq([1.0, 0.3, 0.8, 0.4, 0.6], inf)      // amplitude variation
    )
);


Pdef(\player, Pbind.mono() <> 
    Pwith(
        Pbind(
            dur: Prand([8], inf),
            legato: 1,
            pdef: Pshufpart([
                // \rsGesture1,
                // \rsGesture2,
                // \rsGesture3,
                // \rsGesture4,
                // \rsGesture5,
                // \rsGesture6,
                \kick,
                // \snare,
                // \snare,
                // \snare,
                \snare,
                \snare,
                \kick,
                \kick,
                // \bassResKit,
                // \resKit,
                // \bassResKit,
                // \kick,
                // \kick,
                // \kick,
                // \resKit,
                // \bassResKit,
                // \bassResKit,
            ], inf),
            base: Pshufpart([
                \rsBase1,
                \rsBase2,
                \rsBase3,
                \rsBase4,
            ], inf)
        ),
        {
            Pbind(dur: Pkey(\dur) * 0.5) <> Pdef(~pdef.postln) <> Pdef(~base)      
        }
    )
)).play
)
