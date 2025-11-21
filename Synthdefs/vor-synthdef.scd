(
SynthDef(\vorsynth, {
    var freq, vel, partials, amps, res, noise, sig, env, feed, freqOffset, sigLo, sigHi, rearrangeIndices,
        spread, filtf;
    
    freq = \freq.kr(100);
    vel = \vel.kr(0.8);
    filtf = \filtf.kr(12000);
    
    env = Env.adsr(
        attackTime: \attack.kr(0.01),
        decayTime: \delay.kr(0.1),
        sustainLevel: \sustainLevel.kr(0.07),
        releaseTime: \release.kr(2),
        curve: \curve.kr(4) * [2, -1, -1] 
    ).kr(
        gate:\gate.kr(1)
    );
    
    noise = blend(
        (1 + Dust.ar(1500) ! 2) + (0.2 * PinkNoise.ar),
        (1 + Dust.ar(1500) ! 2) + (0.3 * ClipNoise.ar),
        env * vel
    );
    noise = \amp.kr(1) * noise;
    noise = noise * LFSaw.ar(4.collect { freq + Rand(0, 1) }).sum.range(1 - (vel * -3.dbamp * env), 1);
    noise = BLowPass4.ar(
        noise,
        vel.linexp(0, 1, 5200, filtf),
        0.9
    );
    3.do {
        noise = BPeakEQ.ar(
            noise,
            Env([ExpRand(200, 16000), ExpRand(200, 16000)], [\sustain.kr(1)/2])
                .ar(gate:1),
            0.8,
            2
        )
    };
    noise = BHiPass.ar(
        noise,
        Env([14000, 400], [0.01], \exp).ar(gate:1),
        0.9
    );
    noise = noise * env;
    // noise = noise + Klank.ar(
    //     `[
    //         [1, 3, 5, 7, 9] * (Rand(-0.2, 0.2) ! 5).midiratio,
    //         Array.geom(5, 1, 0.7),
    //         Array.geom(5, 1, 0.6),
    //     ],
    //     decayscale: vel.linexp(0, 1, 0.4, 2),
    //     freqscale: freq * 2,
    //     freqoffset: Rand(-0.2, 0.2),
    //     input: -60.dbamp * noise,
    // );
    
    feed = LocalIn.ar(2).sum;
    feed = DelayC.ar(feed, 1, 1/16);
    feed = feed * env;
    feed = feed.tanh;
    feed = -5.dbamp * feed;
    feed = feed - FreqShift.ar(feed, SinOsc.kr(1/10, Rand(-1, 1)).range(-16.1, -3.1), 0.1);
    feed = LPF.ar(feed, \noiseLPF.kr(300, spec:ControlSpec(60, 6000, \exp)));
    feed = LeakDC.ar(feed);
    feed = Compander.ar(feed, feed, 0.3, 1, 1/5);
    
    noise = noise + feed;
    
    partials = 1 + (1 * [0,  1,   2,   3,   4,   5,   6,   7,  8,   9,   12.5, 13.1]);
    amps =              [0,  1,   2,   4,   6,   9,   10,  12,  14,  12,  10,   10].neg.dbamp;
    res =               12.geom(1, 0.96);
    
    partials = partials + SinOsc.kr(1/10, Rand(-1, 1)).range(-0.01, 0.01);
    rearrangeIndices = [11, 9, 7, 5, 3, 1, 2, 4, 6, 8, 10];
    partials = partials.atAll(rearrangeIndices).postln;
    amps = amps.atAll(rearrangeIndices);
    
    freqOffset = \warp.kr(0.1) * Rand(-1.0, 1.0);
    
    sig = DynKlank.ar(
        `[partials, amps, res],
        input: noise,
        freqscale: freq,
        freqoffset:[
            Rand(freqOffset.neg, freqOffset),
            Rand(freqOffset.neg, freqOffset),
        ],
        decayscale: vel.linexp(0, 1, 3, 12)
    );
    noise = LeakDC.ar(noise);
    sig = partials.size.collect {
        |i|
        Env([1, 1, 0], [0.2, 0.8], releaseNode: 1).kr(
            timeScale: \sustain.kr + \release.kr,
            gate: \gate.kr(1)
        ) 
        * Pluck.ar(
            noise.wrapAt(i), ClipNoise.ar,
            1/8,
            (freq * partials[i] + freqOffset).reciprocal,
            res[i] * vel.linlin(0, 1, 8, 22) * [-1, 1].wrapAt(i),
            \pluckCoef.kr(0.39, spec:[0, 1]) + vel.linlin(0, 1, 0.1, -0.1),
            amps[i]
        )
    };
    sig = Splay.ar(sig);
    sig = LeakDC.ar(sig);
    sig = sig * -30.dbamp;
    sig = LPF.ar(sig, 12000);
    sig = HPF.ar(sig, 120);
    
    LocalOut.ar(sig);
    
    #sigLo, sigHi = BandSplitter2.ar(sig, 120);
    sigLo = SoftClipAmp4.ar(
        (12.dbamp * sigLo)
        + (-10.dbamp * sigHi),
        26.dbamp
    );
    sig = sigLo + sigHi;
    
    DetectSilence.ar(sig, doneAction:2);
    
    Out.ar(\out.kr, sig);
}).add;
)