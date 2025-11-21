// With a very simple Pwith trick, you can sequence Pdefs you've defined elsewhere.
// Here's the trick:
(
Pdef(\base, Pbind(
    instrument: 'additive',
    
    dur: 1,
    
    attack: Pexprand(0.001, 0.01),    
    release: 2,
    sustain: 0.1,
    
    vel: Prand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
));
)


(
Pdef(\a, Pbind(dur: 3/8, octave: 3));
Pdef(\b, Pbind(dur: 2/8, octave: 4));
Pdef(\c, Pbind(dur: 5/8, octave: 5));

Pdef(\withComposer, Pwith(
    Pbind(
        dur: 4,
        legato: 1,
        pattern: Pseq([\a, \b, \c, \b], inf)
    ),
    {
        // Outer event keys are accessible using ~envVar syntax.
        Pdef(~pattern) <> Pdef(\base)
    }
)).play
)

(
// In this version, the INNER pattern controls how long it plays.
// Repeat each a fixed number of times - then we go to the next pattern.
Pdef(\a, Pbind(dur: Pseq([3/8], 6), octave: 3));
Pdef(\b, Pbind(dur: Pseq([2/8], 6), octave: 4));
Pdef(\c, Pbind(dur: Pseq([4/8], 4), octave: 5));

Pdef(\withComposer, Pwith(
    Pbind(
        pattern: Pseq([\a, \b, \c, \b], inf),
        insert: true,
    ),
    {
        Pdef(~pattern) <> Pdef(\base)
    }
)).play
)

// THE EXPERIMENT:
// Take these two base patterns that define some different sounds / timbres for the
// additive synth. Tweak them as much as you want or even make new ones.

(
Pdef(\timbre1, Pbind(
    freqMD:            0.1,
    modMF:             0.5,
    inharmonicity:     Pseg([Pwhite(0.0, 0.2)], [Pwhite(2, 3)], repeats: inf), 
    combOffset:        Pseg([Pwhite(0.0, 0.2)], [Pwhite(0.1, 1)], repeats: inf),
    combOffsetMD:      0.3,
    combDensityMD:     0, 
) <> Pdef(\base));

Pdef(\timbre2, Pbind(
    freqMD:            0.1,
    modMF:             0.1,
    inharmonicity:     0,
    combOffsetMD:      0.5,
    combPeak:          1,
) <> Pdef(\base));

Pdef(\pattern1, Pbind(
    dur: Pwhite(0.5, 2),
    octave: 4,
    attack: 2, sustain: 2,
    
    degree: Pxrand([0, 2, -5, -1], inf),
    release: Pwhite(2, 4)
));

Pdef(\pattern2, Pbind(
    dur: Pwhite(0.04, 0.5),
    
    amp: 0.2,
    sustain: 0.05, 
    release: Pwhite(0.5, 2.2),
    
    octave: 6,
    strum: 1/16,
    degree: Ptuple([
        Pxrand([0, 2, -5, -1], inf),
        Pseq([0, -2, -1], inf).durStep(2)
    ]),    
));
)


(
Pdef(\player, Pwith(
    Pbind(
        dur: Pseq([4, 4, 2], inf), 
        legato: 2,
        timbre: Prand([\timbre1, \timbre2], inf),
        pattern: Pseq([\pattern1, \pattern1, \pattern2], inf),
    ),
    {
        Pdef(~pattern) <> Pdef(~timbre)
    }
)).play
)

(
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
    
    vel: Pxrand([0.6, 1.0, 0.9], inf),
    
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    
    crash: 1,
    push: 0.2,
    filtf: 12000,
    scale: Scale.aeolian,
    octave: 5,
    degree: Pseq([1, -2, 4, 2, -2], inf) + 0   
));

Pdef(\player, Pwith(
    Pbind(
        bassTrig: Pwnrand.choose(
            false -> 10,
            true -> 1,
        ),
        replace: false,
        crash: 0.2,
        release: 1.1,
        push: Pseg([0.0, 0.9, 0.0], [Pwhite(1, 8), Pwhite(1, 4)]).repeat,
        degree: Pkey(\degree) 
            + Pseq([0, -1, -4], inf).durStep(8) 
            + Pseq([0, 0, 3], inf).durStep(3/4)
    ) <> Pdef(\base),
    {
        if (~bassTrig) {
            Pbind(
                dur: Pseq([3/4], 3),
                octave: 3,
                sustain: 0.1,
                release: 6
            )
        }
    }
)).play
)