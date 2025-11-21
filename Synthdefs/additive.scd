


( // ADDITIVECOMB
SynthDef(\additive, {
    var numPartials = 48;
    var lfos, combOffset, combDensity, combPeak, combSkew, warpSpectrum, inharmonicity, freq, chain, sig, env, normalizedFreqs, warpedFreqs, warpedPhase, nyquist, fade, limiter, phase;
    var phaseRand, md, vel, attack, release;
    
    phaseRand = \phaseRand.ir(0.5);
    vel = \vel.kr(0.6);
    
    attack = \attack.kr(1);
    release = \release.kr(1);
    
    env = Env.adsr(
        attackTime: attack,
        decayTime: 0.3,
        sustainLevel: 0.7,
        releaseTime: release,
        curve: \curve.kr(4) * [2, -1, -1]
    ).kr(
        gate: \gate.kr(1),
        doneAction: Done.freeSelf,
    );
    
    // LFOs for modulation
    lfos = 6.collect { |i|
        SinOsc.kr(\modMF.kr(4), Rand(0, phaseRand))
    };
    
    md = \md.kr(0.2);
    md = md * (env * vel * 8).midiratio;
    
    // Parameter Modulation
    combOffset = \combOffset.kr(0.05) * (2 ** (lfos[0] * md * \combOffsetMD.kr(0)));
    combDensity = \combDensity.kr(0.1) * (2 ** (lfos[1] * md *  \combDensityMD.kr(0)));
    combPeak = \combPeak.kr(2) * (2 ** (lfos[2] * md *  \combPeakMD.kr(0)));
    combSkew = \combSkew.kr(0.5) * (2 ** (lfos[3] * md *  \combSkewMD.kr(0)));
    warpSpectrum = \warpSpec.kr(0.1) * (2 ** (lfos[4] * md *  \warpSpecMD.kr(0)));
    freq = \freq.kr(60).lag(\freqLag.kr(0.2)) * (2 ** (lfos[5] * md * \freqMD.kr(0.02)));
    inharmonicity = \inharmonicity.kr(0.1).lincurve(0, 1, 0, 1, 8);
    
    // Harmonic Structure
    chain = (
        freq: freq,
        numPartials: numPartials,
        ratios: (1..numPartials),
        amps: 1 ! numPartials
    );
    
    chain[\freqs] = chain[\freq] * chain[\ratios] * (1 + (inharmonicity * chain[\ratios].squared)).sqrt;
    
    // Warp Frequencies
    normalizedFreqs = (chain[\freqs] / chain[\freqs][numPartials - 1]).clip(0, 1);
    warpedFreqs = Select.kr(normalizedFreqs > (1 - warpSpectrum), [
        0.5 * normalizedFreqs / (1 - warpSpectrum),
        0.5 * (1 + ((normalizedFreqs - (1 - warpSpectrum)) / warpSpectrum))
    ]);
    chain[\freqs] = warpedFreqs * chain[\freqs][numPartials - 1];
    
    // Spectral Tilt
    chain[\amps] = chain[\amps] * (chain[\ratios].log2 * \tiltPerOctaveDb.kr(-3)).dbamp;
    
    // Comb Filtering
    phase = (chain[\freqs].log2 - chain[\freq].log2) * combDensity - combOffset;
    warpedPhase = Select.kr(phase.wrap(0, 1) > combSkew, [
        0.5 * phase / combSkew,
        0.5 * (1 + ((phase - combSkew) / (1 - combSkew)))
    ]);
    chain[\amps] = chain[\amps] * exp(combPeak.abs * (cos(warpedPhase * 2pi) - 1)) * 0.5 * (1 + cos(warpedPhase * 2pi));
    
    // Limiter
    nyquist = SampleRate.ir / 2 - 2000;
    fade = nyquist - 1000;
    limiter = 1 - ((chain[\freqs].clip(fade, nyquist) - fade) * 0.001);
    chain[\amps] = chain[\amps] * limiter;
    
    // Oscillators
    sig = SinOsc.ar(
        freq: chain[\freqs],
        phase: { Rand(0, phaseRand) } ! numPartials,
        mul: chain[\amps]
    ).sum;
    
    // Output Processing
    sig = sig * -15.dbamp;
    sig = sig * \amp.kr(-5) * vel.linlin(0, 1, -6, 0).dbamp;
    
    sig = sig * env;
    sig = Limiter.ar(sig);
    sig = LeakDC.ar(sig);
    
    sig = PanAz.ar(4, sig, \pan.ar(0), width: 4);
    sig = HPF.ar(sig, 200) ++ [
        LPF.ar(sig, 120)
    ];
    DetectSilence.ar(sig, doneAction:2);
    
    Out.ar(\out.kr(0), -6.dbamp * sig);
}).add;
)
