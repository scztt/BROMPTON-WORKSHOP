( // _SETUP_
Require("../SynthDefs/*")
)

// NEW CLASSES/METHODS:
// Ptuple([pattern1, pattern2, ...])  - combine patterns into arrays/chords
// Pclump(count, pattern)              - group pattern values into arrays
// pattern.flatten                     - flatten arrays back to individual events

// How can I play chords?
// Ptuple, Pclump, Pflatten

// If any values in an Event are arrays, then you will play multiple notes / events.
// (degree: [0, 2], amp: 0.1) -> [(degree: 0, amp: 0.1), (degree: 2, amp: 0.1)]
// 
// You can make arrays out of separate patterns using Ptuple:
// Ptuple([pattern_a, pattern_b, pattern_c]) -> [a1, b1, c1], [a2, b2, c2], [a3, b3, c3] ...
//
// \strum
// the \strum key causes events in a chord to be spaced apart in time...
//
// Pclump(count, pattern)
// Pclump takes `count` items from an event stream and combines the into one event (e.g. a chord)
// Pclump(3, pattern) will grab 3 items from `pattern` and turn them into an array


(
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
    
    vel: Pxrand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    filtf: Pseg([3690, 19000, 3690], [4, 4], \exp).repeat,
    
    crash: 0.5,
    push: 0.8,
    scale: Scale.hexSus,
    octave: 3,
    degree: Pseq([1, -4, 3], inf).durStep(2 * Pxrand([3/8, 5/8, 1], inf)) + 0   
))
)

(
Pdef(\chords, Pbind(
    degree: Pkey(\degree) + Ptuple([
        0,
        Prand([2, 3], inf)
    ])
) <> Pdef(\base)).play
)


(
Pdef(\chords, Pbind(
    strum: 1/4,
    degree: Pkey(\degree) 
        + Ptuple([
            0,
            Prand([3, 2], inf),
        ])
) <> Pdef(\base)).play
)

// You can use Pclump to build arrays / chords from a stream of notes.
// Here, we use Pclump to grab several notes from the degree stream
// This takes a strea like 1, 2, 3, 4, 5 and turns it into [1, 2], [3, 4], [5, 6] ...
(
Pdef(\chords, Pbind(
    octave: 3,
    count: Pwnrand([1, 3], [5, 1]),
    
    degree: Pkey(\degree)
        + Pclump(
            Pkey(\count),
            Pxrand([0, 2, -5, -1], inf),
        ),
    
    release: Pkey(\release) 
        + Pclump(
            Pkey(\count),
            Pwnrand.choose(
                0 -> 5,
                5 -> 1
            )
        ),
) <> Pdef(\base)).play       
)

// The reverse of this is .flatten, which flattens out arrays into
// individual events.
// So a stream like [1, 2], [3, 4], [5, 6] ... becomes 1, 2, 3, 4, 5, 6 ...

(
Pdef(\chords, Pbind(
    strum: 1/3,
    degree: Pkey(\degree) 
        + Ptuple([
            0,
            Prand([3, 2], inf),
        ]).flatten
) <> Pdef(\base)).play
)