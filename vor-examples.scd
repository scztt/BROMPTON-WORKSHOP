// VOR SYNTHDEF PARAMETERS - Interactive Examples
//

(
Require("Synthdefs/vor-synthdef");
Pdef(\vorDemo, Pbind(
    \instrument, \vorsynth,
    \dur, 1/2,
    \degree, Pseq([0, 1, 3, 5, 4, 2], inf),
    \octave, 4,
    
    // [basic sound control]
    \vel, 0.8,            // 0..1 velocity - affects timbre, resonance, and filter response
    \amp, 1,              // overall amplitude multiplier (default: 1)
    
    // [timing & envelope]
    \attack, 0.01,        // attack time in seconds (default: 0.01) - try 0.5!
    \delay, 0.1,          // decay time in seconds (default: 0.1) - try 1.0!
    \sustainLevel, 0.07,  // sustain level 0..1 (default: 0.07) - try 0.3!
    \release, 2,          // release time in seconds (default: 2) - try 6!
    \curve, 4,            // envelope curve shape (default: 4) - try -2 or 8!
    \sustain, 1,          // note duration in beats (default: 1)
    
    // [frequency & filtering]
    \filtf, 12000,        // filter cutoff frequency in Hz (default: 12000) - try 3000 or 20000!
    \noiseLPF, 300,       // noise lowpass filter in Hz (default: 300) - try 100 or 1000!
    
    // [character & modulation]
    \warp, 0.1,           // frequency offset variation (default: 0.1) - try 0.5 for detuning!
    \pluckCoef, 0.39,     // pluck damping coefficient 0..1 (default: 0.39) - try 0.1 or 0.8!
    
    // [gate control]
    \gate, 1,             // gate control for envelope (1 = on, 0 = release)
)).play
)
