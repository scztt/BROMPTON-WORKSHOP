
// PKEY
//
// Pkey allows you to REFER to the value of a key already defined in your Pbind.
// It will return the value from the correspinding key most recently ABOVE the current key.
// It can also pull keys defined to the RIGHT of a <> (remember, right to left flow).

(
Pdef(\base, Pbind(
    instrument: 'additive',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
    
    vel: Pxrand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    filtf: Pseg([900, 12000, 900], [10, 10], \exp).repeat,
    
    scale: Scale.minorPentatonic,
    octave: 3,
    degree: Pseq([1, -2, 5, 1, -2], inf)
))
)

(
Pdef(\pkey, Pbind(
    dur: 1 / 8,
    octave: Pkey(\octave) + 2 // refers to the value of \octave coming from Pdef(\base)
) <> Pdef(\base)).play
)

(
Pdef(\pkey, Pbind(
    octave: Pkey(\octave) + 2, // refers to the value of \octave coming from Pdef(\base)
    octave: Pkey(\octave) + Prand([-1, 0, 1], inf), // refers to the \octave just before
) <> Pdef(\base)).play
)

// TECHNIQUE:
// Breaking complex keys into several lines
(
Pdef(\pkey, Pbind(
    degree: Pkey(\degree) + Prand([-2, 0, 0], inf),
    degree: Pkey(\degree) * Pseq([0, 0, 1, 1, 1, 1], inf)
) <> Pdef(\base)).play
)

// TECHNIQUE:
// Controlling several keys with one
// Remember: you can make whatever key names you want, as long as they aren't already
// synth parameters or "special" values.
(
Pdef(\pkey, Pbind(
    // Meta-key: mostly false, but sometimes true....
    pitchJump: Pwnrand([false, true], [9, 1]),
    
    // When it's true, we modify out input values to make a loooong
    // high note.
    vel:     Pkey(\vel)     * Pkey(\pitchJump).if(0.1, 1), 
    degree:  Pkey(\degree)  + Pkey(\pitchJump).if(22, 0),
    release: Pkey(\release) + Pkey(\pitchJump).if(6, 0),
    sustain: Pkey(\sustain) + Pkey(\pitchJump).if(1, 0),
    attack:  Pkey(\attack)  + Pkey(\pitchJump).if(6, 0),
    legato:  Pkey(\legato)  + Pkey(\pitchJump).if(8, 0),
) <> Pdef(\base)).play
)

// We can actually write this more efficiently!
// Rather than a bunch of Pifs, we just make ONE if that switches between two patterns.
// Our first pattern has our "pitchJump" modifications,
// and the second pattern just passes the events through with no change.
// Pid() is a "do nothing" pattern that just passes events through unchanged.
(
Pdef(\pkey, 
    Pkey(\pitchJump).if(
        // if true, do our "long slow high" note
        Pbind(
            vel:     Pkey(\vel)     * 0.1, 
            degree:  Pkey(\degree)  + 22,
            release: Pkey(\release) + 6,
            sustain: Pkey(\sustain) + 1,
            attack:  Pkey(\attack)  + 6,
            legato:  Pkey(\legato)  + 8,
        ),
        
        // otherwise, just pass the event through unchanged
        Pid()
    )
    <> Pbind(pitchJump: Pwnrand([false, true], [9, 1])) 
    <> Pdef(\base)
).play

)