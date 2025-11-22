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
    snareFreq:         10,                
    accent:            0.9,               
    tone:              0.6,               
    decay:             0.3,               
    snappy:            0.7,               
    
    // === RESONATOR PARAMETERS ==
    rposition:         0.1,               
    rstructure:        0.3,               
    rbrightness:       0.25,              
    rdamping:          1.0,               
    
    // === PROCESSING ==
    resMix:            0.6,               
    delayMix:          0.4,               
    comp:              0.7,               
    flag:              0.1,               
    tempo:             1.0,               
    
    // === OUTPUT ==
    amp:               1.0,               
    pan:               0,                 
    out:               0,                 
));

// BASE PATTERN 2
Pdef(\rsBase2, Pbind(
    instrument:        \resonantSnare,
    
    // === TRIGGER ===
    tgate:             1,                  // trigger gate (0 or 1)
    
    octave:            2,
    rfreq:             { ~detunedFreq.value },                // resonator base frequency (25-250 Hz)
    
    // === SNARE DRUM PARAMETERS ===
    snareFreq:         80,                 
    accent:            0.2,                
    tone:              0.9,                
    decay:             1.5,                
    snappy:            0.1,                
    
    // === RESONATOR PARAMETERS ==
    rfreq:             120,                
    rposition:         0.1,                
    rstructure:        0.8,                
    rbrightness:       0.4,                
    rdamping:          0.3,                
    
    // === PROCESSING ==
    resMix:            1.0,                
    delayMix:          0.6,                
    comp:              0.1,                
    flag:              0.1,                
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
    snareFreq:         40,                 
    accent:            0.9,                
    tone:              0.3,                
    decay:             0.8,                
    snappy:            0.2,                
    
    // === RESONATOR PARAMETERS ===
    rfreq:             60,                 
    rposition:         0.5,                
    rstructure:        0.2,                
    rbrightness:       0.1,                
    rdamping:          2.0,                
    
    // === PROCESSING ===
    resMix:            0.5,                
    delayMix:          0.1,                
    comp:              0.7,                
    flag:              0.01,               
    tempo:             1.0,
    
    // === OUTPUT ===
    amp:               1.5,                
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
    snareFreq:         300,                
    accent:            0.3,                
    tone:              0.8,                
    decay:             2.0,                
    snappy:            0.9,                
    
    // === RESONATOR PARAMETERS ==
    rfreq:             180,                
    rposition:         0.7,                
    rstructure:        0.6,                
    rbrightness:       0.35,               
    rdamping:          0.8,                
    
    // === PROCESSING ==
    resMix:            0.4,                
    delayMix:          0.1,                
    comp:              0.3,                
    flag:              0.01,               
    tempo:             0.8,                
    
    // === OUTPUT ==
    amp:               0.6,                
    pan:               0,
    out:               0,
    warp:              Pseg([Pwhite(0.0, 1.0)], [4], 0, inf)
));
)

(
////////////////////////////////////////////////////////////////////////
// GESTURAL PATTERNS - Warped and experimental
////////////////////////////////////////////////////////////////////////

Pdef(\rsGesture1, 
    Pbind(
        dur: 0.4 * Pseq([1, 2, 3, 2, 1], 4),    
        rfreq: 120,   
        rstructure: Pseq([0.9, 0.1, 0.8], 3),
        rbrightness: Pseq([0.2, 0.6, 0.1, 0.8], 3),
        delayMix: Pseq([0.9, 0.1, 0.8], 4),  
        amp: Pseq([0.3, 1.2, 0.6], 4),
        snappy: 0.9,
    )
);

Pdef(\rsGesture2,
    Pbind(
        dur: 3 * Pseq([0.1, 0.05, 0.15, 0.08, 0.12], 4), 
        snareFreq: 48,
        accent: Pseq([1.0, 0.2, 0.8, 0.4, 0.9], 4),  
        amp: Pseq([1.0, 0.3, 0.8, 0.4, 0.6], 4)      
    )
)
)

(
Pdef(\player, Pbind.mono() <> 
    Pwith(
        Pbind(
            dur: Prand([4], inf),
            legato: 1,
            pdef: Pshufpart([
                \rsGesture1,
                \rsGesture2,
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
