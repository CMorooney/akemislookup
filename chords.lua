--- chord selector
-- 1/v octave to akemi's chords (+ inversions) lookup

-- AKEMI'S :: CHORDS
  -- 0.0v - 1.5v > null/none
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

-- note: KSP starts at 1v (lowest c) when at middle (0) octave

chord_map = {
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

chord_interval = 0.0833                     -- half step (1/12)
first = 1.006358                            -- volts value of lowest note expected from controller
last = #chord_map * interval + first        -- volts value of the highest note expected from the controller

function input_1_stream_update(v)
  lastVal = 1   -- for window comparator
  accessor = 1  -- keep track of target output to set when comparator catches

  for i = first,last,interval
  do
    if v >= lastVal and v < i and output[1].volts ~= chord_map[accessor]
    then
      output[1].volts = chord_map[accessor]
    end

    lastVal = i
    accessor = accessor + 1
  end
end

-- AKEMI'S :: INVERSIONS
  -- 0.00v - 1.21v > null/none
  -- 1.22v - 2.51v > first
  -- 2.52v - 3.81v > second
  -- 3.82v - 5.00v > third

-- note: KSP 'mod' cv is going from ~0-5v
-- so -- no need for any script -- just plug directly in unless you want to change response curve somehow

function init()
    -- turn on 'stream' mode for input 1
    -- 0.001 sets the sample-rate of the input. 0.001s is 1ms or 1kHz
    -- this is the fastest supported stream rate 
    input[1].mode('stream', 0.001)
    input[1].stream = input_1_stream_update;
end
