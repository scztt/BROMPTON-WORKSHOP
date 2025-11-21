// Helpful strategies for larger-scale composition in SuperCollider

// == LIVE PERFORMANCE STRATEGIES ==
//
// STRATEGY #1: 
// 
// Create variations on a pattern, and then play by switching out the variations.
// Choose two or three "levels" at which you will change patterns (e.g. pitch, rhythm, timbre).
//
// Use MIDIdef to map buttons on your MIDI controllers to set the state of your Pdefs for e.g.
// different parts of a composition.
(
Pdef(\notes1, ...);
Pdef(\notes2, ...);
Pdef(\notes3, ...);
Pdef(\notes4, ...);

Pdef(\notes, Pdef(\notes1)); // swap these at performance time!

Pdef(\player, Pdef(\notes) <> Pdef(\synthBase));
)


// STRATEGY #2: 
// 
// Use an external MIDI controller to set pattern parameters live.
// You can set default keys for a Pdef with the .set() method. Use these
// to set MIDI CC values from your controller, and then compose this Pdef
// with your main patterns and reference the cc values with Pkey().
// 
// You can rescale your MIDI values to 0..1 range and then use linlin or linexp
// in your pattern to rescale to the desired range.
(
// We can just use an empty Pbind, all our keys we will set using the .set method.
Pdef(\controls, Pbind());

// Set default values for 127 MIDI CC's
127.do {
    |i|
    Pdef(\controls).set(i, 0);
};

MIDIdef.cc(\patternControls, {
    |val, num, chan, src|
    Pdef(\controls)[num] = val / 127.0; // rescale to 0..1
});

Pdef(\sequence,
    Pbind(
        legato: Pkey(1).linlin(0, 1, 0.1, 1.0), // now you can access CC 1 value with Pkey
    ) 
    <> Pdef(\controls)
).play;
)

// STRATEGY #3:
//
// If you're using SuperCollider for supplemental live effects processing,
// map each section / song / etc of your performance to a Pdef, and then using
// the "container" strategy to hot-swap between them live.
// 
// Put a nice release envelope on your effects chain and you'll have smooth transitions.
// Use Ppar to run multiple things in parallel if needed.
// For effects, use Pmono to create a single monophonic synth.
(
Pdef(\silence);
Pdef(\part1, ...); // e.g. reverb-heavy effects
Pdef(\part2, ...); // e.g. delay-heavy effects
Pdef(\part3, ...); // e.g. glitchy effects

Pdef(\player, Pdef(\silence)); // swap these at performance time!
)

// STRATEGY #4:
// 
// Use a big Ppar with everything you need. Events will not play if 
// ANY key has the value \rest - you can set a \rest key using Pdef().set
// to enable / disable each synth.
// 
// Each pattern is actually still running, so they will all say in sync
// and keep state.
// 
// Patterns dont consume much CPU resources, so you can probably play every part of your
// piece at once and simply mute/unmute them as needed.
(
Pdef(\player, Ppar([
    Pdef(\part1).set(\rest, \rest),
    Pdef(\part2).set(\rest, \rest),
    Pdef(\part3).set(\rest, \rest),
])).play;

Pdef(\part1).set(\rest, nil); // remove \rest key, so this plays
Pdef(\part1).set(\rest, \rest); // set back to \rest, so it stops
)


// == COMPOSITION STRATEGIES ==

// STRATEGY #1: 
//
// Create coherent musical phrases, and get a feel for what parameter variations on them work well.
// Choose 3-5 meta-parameters to vary your pattern (e.g. root note, scale, rhythm type, timbre)
// and then use an outer \pattern pattern to control these.
// Remember: outer pattern keys are passed to the inner pattern as function arguments!
//
// IMPORTANT: The outer pattern controls the duration of the inner pattern! This is best if you
// want top-down control of phrase length.

(
Pdef(\phrase1, {
    |param1, param2, param3|
    Pbind(
        degree: param1 + Pseq([0, 2, 4, 5], inf),
        ....
    )
});

Pdef(\phrasePlayer, Pbind(
    type: pattern,
    dur: 8,
    pattern: \phrase1
));
)

// STRATEGY #2:
// 
// Use Pseq of Pdefs to create larger-scale structures.
// Each Pdef can be a phrase, a section, etc.
// This lets you work on smaller parts, and then paste them together to get your overall piece.
//
// Unlike the phrase technique, this lets individual patterns play as long as they want,
// so you don't have top-down control of phrase length (though you can use .finDur to limit them if needed).

(
Pdef(\section1, Pbind( ... ));
Pdef(\section2, Pbind( ... ));
Pdef(\section3, Pbind( ... )); 

Pdef(\fullPiece, Pseq([
    Pdef(\section1),
    Pdef(\section2),
    Pdef(\section3),
], inf));
)

// STRATEGY #3:
// Use program change events to trigger Pdef setups from your DAW or MIDI controller.
// Ableton allows you attach program change MIDI messages to clips. You can recieve these
// message in SuperCollider with MIDIdef.program, and then set your Pdefs accordingly.
// 
// You can use this for Synths OR Effects chains in SC.
// 
// Note that SuperCollider supports Ableton link via the LinkClock class, which you can
// use to play your Pdefs - this will keep them in sync with Ableton.
(
MIDIdef.program(\setupPatterns, {
    |num, chan, src|
    switch(num,
        0, { Pdef(\currentPattern, Pdef(\pattern1)); },
        1, { Pdef(\currentPattern, Pdef(\pattern2)); },
        2, { Pdef(\currentPattern, Pdef(\pattern3)); },
    );
});

~link = LinkClock(1);
Pdef(\currentPattern).play(~link);
)


// == OTHER TIPS AND TRICKS ==
//
// ***
// Complexity accumulates FAST with patterns. Consider using more simple patterns,
// but switching between them or sequencing them in complex ways. 
//
//
// ***
// Use the timingOffset key to add micro-timing variations to your patterns.
// Or, use it to add rhythmic complexity that is still on-grid in the long run.
// The timingOffset key can be negative, which lets you place events in negative time!
// You can only go as far back as your \latency parameter, but if you set a high latency
// then you have a lot of flexibility. Sometimes it's easier to express complex rhythmic
// structures as simply durations with timing offsets, rather than complex dur patterns.
(
Pdef(\base, Pbind(
    instrument: 'epiano',
    latency: 1, // max 4 beats back in time....
    dur: 3 / 16,
    amp: 1,
    
    octave: 2,
    degree: Ptuple([
        Pseg([Pwhite(0, 0.6)], [4]).repeat,
        Pseg([Pwhite(0, 0.6)], [4]).repeat,
    ]) 
    + Pseq([0, 2, 1], inf).durStep(8),
    
    vel: Ptuple([
        Pwhite(0.1, 1.0),
        Pwhite(0.1, 1.0),
    ]),
    
    attack: Pwnrand.choose(0.005 -> 5, 0.2 -> 1, 0.5 -> 1),
    sustain: Pkey(\attack), // make sure we hold our note long enough for the long attacks...
    release: 1,
    timingOffset: 0 - Pkey(\attack),
)).play
)


// ***
// Use a "trigger" keys with Pmaybe to trigger phrases off of a base pattern.
// This lets you have a base pattern running, and then occasionally layer embellishments on it.
// 
(
Pdef(\base, Pbind(
    instrument: 'epiano',
    latency: 1,
    dur: 3 / 16,
    
    amp: 1,
    pan: 0.3 * [-1, 1],
    
    octave: 2,
    degree: 
        Ptuple([
            Pseg([Pwhite(0, 0.5)], [4]).repeat,
            Pseg([Pwhite(0, 0.5)], [4]).repeat,
        ]) 
        + Pseq([0, 2, 1], inf).durStep(8)
        + Ptuple([
            Pwnrand.choose(0 -> 12, 9 -> 1),
            Pwnrand.choose(0 -> 12, 8 -> 1),
        ]),
    
    vel: Ptuple([
        Pwhite(0.1, 1.0),
        Pwhite(0.1, 1.0),
    ]),
    
    filtf: 19000,
    attack: Pwnrand.choose(0.005 -> 5, 0.3 -> 1, 0.5 -> 1),
    sustain: Pkey(\attack),
    sustainLevel: 0.1,
    curve: 6,
    release: Pwhite(0.7, 1.7),
    timingOffset: 0 - Pkey(\attack),
    
    // trigger embellishment once in a while
    embellish: Pwnrand([false, true], [15, 1])
));

Pdef(\embellishment, {
    |octave, degree|
    Pbind(
        instrument: 'epiano',
        dur: 5,
        amp: 0.06,
        filtf: 320,
        octave: octave + [4, 5].choose,
        degree: degree + Pseq([2, 0]),
        sustain: 8,
        sustainLevel: 1,
        retrig: 1,
        attack: 4, 
        curve: 0,
        pluckCoef: 0.4,
        release: 8
    )
});


Pdef(\player, 
    Ppar([
        // pass based events forward
        Pid(),
        
        Pmaybe(
            Pkey(\embellish), // if embellish is true...
            Pbind(type: \pattern, pattern: \embellishment, sustain: 16) // play a pattern
        )
    ]) 
    <> Pdef(\base)
).play;
)

