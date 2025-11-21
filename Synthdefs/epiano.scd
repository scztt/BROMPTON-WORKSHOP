// EPIANO SYNTHDEF - 6-operator FM electric piano
//
// For parameter documentation and interactive examples, see: epn-example.scd

(
SynthDef(\epiano, {
    | out=0, freq, freqLag = 0.02, amp = 1, sustain=1, gate=1, vel = 0.75, retrig = 0, crash=1 |
    var sig, fmSig, noise, env, linenv, ctls, mods, mult, timescale, at,
        attack, scale, vib, filtf, jump, a, lfo, ctl6Offset, noiseAmt, sustainLevel,
        release, pan, ampNoise, freqNoise, push;
    
    pan = \pan.kr(0);
    
    ctl6Offset = \ctl6Offset.kr(100.1);
    release = \release.kr(1);
    sustainLevel = \sustainLevel.kr(1);
    attack = \attack.kr(0.01);
    noiseAmt = \noiseAmt.kr(0.05).linlin(0, 1, 0, vel.linlin(0.0, 1, 2, 3));
    push = \push.kr(0.0).linlin(0.0, 1.0, 0.0, vel * 0.3);
    jump = \jump.kr(0.0) * 6;
    jump = 6.collect {
        |i|
        (jump > i) * 1
    }.scramble.lag(1);
    
    freq = Lag.kr(freq, freqLag);
    freq = Select.kr(retrig > 0, [
        freq,
        freq * Select.kr(TRand.kr(0, 4, Dust.kr(retrig)), [1, 1, 1, 2])
    ]);
    
    timescale 	= vel.linlin(0, 1, sustain * 0.5, sustain * 2.2);
    scale 		= vel.linexp(0, 1, 0.4, 1.5);
    vib 		= \vibScale.kr(0.1) * vel.linexp(0, 1, 0.05, 0.4);
    filtf 		= \filtf.kr(1000) * vel.linlin(0, 1, -12, 6).midiratio;
    amp 		= amp * vel.linlin(0, 1, -24.dbamp, 6.dbamp);
    lfo 		= \lfoScale.kr(0.1) * SinOsc.ar(\lfoSpeed.kr(6.1), Rand(-2, 2), EnvGen.kr(Env.linen(0.01, 1, 5), gate:gate));
    freq 		= freq + lfo;
    ampNoise    = { 1 - WhiteNoise.kr(0.02).range(0, noiseAmt) };
    freqNoise   = { (WhiteNoise.ar(noiseAmt) * 4).midiratio };
    ctls = [
        [ freqNoise * freq * (jump[0] + 2) - 0.666, Rand(-pi, pi), 		 ampNoise * EnvGen.kr(Env.adsr(attack, 1,   sustainLevel * 0.01, release * 0.4, curve:0),gate:gate)	],
        [ freqNoise * freq * (jump[1] + 1),	        Rand(-pi, pi),		 ampNoise * EnvGen.kr(Env.adsr(attack, 0.5, sustainLevel * 0.6, release * 1), gate:gate) ],
        [ freqNoise * freq * (jump[2] + 3) + 0.333,	Rand(-pi, pi),		 ampNoise * EnvGen.kr(Env.adsr(attack, 0.9, sustainLevel * 0.4, release * 0.4), gate:gate)	],
        [ freqNoise * freq + (jump[3] + 0.31),		Rand(-pi, pi),		 ampNoise * EnvGen.kr(Env.adsr(attack, 0.5, sustainLevel * 0.2, release * 1), gate:gate)	],
        [ freqNoise * freq * (jump[4] + 3),			Rand(-pi, pi),		 ampNoise * EnvGen.kr(Env.adsr(attack, 0.5, sustainLevel * 0.3, release * 1), gate:gate)	],
        [ freqNoise * freq * (jump[5] + 0.5) + ctl6Offset,Rand(-pi, pi), ampNoise * EnvGen.kr(Env.adsr(attack, 0.2, sustainLevel * 0.1, release * 0.8 * timescale), gate:gate) ],
    ];
    mult = crash * pi;
    mods = [
        [ push,	0, 	0, 	0, 	0.35, 	vib ] * mult * scale,
        [ 0.29,	push, 	0, 	0, 	0, 		0 ] * mult * scale,
        [ 0,	0, 	push, 	0, 	0.29, 	0 ] * mult * scale,
        [ 0,	0, 	0.33, 	push, 	0, 	0 ] * mult * scale,
        [ 0,	0, 	0, 	0, 	push, 		0 ] * mult * scale,
        [ 0,	0, 	0, 	0, 	0.26, 	push ] * mult * scale,
    ];
    fmSig = FM7.ar(ctls, mods);
    sig = Mix([
        Pan2.ar(fmSig[0], 	-0.28,	0.41),
        Pan2.ar(fmSig[1], 	-0.19,	0.31),
        Pan2.ar(fmSig[2], 	-0.15,	0.28),
        Pan2.ar(fmSig[3], 	0.28,	0.44),
        Pan2.ar(fmSig[4], 	-0.15,	0.0),
        Pan2.ar(fmSig[5], 	-0.16,	0.16),
    ]);
    sig = Rotate2.ar(sig[0], sig[1], 0.5);
    sig = Balance2.ar(sig[0], sig[1], pan);
    
    noise = SoftClipAmp4.ar(
        (fmSig[1] * 0.43)
        + (fmSig[3] * 0.59)
            + (fmSig[4] * 0.61),
        vel.linlin(0, 1, 0.2, 2.8)
    );
    noise = Pan2.ar(noise, pan, 0.34);
    sig = sig + noise;
    sig = MoogLadder.ar(sig, filtf, 0.55);
    sig = sig * EnvGen.ar(Env([1, 1, 1, 0], [1, release, 0.1], releaseNode:1), gate:gate, doneAction:2);
    a = DetectSilence.ar(sig[0], doneAction:2);
    
    amp = 12.dbamp * amp * vel.linlin(0, 1, -6.dbamp, 0.dbamp);
    
    Out.ar(out, sig * amp)
}).add;
)