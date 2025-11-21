(
SynthDef(\resonantSnare, {
    var snare, sig, trig, fl, tempo, resMix, res, delay, delayMix;
    var comp, chord, warp, bend;
    
    trig = \tgate.tr(0);
    tempo = \tempo.kr(1);
    resMix = \resMix.kr(1);
    delayMix = \delayMix.kr(1);
    comp = \comp.kr(0);
    
    snare = AnalogSnareDrum.ar(
        trig,
        freq: \snareFreq.kr(20),
        accent: \accent.kr(0.1),
        tone: \tone.kr(0.5, spec:[0, 1]),
        decay: \decay.kr(0.1, spec:[0, 100]),
        snappy: \snappy.kr(0.5, spec:[0, 1])
    );
    // snare = LeakDC.ar(snare);
    // snare = snare * SinOsc.ar(\snareFreq.kr(20));
    // snare = snare + (
    // 	Amplitude.ar(snare)
    // 	* LPF.ar(Impulse.ar(
    // 		[50, 50]
    // 	), 100).sum
    // );
    
    res = resMix * snare;
    // snare = (1 - resMix) * snare;
    
    sig = snare + Resonator.ar(
        input: 		res,
        freq: 		\rfreq.kr(spec:[25.0,250.0]).lag(\flag.kr(0.01)) * [0, 0.05, 0.12, 0.32, 0.2].midiratio,
        position: 	\rposition.kr(0),
        resolution: 24,
        structure:	\rstructure.kr(0, spec:[0, 1]),
        brightness: \rbrightness.kr(0.2, spec:[0, 0.5]),
        damping: 	\rdamping.kr(spec:[0.2, 4])
    ).sum;
    
    comp = [0.45, 1, 1/50, 0.01, 0.2].blend(
        [0.85, 1, 1/10, 0.01, 0.09],
        comp
    );
    
    sig = \amp.kr(1) * Compander.ar(sig, sig, *comp);
    
    // Limiter
    sig = LockhartWavefolder.ar(sig, 7);
    // sig = SoftClipAmp8.ar(sig, 2.9);
    warp = \warp.kr(0.9) * 8;
    bend = LFDNoise3.ar(1).range(-23, 23).midiratio;
    8.do {
        |i|
        var inv = [-1, 1].rotate(i);
        sig = blend(
            sig,
            (inv[0] * sig) - (inv[1] * PitchShift.ar(
                sig, 
                LFDNoise3.kr(1/2).exprange(1, 1/32), 
                bend * LFDNoise3.ar(1/2).range(-0.2, 0.2).midiratio
            )),
            warp.linlin(i, i+1, 0, 1)
        )
    };
    
    sig = BandSplitter2.ar(
        sig, 200
    );
    
    sig[1] = sig[1] + (CombC.ar(delayMix * sig[1], 1, 1/80, 0.06));
    sig[1] = sig[1] - (FreqShift.ar(delayMix * sig[1], -0.1, 0.3));
    sig[1] = sig[1] + ((-30.dbamp * GVerb.ar(delayMix * sig[1], 12, 4, 0.6, drylevel:0)).sum);
    
    sig = HardCompress.ar(sig);
    
    sig[1] = sig[1] + (-16.dbamp * (delayMix * sig[1]).feed({
        |s|
        s = s - FreqShift.ar(s, -0.08, 0.3);
        HPF.ar(LPF.ar(s, 1500), 60) * -6.dbamp;
    }, [3, 5.02]/8/tempo));
    
    // sig = sig[1];
    sig = -12.dbamp * sig.sum;
    // DetectSilence.ar(sig, doneAction:2);
    
    sig = Pan2.ar(sig, \pan.kr(0).lag(0.02))[0];
    
    Out.ar(\out.kr(0), sig)
}).add;
)
