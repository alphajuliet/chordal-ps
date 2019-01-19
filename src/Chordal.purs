-- Chordal.purs
-- AndrewJ 2018-12-12

module Chordal 
  ( allNotes
  , allChords
  , getChord
  , allScales
  , getScale
  , transposeNotes
  -- Exports for unit testing
  , capitalise
  , rotateLeft
  , noteToNum
  , numToNote
  , collapseNotes
  , transpose
  , findItemByName
  , Chord
  , Scale
  , Options
  ) where

import Prelude (($), (+), (-), (<>), (==), (&&), (>>>), (<$>), otherwise, mod)
import Data.Array ((..), length, take, takeEnd, elem, head, last, findIndex, index, find)
import Data.Maybe (Maybe, fromMaybe)
import Data.String as S
import Data.Functor (map)
import Data.Traversable (sequence)

-- -------------------------------
-- Utilities

capitalise :: String -> String
capitalise "" = ""
capitalise s = (S.toUpper $ S.take 1 s) <> (S.drop 1 s)

-- -------------------------------

-- | Vocabulary of note names
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

-- -------------------------------
-- Conversion functions

-- | Convert a note name to an integer (mod 12)
noteToNum :: Array (Array String) -> String -> Maybe Int
noteToNum lst e = findIndex (elem $ capitalise e) lst

-- | Convert an integer to a note name
-- | index could return Nothing but doesn't because every Int must map to a
-- | note, modulo the length of the list.
numToNote :: Array (Array String) -> Int -> Array String
numToNote lst n = fromMaybe ["C"] $ lst `index` (mod n len)
  where len = length lst


-- | Choose one of the alternatives for the black notes based on the base note
-- | e.g. C# -> D#, F#... but Db -> Eb, Gb...
collapseNotes :: String -> Array String -> String
collapseNotes base lst = fromMaybe "" x
  where x | (S.length base) == 2 && (S.drop 1 base == "b") = last lst
          | otherwise = head lst

-- -------------------------------
-- Other note functions

-- | A transpose is just addition modulo 12
transpose :: Int -> Int -> Int
transpose n root = (root + n) `mod` 12

-- | A rotation is used for chord inversions
rotateLeft :: ∀ a. Int -> Array a -> Array a
rotateLeft 0 lst = lst
rotateLeft _ [] = []
rotateLeft n lst = (takeEnd (len - nmod) lst) <> (take nmod lst)
  where len = length lst
        nmod = n `mod` len

-- -------------------------------
-- Chords

type Chord = 
  { name :: Array String
  , notes :: Array Int
  , description :: String
  }

-- | Database of chords
-- | See https://en.wikipedia.org/wiki/Chord_names_and_symbols_(popular_music)
allChords :: Array Chord
allChords = 
  [ { name: ["maj", "major"], notes: [0, 4, 7], description: "major (C-E-G)" }
  , { name: ["min", "minor"], notes: [0, 3, 7], description: "minor (C-E♭-G)" }
  , { name: ["7", "7th"], notes: [0, 4, 7, 10], description: "7th (C-E-G-B♭)" }
  , { name: ["min7", "min7th", "minor7", "minor7th"], notes: [0, 3, 7, 10], description: "minor 7th (C-E♭-G-B♭)" }
  , { name: ["maj7", "maj7th", "major7", "major7th"], notes: [0, 4, 7, 11], description: "major 7th (C-E-G-B)" }
  , { name: ["minmaj7"], notes: [0, 3, 7, 11], description: "minor/major 7th (C-E♭-G-B)" }
  , { name: ["dim", "diminished"], notes: [0, 3, 6], description: "diminished (C-E♭-G♭)" }
  , { name: ["aug", "augmented"], notes: [0, 4, 8], description: "augmented (C-E-G♯)" }
  , { name: ["dim7", "dim7th"], notes: [0, 3, 6, 9], description: "diminished 7th (C-E♭-G♭-B♭♭)" }
  , { name: ["dimmaj7"], notes: [0, 3, 6, 11], description: "diminished major 7th (C-E♭-G♭-B)" }
  , { name: ["aug7"], notes: [0, 4, 8, 10], description: "augmented 7th (C-E-G♯-B♭)" }
  , { name: ["augmaj7"], notes: [0, 4, 8, 11], description: "augmented major 7th (C-E-G♯-B)" }
  , { name: ["7b5"], notes: [0, 4, 6, 10], description: "seventh flat 5 (C-E-G♭-B♭)" }
  , { name: ["min7b5"], notes: [0, 3, 6, 10], description: "minor seventh flat 5 (C-E♭-G♭-B♭)" }
  , { name: ["maj4"], notes: [0, 4, 5, 7], description: "major 4th (C-E-F-G)" }
  , { name: ["min4"], notes: [0, 3, 5, 7], description: "minor 4th (C-E♭-F-G)" }
  , { name: ["maj6"], notes: [0, 4, 7, 9], description: "major 6th (C-E-G-A)" }
  , { name: ["min6"], notes: [0, 3, 7, 9], description: "minor 6th (C-E♭-G-A)" }
  , { name: ["sus2"], notes: [0, 2, 7], description: "suspended 2nd (C-D-G)" }
  , { name: ["sus4"], notes: [0, 5, 7], description: "suspended 4th (C-F-G)" }
  , { name: ["maj9", "maj9th"], notes: [0, 4, 7, 11, 14], description: "major 9th (C-E-G-B-D)" }
  , { name: ["min9", "min9th"], notes: [0, 3, 7, 10, 14], description: "minor 9th (C-E♭-G-B♭-D)" }
  , { name: ["minmaj9"], notes: [0, 3, 7, 11, 14], description: "minor/major 9th (C-E♭-G-B-D)" }
  ]

-- ---------------------------------
-- Scales

type Scale = 
  { name :: Array String
  , notes :: Array Int
  , description :: String
  }

-- | Database of scales and modes
-- | See https://en.wikipedia.org/wiki/List_of_musical_scales_and_modes
allScales :: Array Scale
allScales = 
  [ { name: ["major", "ionian", "I"], notes: [0, 2, 4, 5, 7, 9, 11], description: "Ionian mode (I) or major scale" }
  , { name: ["dorian", "II"], notes: [0, 2, 3, 5, 7, 9, 10], description: "Dorian mode (II)" }
  , { name: ["phrygian", "III"], notes: [0, 1, 3, 5, 7, 8, 10], description: "Phrygian mode (III)" }
  , { name: ["lydian", "IV"], notes: [0, 2, 4, 6, 9, 11], description: "Lydian mode (IV)" }
  , { name: ["mixolydian", "V"], notes: [0, 2, 4, 5, 9, 10], description: "Mixolydian mode (V)" }
  , { name: ["aeolian", "natural_minor", "VI"], notes: [0, 2, 3, 5, 7, 8, 10], description: "Aeolian mode (VI)" }
  , { name: ["locrian", "VII"], notes: [0, 1, 3, 5, 6, 8, 10], description: "Locrian mode (VII)" }
  , { name: ["minor", "harmonic_minor"], notes: [0, 2, 3, 5, 7, 8, 11], description: "Harmonic minor scale" }
  , { name: ["harmonic_major"], notes: [0, 2, 4, 5, 7, 8, 11], description: "Harmonic major scale" }
  , { name: ["blues"], notes: [0, 3, 5, 6, 7, 10], description: "Blues scale" }
  , { name: ["chromatic"], notes: 0 .. 12, description: "Chromatic scale" }
  , { name: ["major_pentatonic"], notes: [0, 2, 4, 7, 9], description: "Major pentatonic scale" }
  , { name: ["minor_pentatonic"], notes: [0, 3, 4, 7, 10], description: "Major pentatonic scale" }
  , { name: ["neapolitan_major"], notes: [0, 1, 3, 5, 7, 9, 11], description: "Neapolitan major scale" }
  , { name: ["neapolitan_minor"], notes: [0, 1, 3, 5, 7, 8, 11], description: "Neapolitan minor scale" }
  , { name: ["tritone"], notes: [0, 1, 4, 6, 7, 10], description: "Tritone scale (1 b2 3 b5 5 b7)" }
  ]

-- -------------------------------

-- | Find an entry in the given database, based on a match in the `name` field.
findItemByName :: ∀ a. String -> Array { name :: Array String | a } -> Maybe { name :: Array String | a }
findItemByName ch = find $ \x -> ch `elem` x.name 

-- | Record for passing function options
type Options = 
  { transpose :: Int
  , inversion :: Int 
  }

-- -------------------------------

-- | Take a base note, chord name, and options and return a list of notes.
getChord :: String -> String -> Options -> Maybe (Array String)
getChord rootNote chordName opts = f <$> chord
  where f = _.notes
            >>> (map $ transpose (tr + rootNum))
            >>> (rotateLeft inv)
            >>> (map $ numToNote allNotes)
            >>> (map $ collapseNotes rootNote)
        chord = findItemByName chordName allChords
        tr = opts.transpose
        inv = opts.inversion
        rootNum = fromMaybe 0 $ noteToNum allNotes rootNote

-- -------------------------------

-- | Take a base note, scale name, and options and return a list of notes.
getScale :: String -> String -> Options -> Maybe (Array String)
getScale rootNote scaleName opts = f <$> scale
  where f = _.notes
            >>> (map $ transpose (tr + rootNum))
            >>> (map $ numToNote allNotes)
            >>> (map $ collapseNotes rootNote)
        scale = findItemByName scaleName allScales
        tr = opts.transpose
        rootNum = fromMaybe 0 $ noteToNum allNotes rootNote

-- -------------------------------

-- | Transpose a list of notes
transposeNotes :: Array String -> Options -> Maybe (Array String)
transposeNotes lst opts = f lst
  where f = (map $ noteToNum allNotes)
            >>> mapmap ((transpose tr)
                  >>> (numToNote allNotes)
                  >>> (collapseNotes baseNote))
            >>> sequence
        baseNote = fromMaybe "C" $ head lst
        tr = opts.transpose
        mapmap = map >>> map

-- The End
