( // _SETUP_
Require("../SynthDefs/*")
)

// NEW CLASSES/METHODS:
// Ppar([pattern1, pattern2, ...])  - play multiple patterns in parallel
// Pmaybe(condition, pattern)       - conditionally play pattern or silence

// PPAR
//
// Ppar allows you to play multple Pbinds with different time in parallel
//
// pattern.timeClutch()
// ensures that only ONE event will be pulled from a  pattern for a given 
// moment in time. For example, if two patterns in a Ppar both trigger at 
// the same time, they'll only pull ONE value from the downstream 
// Pattern.instVarsForGui()

(
Pdef(\base, Pbind(
    instrument: 'additive',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    sustain: 0.01,
    release: 0.6,
    
    vel: Pxrand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    filtf: Pseg([900, 12000, 900], [10, 10], \exp).repeat,
    octave: 3,
    degree: Pseq([1, -2, 2, 1, -2], inf) + 0   
));
)

(
// slow bass
Pdef(\ppar_1, Pbind(
    dur: 8,
    sustain: 5,
    filtf: 900,
    attack: 5, release: 6,
    octave: 3,
));

//  faster high pluck
Pdef(\ppar_2, Pbind(
    amp: 0.1,
    dur: 3,
    sustain: 0.05,
    attack: 0.01, release: 12,
    octave: Prand([5, 6], inf),
));

Pdef(\ppar, Ppar([
    Pdef(\ppar_1),
    Pdef(\ppar_2),
]) <> Pdef(\base)).play;
)

// Conditional forking
// Q: What if ONCE IN A WHILE I want to trigger a parallel event on top of my existing pattern...
// A: Pmaybe! Pmaybe is like Pif but if the condition is false it just outputs silence. 
( 
// slow bass
Pdef(\slowBass, Pbind(
    instrument: 'epiano',
    dur: Prand([3, 2], inf) / 8,
    sustain: 2,
    filtf: 900,
    attack: 0.02, release: 4,
    amp: 0.3,
    octave: 3,
    highNote: Pwnrand([false, true], [5, 1])
));

Pdef(\ppar, 
    // Two parallel patterns...
    Ppar([
        
        // This pattern forwards the events from \slowBass
        Pid(),                  
        
        // This patterns plays a long long, but only sometimes
        Pmaybe(
            Pkey(\highNote),    // If highNote...
            Pbind(              // ...use events from this pattern (composed with \slowBass...)
                amp: 0.1,
                attack: 5, 
                release: 5,
                sustainLevel: 1,
                sustain: 5,
                octave: 6,
                retrig: 3,
            )                   // ...otherwise just silent events
        )
    ])
    <> Pdef(\slowBass) 
    <> Pdef(\base)
).play;
)