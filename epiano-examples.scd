
// EPIANO SYNTHDEF PARAMETERS - Interactive Examples
//

(
Require("epiano");
Pdef(\epianoDemo, Pbind(
    \instrument, \epiano,
    \dur, 1/2,
    \degree, Pseq([0, 1, 3, 5, 4, 2], inf),
    \octave, 4,
    
    // [basic sound control]
    \vel, 0.75,           // 0..1 velocity - affects timbre, brightness, and dynamics
    \crash, 1,            // 0..4+ intensity multiplier (default: 1) - try 0.2 or 3!
    \amp, 1,              // overall amplitude multiplier (default: 1)
    \pan, 0,              // -1..1 stereo position (default: 0) - try -0.7 or 0.7!
    
    // [pitch & tuning]  
    \retrig, 0,           // 0+ retrigger rate for pitch variation effects - try 4!
    
    // [timing & envelope]
    \attack, 0.01,        // attack time in seconds (default: 0.01) - try 1.0!
    \sustain, 1,          // note duration in beats (default: 1) 
    \release, 1,          // release time in seconds (default: 1) - try 4!
    \sustainLevel, 0.5,   // sustain level 0..1 (default: 1) - try 0.3!
    
    // [timbre & character]
    \filtf, 9000,         // filter cutoff frequency in Hz (default: 1000) - try 200 or 8000!
    \noiseAmt, 0.05,      // 0..1 amount of noise/grit (default: 0.05) - try 0.5!
    \vibScale, 0.1,       // 0..1 vibrato amount (default: 0.1) - try 0.8!
    \lfoSpeed, 6.1,       // vibrato speed in Hz (default: 6.1) - try 0.5 or 20!
    \lfoScale, 0.1,       // LFO depth multiplier (default: 0.1) - try 2.0!
    \ctl6Offset, 100.1,   // affects timbre of low operator (default: 100.1)
)).play
)

