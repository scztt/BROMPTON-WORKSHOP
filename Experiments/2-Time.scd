// Take your patterns from the first experiment, or any of the examples you liked so far.
// Pick ONE OR TWO parameters from them to change over time with any of the time-varying patterns.
// Make a modifier pattern with JUST those keys, and then <> compose them with the original.
//
// Trying making several different time-varying patterns and swap them out,
// or layer them up if they apply to different keys.

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
    filtf: 19000,
    scale: Scale.aeolian,
    octave: 3,
    degree: Pseq([1, -2, 4, 2, -2], inf) + 0   
));
)

(
Pdef(\filterVariation, 
    Pbind(
        filtf: Pseg([100, 15000, 100, 20000], [4, 4, 4], \exp).repeat,
    ) 
    <> Pdef(\base)).play
)


(
Pdef(\filterVariation, 
    Pbind(
        push: Pseg([0.1, 0.9, 0.2], [6, 6], \exp).repeat,
    ) 
    <> Pdef(\base)
).play
)
