( // _SETUP_
Require("../SynthDefs/*")
)

// NEW CLASSES/METHODS:
// Pseg([levels], [times], curve).repeat  - envelope segments over time

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
));
)

// IMPORTANT:
// If you want a Pseg to loop, you need to use .repeat after it.
(
Pdef(\envelope, Pbind(
    // 290hz -> 19000hz -> 290hz over 4 beats + 4 beats
    filtf: Pseg(
        [290, 19000, 290],   // values
        [4, 4],              // times
        4,                   // envelope shape
    ).repeat,               
));

Pdef(\player, Pdef(\envelope) <> Pdef(\base)).play;
)

// Times can also be patterns!
// IMPORTANT: When using patterns for envelope durations, if you want the value to only
// be used once per segment, you need to make sure the pattern produces a single value.
// Hence: the final 1 in my Prand.
(
Pdef(\envelope, Pbind(
    // 290hz -> 19000hz -> 290hz over 4 beats + 4 beats
    filtf: Pseg(
        [290, 19000, 290],
        [Prand([3, 5, 1], 1), 1],    // times as random values        
        \exp,             
    ).repeat,
));

Pdef(\player, Pdef(\envelope) <> Pdef(\base)).play;
)

(
// In this example, I DO want my envelope value to keep producing values,
// this makes an infinitely evolving envelope.
// Final trick: using .plot after my Pseg will plot the envelope shape in a GUI,
// so you can visualize what its doing.
Pdef(\envelope, Pbind(
    noiseAmt: Pseg(
        [ Pexprand(0.01, 0.5) ],
        [ Prand([0.5, 1.5], inf) ],
    ),
    filtf: Pseg(
        [ Pwhite(80, 9000) ],
        [ Prand([1, 2, 1/2], inf) ],
        \exp,             
    ).plot.repeat,
));

Pdef(\player, Pdef(\envelope) <> Pdef(\base)).play;
)


// TECHNIQUE:
// Use Pseg to control the weights in a Pwnrand.
// This lets you turn up and down the likelihood of certain values over time.
(
(
    Pdef(\envelope, Pbind(
        filtf: Pwnrand.choose(
            Pwhite(200, 4000) -> 10,
            Pwhite(12000, 19000) -> Pseg([1, 15, 1], [30, 30]).repeat,
        ),
        
        attack: Pwnrand.choose(
            0.01 -> 10,
            0.6 -> Pseg([0.1, 1.0, 0.1], [30, 30]).repeat,
        ),
        
        release: Pwnrand.choose(
            0.2 -> 10,
            0.8 -> 4,
            3 -> Pseg([1, 8], [30]).repeat,  // slowly make long releases more likely
        ),
        
        octave: Pkey(\octave)
            + Pwnrand.choose(
                0 -> 10,
                3 -> Pseg([0, 4], [30]).repeat, // slowly make high octaves more likely
            ),
    ));
    
    Pdef(\player, Pdef(\envelope) <> Pdef(\base)).play;
)
