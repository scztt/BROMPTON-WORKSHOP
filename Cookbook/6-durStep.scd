( // _SETUP_
Require("../SynthDefs/*")
)

// NEW CLASSES/METHODS:
// pattern.durStep(duration)  - hold pattern values for specified duration

(
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
    
    vel: Pxrand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    
    crash: 0.9,
    push: 0.5,
    // jump: Pwhite(0.0, 1.0).durStep(2),
    filtf: 19000,
    scale: Scale.aeolian,
    octave: 3,
    degree: Pseq([1, -2, 4, 2, -2], inf) + 0   
));
)

(
Pdef(\durStep, Pbind(
    degree: Pseq([1, -2, 4, 2, -2], inf).durStep(2)
) <> Pdef(\base)).play;    
)

// You can step different keys at different rates
// to get more complex rhythmic structures.
(
Pdef(\durStep, Pbind(
    degree: Pseq([1, -2, 4, 2, -2], inf).durStep(2),
    octave: Pseq([3, 3, 4], inf).durStep(3/4),
) <> Pdef(\base)).play;    
)


// Step values can also come from a pattern....
(
Pdef(\durStep, Pbind(
    octave: Pseq([3, 3, 4], inf).durStep(3/4),
    degree: Pseq([1, -2, 4, 2, -2], inf).durStep(
        Pxrand([1, 3/8, 5/8, 2], inf)
    )
) <> Pdef(\base)).play;    
)


// Layer several different step patterns together
(
Pdef(\durStep, Pbind(
    degree: Pseq([1, -2, 4, 2, -2], inf)
        .durStep(Pxrand([1, 3/8, 5/8, 2], inf)),
    
    octave: Pkey(\octave)
        + Pshufpart([0, 0, 0, 1], inf).durStep(1),
) <> Pdef(\base)).play;    
)
