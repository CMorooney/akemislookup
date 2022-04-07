--- chord selector
-- 1/v octave to akemi's chords lookup

-- AKEMI'S
-- 0v - 1.5v   > nll
-- 1.6v - 2.1v > 5ths
-- 2.2v - 2.6v > octave (1)
-- 2.7v - 3.1v > octave (2)
-- 3.2v - 3.6v > octave (3)
-- 3.7v - 4.1v > Major
-- 4.2v - 4.6v > minor
-- 4.7v - 5.1v > suspended
-- 5.2v - 5.8v > augmented
-- 5.9v - 6.4v > diminished
-- 6.5v - 6.8v > dominant 7
-- 6.9v - 7.4v > Major 7
-- 7.5v - 8.0v > minor 7
-- 8.1v - 8.4v > Maj/dominant 9
-- 8.5v - 9.5v > detuned
-- 9.6v - 10v  > detuned (2)

-- note: KSP starts at 1v bass note middle octave

map = {
  0,   -- null
  1.8, -- 5ths
  3.9, -- Major
  4.4, -- minor
  4.9, -- suspended
  5.5, -- augmented
  6.2, -- diminshed
  6.7, -- dominant 7
  7.0, -- Major 7
  7.8, -- minor 7
  8.3, -- Maj/dominant 9
  9.0, -- dissonant
  10   -- dissonant
}

interval = 0.0833                 -- half step (1/12)
first = 1.006358                  -- volts value of lowest note expected from controller
last = #map * interval + first    -- volts value of the highest note expected from the controller
                                     -- this is calculatable since we know the number of outputs, the constant interval, and the 'starting' point

function input_1_stream_update(v)
  lastVal = 1   -- for window comparator
  accessor = 1  -- keep track of target output to set when comparator catches

  for i = first,last,interval
  do
    if v >= lastVal and v < i and output[1].volts ~= map[accessor]
    then
      output[1].volts = map[accessor]
    end

    lastVal = i
    accessor = accessor + 1
  end
end

function init()
    -- turn on 'stream' mode for input 1
    -- 0.001 sets the sample-rate of the input. 0.001s is 1ms or 1kHz
    -- this is the fastest supported stream rate 
    input[1].mode('stream', 0.001)
    input[1].stream = input_1_stream_update;
end
