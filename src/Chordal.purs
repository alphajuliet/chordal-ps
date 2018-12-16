-- Chordal.js
-- AndrewJ 2018-12-12

module Chordal where

import Prelude (($), (+), (-), (<>), mod)
import Data.Array (length, take, takeEnd, elem, findIndex, index, find)
import Data.Maybe (Maybe)
import Data.String (toUpper)
import Record (get)
import Data.Functor (map)

-- -------------------------------
-- Vocabulary of note names

allNotes :: Array (Array String)
allNotes = [ 
  ["C"],
  ["C#", "Db"],
  ["D"],
  ["D#", "Eb"],
  ["E"],
  ["F"],
  ["F#", "Gb"],
  ["G"],
  ["G#", "Ab"],
  ["A"],
  ["A#", "Bb"],
  ["B"] 
]

-- Conversion functions

noteToNum :: String -> Array (Array String) -> Maybe Int
noteToNum e = findIndex (elem $ toUpper e) 

numToNote :: Int -> Array (Array String) -> Maybe (Array String)
numToNote n lst = index lst (mod n 12)


-- Other note functions

transpose :: Int -> Int -> Int
transpose n root = mod (root + n) 12

rotateLeft :: ∀ a. Int -> Array a -> Array a
rotateLeft 0 lst = lst
rotateLeft _ [] = []
rotateLeft n lst = (takeEnd (len - nmod) lst) <> (take nmod lst)
  where len = length lst
        nmod = mod n len

-- -------------------------------
-- Chord type

type Chord = { 
  name :: Array String,
  notes :: Array Int,
  description :: String
}

-- -------------------------------
-- Database of chords
-- See https://en.wikipedia.org/wiki/Chord_names_and_symbols_(popular_music)

allChords :: Array Chord
allChords = [
  { name: ["maj", "major"], notes: [0, 4, 7], description: "major (C-E-G)" },
  { name: ["min", "minor"], notes: [0, 3, 7], description: "minor (C-E♭-G)" },
  { name: ["7", "7th"], notes: [0, 4, 7, 10], description: "7th (C-E-G-B♭)" },
	{ name: ["min7", "min7th", "minor7", "minor7th"], notes: [0, 3, 7, 10], description: "minor 7th (C-E♭-G-B♭)" },
	{ name: ["maj7", "maj7th", "major7", "major7th"], notes: [0, 4, 7, 11], description: "major 7th (C-E-G-B)" },
	{ name: ["minmaj7"], notes: [0, 3, 7, 11], description: "minor/major 7th (C-E♭-G-B)" },
	{ name: ["dim", "diminished"], notes: [0, 3, 6], description: "diminished (C-E♭-G♭)" },
	{ name: ["aug", "augmented"], notes: [0, 4, 8], description: "augmented (C-E-G♯)" },
	{ name: ["dim7", "dim7th"], notes: [0, 3, 6, 9], description: "diminished 7th (C-E♭-G♭-B♭♭)" },
	{ name: ["dimmaj7"], notes: [0, 3, 6, 11], description: "diminished major 7th (C-E♭-G♭-B)" },
	{ name: ["aug7"], notes: [0, 4, 8, 10], description: "augmented 7th (C-E-G♯-B♭)" },
  { name: ["augmaj7"], notes: [0, 4, 8, 11], description: "augmented major 7th (C-E-G♯-B)" },
  { name: ["7b5"], notes: [0, 4, 6, 10], description: "seventh flat 5 (C-E-G♭-B♭)" },
	{ name: ["min7b5"], notes: [0, 3, 6, 10], description: "minor seventh flat 5 (C-E♭-G♭-B♭)" },
  { name: ["maj4"], notes: [0, 4, 5, 7], description: "major 4th (C-E-F-G)" },
  { name: ["min4"], notes: [0, 3, 5, 7], description: "minor 4th (C-E♭-F-G)" },
	{ name: ["maj6"], notes: [0, 4, 7, 9], description: "major 6th (C-E-G-A)" },
	{ name: ["min6"], notes: [0, 3, 7, 9], description: "minor 6th (C-E♭-G-A)" },
	{ name: ["sus2"], notes: [0, 2, 7], description: "suspended 2nd (C-D-G)" },
	{ name: ["sus4"], notes: [0, 5, 7], description: "suspended 4th (C-F-G)" },
	{ name: ["maj9", "maj9th"], notes: [0, 4, 7, 11, 14], description: "major 9th (C-E-G-B-D)" },
	{ name: ["min9", "min9th"], notes: [0, 3, 7, 10, 14], description: "minor 9th (C-E♭-G-B♭-D)" },
	{ name: ["minmaj9"], notes: [0, 3, 7, 11, 14], description: "minor/major 9th (C-E♭-G-B-D)" }
]

-- -------------------------------
findChordByName :: String -> Array Chord -> Maybe Chord
findChordByName ch = find $ \x -> ch `elem` x.name 

-- -------------------------------
type Options = {
  transpose :: Int
}

-- -------------------------------
getChord :: String -> Array Chord -> Options -> Maybe (Array Int)
getChord ch chords opts = map _.notes $ findChordByName ch chords

-- The End
