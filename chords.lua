--- chord selector
-- use one CV to select the same chords for both Akemi's Castle and Sid's (and eventually Cizzle)

-- below are the actual voltages used to address each chord in each module
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

-- SID'S :: CHORDS
  -- 0.0v - 0.5v > null/none
  -- 0.5v - 1.0v > 5ths
  -- 1.0v - 1.5v > Major
  -- 1.5v - 2.0v > minor
  -- 2.0v - 2.5v > suspended
  -- 2.5v - 3.0v > augemented
  -- 3.0v - 3.5v > diminished
  -- 3.5v - 4.0v > octave (1)
  -- 4.0v - 4.5v > octave (2)
  -- 4.5v - 4.7v > detuned 
  -- 4.7v - 5.0v > detuned (2)

-- CIZZLE :: CHORDS
  -- 0.00v - 0.27v > null/none
  -- 0.27v - 0.55v > octave
  -- 0.55v - 0.83v > 5ths
  -- 0.83v - 1.11v > Major
  -- 1.11v - 1.38v > dominant 7
  -- 1.38v - 1.66v > Major 7
  -- 1.66v - 1.94v > Major 9
  -- 1.94v - 2.22v > minor 9
  -- 2.22v - 2.50v > minor 7
  -- 2.50v - 2.77v > minor 6
  -- 2.77v - 3.05v > minor 4
  -- 3.05v - 3.33v > minor
  -- 3.33v - 3.61v > diminished
  -- 3.61v - 3.88v > suspended
  -- 3.88v - 4.16v > detuned
  -- 4.16v - 4.44v > detuned (2)
  -- 4.44v - 4.74v > detuned (3)
  -- 4.72v - 5.00v > castle

-- now we create lists of equal lengh for each module to sweep through for the single input cv
CHORD_COUNT = 13
akemi_chord_map = {
  0,   -- null
  1.8, -- 5ths
  3.9, -- Major
  4.4, -- minor
  4.9, -- suspended
  5.5, -- augmented
  6.2, -- diminished
  6.7, -- dominant 7
  7.0, -- Major 7
  7.8, -- minor 7
  8.3, -- Maj/dominant 9
  9.0, -- dissonant
  10   -- dissonant
}

cizzle_chord_map = {
  0,   -- null
  0.6, -- 5ths
  1,   -- Major
  3.2, -- minor
  3.7, -- suspended
  0,   -- null
  3.5, -- diminished
  1.2, -- dominant 7
  1.5, -- Major 7
  2.4, -- minor 7
  1.7, -- Maj/dominant 9
  4.3, -- dissonant
  4.6  -- dissonant
}

-- Sid's has a limited amount of chords, fallback to null/none where there is no comparable option to Akemi's
sid_chord_map = {
  0,   -- null
  0.7, -- 5ths
  1.2, -- Major
  1.7, -- minor
  2.2, -- suspended
  2.7, -- augmented
  0,   -- null
  0,   -- null
  0,   -- null
  0,   -- null
  0,   -- null
  4.6, -- dissonant
  4.9  -- dissonant
}

-- output constants
OUTPUT_AKEMIS_CHORD = 3
OUTPUT_SIDS_CHORD = 1
OUTPUT_AKEMIS_INV = 4
OUTPUT_SIDS_INV = 2

-- we are assuming the range of the input voltage is 0-5v
INPUT_MIN = 0
INPUT_MAX = 5

-- interval change required of input voltage to change chord
INTERVAL = (INPUT_MAX - INPUT_MIN) / CHORD_COUNT
-- amount to scale input voltage by in order to map it to output range
SCALE = CHORD_COUNT / (INPUT_MAX-INPUT_MIN)

function input_1_stream_update(v)
  mapIndex = math.floor(v * SCALE); 
  output[OUTPUT_AKEMIS_CHORD].volts = akemi_chord_map[mapIndex]
  output[OUTPUT_SIDS_CHORD].volts = sid_chord_map[mapIndex]

end

-- both Akemi's and Sid's already use 0-5v for chord inversions
-- so we can just pass through
function input_2_stream_update(v)
  output[OUTPUT_AKEMIS_INV].volts = v;
  output[OUTPUT_SIDS_INV].volts = v;
end

function init()
    -- turn on 'stream' mode for both inputs
    -- 0.001 sets the sample-rate of the input. 0.001s is 1ms or 1kHz
    -- this is the fastest supported stream rate 
    input[1].mode('stream', 0.001)
    input[1].stream = input_1_stream_update;
    input[2].mode('stream', 0.001)
    input[2].stream = input_2_stream_update;
end
