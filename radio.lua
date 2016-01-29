radio = {}
radio.sequences = {
    a = {
        on  = {1,2,3,2,3,3,2,3,2,2,3,3,2,2,2,2,3,3,2,2,3,2,2,3,3},
        off = {1,2,3,2,3,2,2,2,3,2,3,3,3,2,2,2,2,3,3,2,3,2,2,3,3}
    },
    b = { 
        on  = {1,2,3,2,3,3,2,2,2,2,2,2,2,3,2,3,3,3,3,3,3,3,2,3,2},
        off = {1,2,3,2,3,3,3,2,3,2,3,2,2,2,3,2,2,2,2,3,2,3,2,3,2}
    },
    c = { 
        on  = {1,2,3,2,3,2,3,3,2,3,2,2,3,2,3,3,2,2,3,3,3,2,2,2,3},
        off = {1,2,3,2,3,3,2,3,2,2,3,3,2,2,2,2,3,3,2,2,3,2,2,2,3}
    }
}


local function emitControl(sequence)


    local timeDelay = 113;
    local staticDelay = 100;

    --A description of the digital radio waves the remote emits
    --3,7 would represent a wave like
    --patterns holds the wave forms
    --and sequence holds the data about the order of those waves
    --the example given is the cotech remote plug remote "A ON" button
    --         ---
    --         |
    --         |
    --         |
    --         |
    --  -------
    local patterns = {
        {2,20},
        {9,3},
        {2,9},
        {26,63},
        {8,4},
        {3,8}
    }

    local signal = sequence
    --for speed
    local write, delay = gpio.write, tmr.delay
    gpio.mode(0, gpio.OUTPUT)


    local write, delay = gpio.write, tmr.delay
    for i = 0,  7 do
        for j = 0,  24 do
            local wave = nil
            if i < 4 then
                wave = patterns[signal[j + 1]]
            else
                wave = patterns[signal[j + 1] + 3]
            end
            write(0, 1)
            delay(wave[1] * timeDelay + staticDelay)
            write(0, 0)
            delay(wave[2] * timeDelay + staticDelay)
        end

    end

end

radio.emitControl = emitControl
