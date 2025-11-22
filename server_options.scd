(

(
    // ServerOptions.devices();
    // inDevice:               "BOGPIPE",
    // outDevice:              "BOGPIPE",    
    // numInputBusChannels:    8,
    // numOutputBusChannels:   24,
    
    inDevice:               "MacBook Pro Microphone",
    outDevice:              "MacBook Pro Speakers",
    numInputBusChannels:    2,
    numOutputBusChannels:   2,
    
    numWireBufs:            1024,
    // sampleRate:             48000,
    memSize:                2.pow(21),
    maxNodes:               4092,
    numBuffers:             8 * 1024,
    maxSynthDefs:           8 * 1024,
    blockSize:              16,
    hardwareBufferSize:     256,
    numAudioBusChannels:    512 * 8,
    numControlBusChannels:  512 * 8,
);

// ServerView().front;

)
