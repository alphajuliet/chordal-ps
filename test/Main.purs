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
       assert "noteToNum D"  $ (noteToNum allNotes "D") == Just 2
       assert "noteToNum Eb" $ (noteToNum allNotes "Eb") == Just 3
       assert "noteToNum H"  $ (noteToNum allNotes "H") == Nothing

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
       let x = findItemByName "dim7" allChords :: Maybe Chord
       assert "findItemByName" $ map _.name x == Just ["dim7", "dim7th"]
       assert "findItemByName" $ map _.notes x == Just [0, 3, 6, 9]
       assert "findItemByName" $ (findItemByName "abc" allChords) == Nothing

    test "Get chord notes" do
       let opts1 = { transpose: 2, invert: 0 } :: Options
       let opts2 = { transpose: 2, invert: 1 } :: Options
       assert "getChord C_abcd" $ (getChord "C" "abcd" opts1) == Nothing
       assert "getChord X_min" $ (getChord "X" "min7" opts1) == Just ["D", "F", "A", "C"]
       assert "getChord C_min7" $ (getChord "C" "min7" opts1) == Just ["D", "F", "A", "C"]
       assert "getChord D#_min7" $ (getChord "D#" "min7" opts1) == Just ["F", "G#", "C", "D#"]
       assert "getChord Eb_min7" $ (getChord "Eb" "min7" opts1) == Just ["F", "Ab", "C", "Eb"]
       assert "getChord C_min7 inverted" $ (getChord "C" "min7" opts2) == Just ["F", "A", "C", "D"]


-- The End
