(
Require("../SynthDefs/*");
)

(
Pdef(\base, Pbind(
    instrument: 'additive',
    attack: 0, 
    curve: 4,
    scale: Scale.partch_o2,    
));
)

// EXAMPLE 1
(
Pdef(\rampPhrase, 
    Pbind(
        degree: Pkey(\degree),
        octave: Pseq([2, 5, 3, 4], inf),
        dur: Pseg([1/2, 1/16], [6], \exp),
        release: Pwnrand([0.4, 1, 2.5], [4, 1, 1]),
    ) <> Pdef(\base)
);

Pdef(\pattern,  
    Pwith(
        // INPUT PATTERN
        Pbind(
            dur: 4,
            legato: 1,
        ),
        
        // WITH PATTERN
        {
            Pdef(\rampPhrase)
        }
    )
).play;
)

// EXAMPLE 
// Q: What happens to the keys from the input events?
// A: You can access them with Pkey...
(
Pdef(\rampPhrase, 
    Pbind(
        degree: Pkey(\degree),
        octave: Pseq([2, 5, 3, 4], inf),
        dur: Pseg([1/2, 1/16], [6], \exp),
        release: Pwnrand.choose (
            0.4 -> 4,
            1 -> 1, 
            2.5 -> 1,
        ),
    ) <> Pdef(\base)
);

Pdef(\pattern,  
    Pwith(
        Pbind(
            dur: 4,
            legato: 1,
            degree: Pseq([0, 5, -3, 7], inf),
        ),
        {
            Pdef(\rampPhrase)
        }
    )
).play;
)


// If you wrap your Pdef contents in a function {}
// then you get keys from the outer pattern as arguments.
(
Pdef(\rampPhrase, {
    |degree, octave|
    Pbind(
        degree: degree,
        octave: octave + Pseq([0, 3, 1, 2], inf),
        dur: Pseg([1/2, 1/16], [6], \exp),
        release: Pwnrand.choose (
            0.4 -> 4,
            1 -> 1, 
            2.5 -> 1,
        ),
    ) <> Pdef(\base)
});

Pdef(\pattern,  
    Pwith(
        Pbind(
            dur: 4,
            legato: 1,
            degree: Pseq([0, 5, -3, 2], inf),
            octave: Pseq([2, 3], inf)
        ),
        {
            Pdef(\rampPhrase)
        }
    )
).play;
)


// If you want your inner pattern to play out all the way,
// rather than having its duration driven by the initial pattern,
// set ~insert=true inside the function.
// Careful: if your pattern runs infinitely then it will simply play forever and
// you'll never continue to the next event in your outer pattern.
(
Pdef(\rampPhrase, {
    |degree, octave|
    Pbind(
        degree: degree,
        octave: octave + Pseq([0, 3, 1, 2], inf),
        dur: Pseg([1/2, 1/16], [6], \exp),
        release: Pwnrand.choose (
            0.4 -> 4,
            1 -> 1, 
            2.5 -> 1,
        ),
    ) <> Pdef(\base)
});

Pdef(\pattern,  
    Pwith(
        Pbind(
            degree: Pseq([0, 5, -3, 2], inf),
            octave: Pseq([2, 3], inf)
        ),
        {
            ~insert = true; // rampPhrase plays all th way out.
            Pdef(\rampPhrase)
        }
    )
).play;
)

// You can make up your own keys in the outer pattern and then
// make modular patterns inside....
(
Pdef(\rampPhrase, {
    |dur, howFast, combOffset, octave, degree|
    Pbind(
        degree: degree + Pxrand([0, 2, -1, 1], inf).durStep(2),
        octave: octave + Pseq([0, 3, 1, 2], inf),
        
        dur: Pseg([1/2, 1/16], [dur], \exp) * howFast,
        
        combOffset: combOffset * Pseg([0.1, 0.5, 0.1], [dur/2, dur/2]),
        
        release: Pwnrand.choose (
            0.4 -> 4,
            1 -> 1, 
            2.5 -> 1,
        ),
    ) <> Pdef(\base)
});

Pdef(\pattern,  
    Pwith(
        Pbind(
            dur: Pshufpart([2, 4, 1, 6, 10], inf),
            legato: 1,
            
            howFast: Pseq([1, 0.5, 2], inf),
            octave: Prand([2, 3, 4], inf),
            degree: Pseq([0, 5, -3, 2], inf),
            combOffset: Pseq([0, 0.5, 1, 0.5], inf),
        ),
        {
            Pdef(\rampPhrase)
        }
    )
).play;
)