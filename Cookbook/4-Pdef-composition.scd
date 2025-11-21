// === Composition ===
//
// "Composition" in a computer science sense means combining 
// functions or behaviors in predictable ways. Usually this 
// just means e.g. **making a new function by passing the output
// of one to the input of another**.
// 
// You can compose `Pdefs`, which will help build your compositional language.
//
// The syntax for composition is:
//    Pdef(\left) <> Pdef(\right)
// This produces a new pattern out of these two.
// You can chain mutiple:
//   Pdef(\a) <> Pdef(\b) <> Pdef(\c)
// 
// If the right-hand pattern produces an event like:
//   (degree: 2, octave: 3, dur: 0.5)
// and the left-hand pattern produces:
//   (filtf: 12000, dur: 0.25)
// you get: 
//   (filtf: 12000, dur: 0.25) <> (degree: 2, octave: 3, dur: 0.5)
//    ==> (filtf: 12000, degree: 2, octave: 3, dur: 0.25)


( // Base pattern
Pdef(\base, Pbind(
    instrument: 'epiano',
    dur: 1 / 8,
    
    attack: Pexprand(0.01, 0.05),    
    release: 0.6,
    
    vel: Prand([0.6, 1.0, 0.9], inf),
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    filtf: Pseq([690, 19000, 690, 3000], inf),
    
    scale: Scale.mixolydian
))
)


// The <> operator === composes === two pdefs together.
// An event is pulled from the left-hand and right-hand pattern. These events are merged together,
// with the **left-hand pattern** taking precedence: you can think of the flow as right-to-left.
( 
Pdef(\notes, Pbind(            
    octave: 3,
    degree: Pseq([1, -2, 3, 1, -2], inf) + 0   
));

Pdef(\composed, Pdef(\notes) <> Pdef(\base)).play;
)

// This allows you to break up your patterns into meaningful parts, 
// and then recombine them in flexible ways.


// TECHNIQUE: Live-updatable composition
// Changed Pdefs will live-update as they are playing.
(
Pdef(\notes, Pbind(            
    octave: Pshufpart([2, 2, 2, 2, 4], inf),
    degree: Pseq([1, -2, 2, 1, -2], inf) + 1  
))
)


// Pdefs can be assigned into other Pdefs.
// So, you can use a "container" Pdef and then change whats inside of it.
(
Pdef(\notes1, Pbind(
    octave: 2,
    degree: Pseq([1, -2, 2, 1, -2], inf) + 0   
));

Pdef(\notes2, Pbind(
    octave: Pwnrand.choose(2 -> 4, 3 -> 1, 4 -> 1),
    degree: Pseq([1, -2, 2, 1, -2], inf) + 1 
));

Pdef(\notes, Pdef(\notes1));

Pdef(\player, Pdef(\notes) <> Pdef(\base)).play;
)

(
// Now you can switch between different note patterns
Pdef(\notes, Pdef(\notes2));
)


// Think about how you can split different "layers" of your patterns into separate Pdefs
// and then recombine them in flexible ways.
(
Pdef(\base, Pbind(
    instrument: 'epiano',
));

Pdef(\notes, Pbind(
    octave: Pwnrand.choose(2 -> 4, 3 -> 1, 4 -> 1),
    degree: Pseq([1, -2, 2, 1, -2], inf) + 0   
));

Pdef(\timing, Pbind(
    dur: 1 / 8,
    
    attack: Pexprand(0.001, 0.05),    
    release: 0.6,
));

Pdef(\timingLongRelease, Pbind(
    dur: 1 / 8,
    
    attack: 0.05,
    sustain: 0.05,
    release: Pwnrand.choose(
        Pexprand(0.1, 0.7) -> 10,
        5 -> 1,
    ).pullOne,
));

Pdef(\timbre, Pbind(
    vel: Prand([0.6, 1.0, 0.9], inf),
    amp: Pseq([1, 0.2, 0.7, 0.5], inf),
    filtf: Pseq([9690, 19000, 690, 3000], inf),
));

Pdef(\player, 
    Pdef(\base)
        <> Pdef(\timbre)
        <> Pdef(\notes)
        <> Pdef(\timing)
).play;
)

