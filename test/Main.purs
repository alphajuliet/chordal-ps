-- test/Main.purs
-- AndrewJ 2018-12-12

module Test.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert)

import Chordal


main :: Effect Unit
main = runTest do
  suite "Unit tests" do

    test "Sanity check" do
       assert "2+2=4" $ (2 + 2) == 4

    test "Utilities" do
       assert "capitalise" $ (capitalise "abc") == "Abc"
       assert "capitalise" $ (capitalise "") == ""
       assert "capitalise" $ (capitalise "a") == "A"

    test "Conversion functions" do
       assert "noteToNum D"  $ (noteToNum "D" allNotes) == Just 2
       assert "noteToNum Eb" $ (noteToNum "Eb" allNotes) == Just 3
       assert "noteToNum H"  $ (noteToNum "H" allNotes) == Nothing

       assert "numToNote 2"  $ (numToNote allNotes 2) == ["D"]
       assert "numToNote 14" $ (numToNote allNotes 15) == ["D#", "Eb"]

       assert "collapseNotes" $ (collapseNotes "C" ["C#", "Db"]) == "C#"
       assert "collapseNotes" $ (collapseNotes "C#" ["C#", "Db"]) == "C#"
       assert "collapseNotes" $ (collapseNotes "Eb" ["C#", "Db"]) == "Db"

    test "Other note functions" do
       assert "transpose" $ (transpose 1 2) == 3
       assert "transpose" $ (transpose 11 2) == 1

       assert "rotateLeft 0" $ (rotateLeft 0 [1, 2, 3]) == [1, 2, 3]
       assert "rotateLeft 1" $ (rotateLeft 1 [1, 2, 3]) == [2, 3, 1]
       assert "rotateLeft 4" $ (rotateLeft 4 [1, 2, 3]) == [2, 3, 1]

    test "Find chord by name" do
       let x = findChordByName "dim7" allChords :: Maybe Chord
       assert "findChordByName" $ map _.name x == Just ["dim7", "dim7th"]
       assert "findChordByName" $ map _.notes x == Just [0, 3, 6, 9]
       assert "findChordByName" $ (findChordByName "abc" allChords) == Nothing

    test "Get chord notes" do
       let opts = { transpose: 2 } :: Options
       assert "getChord C_abcd" $ (getChord "C" "abcd" opts) == Nothing
       assert "getChord C_min7" $ (getChord "C" "min7" opts) == Just ["D", "F", "A", "C"]
       assert "getChord D#_min7" $ (getChord "D#" "min7" opts) == Just ["F", "G#", "C", "D#"]
       assert "getChord Eb_min7" $ (getChord "Eb" "min7" opts) == Just ["F", "Ab", "C", "Eb"]


-- The End
