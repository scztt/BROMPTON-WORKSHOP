HardCompress : UGen {
    *ar {
        |sig, speed=1, minAmp=0.01, amp=1.0, attack=0.0001|
        var inAmp, ampThresh;
        inAmp = Amplitude.ar(ArrayMax.ar(sig.abs)[0], attack, speed).max(minAmp);
        ^sig / inAmp;
    }
}

HardCompress2 : UGen {
    *ar {
        | sig, speed=1, minAmp=0.01, amp=1.0 |
        var inAmp, ampThresh;
        inAmp = Slew.ar(ArrayMax.ar(sig.abs)[0], 999999, speed).max( minAmp );
        ^sig/inAmp;
    }
}
