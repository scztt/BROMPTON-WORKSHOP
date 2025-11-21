// === 1 ===
// Take this base pattern, and embellish it however you want.

( // Base pattern
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: Pxrand([1, 1, 2], inf) * (1/4),
    
    attack: Pwnrand.choose (
        0.01 -> 5,
        2 -> 5
    ),
    
    release: Pwnrand.choose (
        1 -> 4,
        8 -> 1,
    ),
    
    vel: 0.7,
    amp: 0.7,
    filtf: 7000,
    crash: 1.5,
    
    scale: Scale.mixolydian,
    octave: 3,
    degree: Pshufpart([0, 0, 0, 6, 3, -1, -1], inf)
)).play
)

// === 2 ===
// Now, make three or four patterns that you can compose together with the base pattern
// to make variations. Try to see how far you can mutate the base pattern
// by only overriding three or four keys....
(
Pdef(\variation1, Pbind(
    octave: Pwnrand.choose (
        3 -> 10,
        5 -> 1,
        7 -> 1,
    )
) <> Pdef(\base)).play;

// ...
)

// === 3 ===
// Try playing your variations live by defining a \player Pdef
// and then swapping your variations out.
(
Pdef(\player, Pdef(\variation1)).play
)

// === 4 ===
// Try creating two different patterns that define \dur only.
// Layer these on top of your variations to see what you can come up with.
(
Pdef(\durVariationFastSteps, Pbind(
    \dur, 1/8,
));

Pdef(\player, Pdef(\durVariationFastSteps) <> Pdef(\variation1)).play;

)
