
(
Pdef(\additiveBase, Pbind(
    \instrument,        \additive,
    
    // === FREQUENCY MODULATION ===
    \freqMD,            0.02,           // pitch vibrato amount (0-2, 0=none, 1=semitone)
    \modMF,             4,              // LFO rate in Hz (0.01-20, slow to fast)
    // === HARMONIC STRUCTURE ===
    \inharmonicity,     0.1,            // stretch harmonics (0-1, 0=perfect, 1=very stretched)
    
    // === COMB FILTERING (creates formants/resonances) ===
    \combOffset,        0.05,           // comb filter offset (0-1)
    \combOffsetMD,      0,              // modulation of offset (0-2)
    \combDensity,       0.1,            // filter frequency spacing (0.1-1, low=wide peaks)
    \combDensityMD,     0,              // modulation of density (0-2)
    \combSkew,          0.5,            // asymmetry of filter curve (0.1-0.9, 0.5=symmetric)
    \combSkewMD,        0,              // modulation of skew (0-2)
    \combPeak,          2,              // filter resonance strength (1-10, 1=subtle, 10=extreme)
    \combPeakMD,        0,              // modulation of peak (0-2)
    
    // === SPECTRAL WARPING ===
    \warpSpec,          0.1,            // frequency warping amount (0-1, 0=natural, 1=extreme)
    \warpSpecMD,        0.2,              // modulation of warping (0-2)
    
    // === SPECTRAL SHAPING ===
    \tiltPerOctaveDb,   -4,             // high frequency rolloff (-12 to 0 dB/octave)
    
    // === OUTPUT ===
    \amp,               1,              // overall amplitude (0-1 or dB values)
    \shiftOct,          0,              // pitch shift in octaves (-2 to 2)
    
    // === SYNTHESIS PARAMETERS ===
    \phaseRand,         0.5,            // randomize oscillator phases (0-2π, 0=sync, 2π=random)
    \md,                0.2,            // master modulation depth (0-2, scales all *MD params)
));

Pdef(\add,
    Pbind(
        amp: 1,
        dur: 2,
        legato: Pwhite(1, 1.4),
        attack: 2,
        release: 5,
        
        scale: Scale.hexSus,
        degree: Pxrand([0, 4, -1, 2], inf),
        octave: Pwnrand.choose(3 -> 5, 5 -> 1),
        
        md: Pseg([Pwhite(0.01, 0.6)], [4]).repeat,
    ) <> Pdef(\additiveBase).durStep(2)
).play
)

