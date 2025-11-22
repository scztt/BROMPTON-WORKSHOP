// ===  NEW CLASSES/METHODS: === 
// Prand([values], repeats)                     - random selection with repeats
// Pshufpart([values], repeats)                 - shuffled order, no close repeats  
// Pwnrand([values], [weights], repeats)        - weighted random selection
// Pwnrand.choose(value -> weight, ...)         - weighted random with cleaner syntax
// Pwhite(lo, hi)                               - white noise random numbers
// Pexprand(lo, hi)                             - exponential random numbers

// === Prand === 
// pulls items from a list randomly (with repeats)

(
Require("../SynthDefs/*");
)

( // 1. Simple Prand
Pdef(\prand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    octave: 3,
    degree: Prand([1, -2, 2, 1, -2], inf),    
)).play;
)



// === Pshufpart === 
// same as Prand, but will play every value before repeating,
// and tries not to repeat values too close together.
(
Pdef(\pshufpart, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    octave: 3,
    degree: Pshufpart([-3, 1, 2, 4, 7], inf),    
)).play;
)



// === Pwnrand === 
// Pull from a list, with a *weight* attached to each item, that controls how often it appears.
// Weights are === relative ===, so [1, 10] is the same as [0.1, 1].
(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    octave: Pwnrand(
        [2, 3],
        [2, 1],
    ),
    degree: Pseq([1, -2, 2, 1, -2], inf),    
)).play;
)



// You can use Pwnrand.choose for a slightly more readable syntax
// In this case, you have: value -> weight
(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    octave: Pwnrand.choose(
        2 -> 2,    // 2 with a weight of 2
        3 -> 1,    // 3 with a weight of 1
    ),
    degree: Pseq([1, -2, 2, 1, -2], inf),    
)).play;    
)



(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    amp: Pwhite(0.1, 0.8),
    octave: Pwnrand.choose(
        2 -> 2,    // 2 with a weight of 2
        3 -> 1,    // 3 with a weight of 1
    ),
    degree: Pseq([1, -2, 2, 1, -2], inf),    
)).play;    
)


(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    release: Pexprand(1/2, 8),
    amp: Pwhite(0.1, 0.8),
    octave: Pwnrand.choose(
        2 -> 2,    // 2 with a weight of 2
        3 -> 1,    // 3 with a weight of 1
    ),
    degree: Pseq([1, -2, 2, 1, -2], inf),    
)).play;    
)


(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/4,
    
    attack: Pwnrand.choose(
        0.01 -> 4,
        0.5 -> 1,
    ),
    
    octave: Pwnrand.choose(
        2 -> 2,
        3 -> 1,
    ),
    
    legato: Pwnrand.choose(
        1 -> 10,
        6 -> 1,
    )
)).play;
)


// Values can also be patterns themselves!
// If the value is a pattern, the pattern will play ALL THE WAY THROUGH
// before another random one is chosen
(
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    dur: 1/8,
    
    attack: Pwnrand.choose(
        0.01 -> 5,
        0.5 -> 1
    ),
    
    legato: Pwnrand.choose(
        1 -> 10,
        6 -> 1
    ),
    
    octave: 3,
    degree: Pwnrand.choose(
        (Pseq([7, -2, 3, 1, -5])) -> 1,
        (Pseq([18, 11, 6, 5, 4, -3]) - 5) -> 1
    )
)).play;
)



// If you want to pull just one value from a pattern instead of playing it out,
// you can attach .pullOne to the end of the Pwnrand.
// Remember, you have to add back "inf" otherwise the pattern will only play one
// time through and then end.

( // pullOne
Pdef(\pwnrand, Pbind(
    instrument: 'epiano',
    scale: Scale.partch_o2,
    
    crash: Pexprand(0.5, 2.0), // timbre changes
    
    dur: Pwnrand.choose(
        1/8 -> 20,
        3/8 -> 5,
        1 -> 2
    ),
    vel: 1,
    
    attack: Pwnrand.choose(
        0.01 -> 5,
        0.5 -> 1
    ),
    release: 1,
    
    legato: Pwnrand.choose(
        1 -> 10,
        6 -> 1
    ),
    
    octave: 3,
    degree: Pwnrand.choose(
        (Pseq([7, -2, 3, 1, -5], inf)) -> 1,
        (Pseq([18, 11, 6, 5, 4, -3], inf) - 5) -> 1
    ).pullOne
)).play;
)

