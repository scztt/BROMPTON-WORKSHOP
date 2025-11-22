(
" <LOCAL STARTUP>".postln;

// ServerView().front;

Require.with("server_options") {
    |serverSettings|
    
    serverSettings.keysValuesDo { 
        |key, val| 
        Server.internal.options.instVarPut(key, val);
        Server.local.options.instVarPut(key, val);
    };
    Server.local.options.dump;
    Server.local.reboot;
    Server.local.latency = 0.2;
    
    // ServerView().front;
};

"</LOCAL STARTUP>".postln;
)
