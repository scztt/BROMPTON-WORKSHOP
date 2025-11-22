// Using Pseq and the randomnness patterns, create variations on this base pattern
// that sound different. Try to use randomness to make variations that are unpredictable
// but still have a sense of coherence.
// 
// If you want more varied sound, the other keys you can use are listed in epiano-examples.scd.
// Try sequencing these for more timbral variation.

( // _SETUP_
Require("../SynthDefs/*")
)

(
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
    
    vel: Pshufpart([0.6, 1.0, 0.9], inf),
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    
    scale: Scale.aeolian,
    octave: 3,
    degree: Pseq([1, -2, 4, 2, -2], inf) + 0   
)).play;
)

