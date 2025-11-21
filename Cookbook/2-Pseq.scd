////////////////////////////////////////////////////////////////////////
// 2. Pseq - Sequential patterns
////////////////////////////////////////////////////////////////////////

( // Basic sequence
Pdef(\myPattern, Pbind(
    instrument: \epiano,
    octave: 3,
    dur: 1/4,
    degree: Pseq([0, -2, 1, 5], inf),
)).play;
)

( // Concatenating sequences with ++
Pdef(\myPattern, Pbind(
    instrument: \epiano,
    octave: 3,
    degree: Pseq([0, -2, 1]) ++ Pseq([-2, 3], inf),
    dur: 1/4
)).play;
)


( // Math works on all patterns
Pdef(\myPattern, Pbind(
    instrument: \epiano,
    octave: 2,
    vel: Pseq([1, 0.8, 0.7, 0.3, 0.5], inf),
    degree: Pseq([0, 0, 0, 2, 2], inf) + Pseq([0, 4], inf) - 1,
    dur: 1/8
)).play;
)
