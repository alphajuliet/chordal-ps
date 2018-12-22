module Test.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
{-- import Effect.Console (log) --}

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
       assert "collapseNotes" $ (collapseNotes "Db" ["C#", "Db"]) == "Db"

    test "Other note functions" do
       assert "transpose" $ (transpose 1 2) == 3
       assert "transpose" $ (transpose 11 2) == 1
       assert "rotateLeft 0" $ (rotateLeft 0 [1, 2, 3]) == [1, 2, 3]
       assert "rotateLeft 1" $ (rotateLeft 1 [1, 2, 3]) == [2, 3, 1]
       assert "rotateLeft 4" $ (rotateLeft 4 [1, 2, 3]) == [2, 3, 1]

    test "Find chord by name" do
       let x = findChordByName "dim7" allChords
       assert "findChordByName" $ map _.name x == Just ["dim7", "dim7th"]
       assert "findChordByName" $ map _.notes x == Just [0, 3, 6, 9]
       assert "findChordByName" $ (findChordByName "abc" allChords) == Nothing

    test "Get chord notes" do
       let opts = { transpose: 0 }
       assert "getChord" $ (getChord "min7" allChords) == Just ["C", "D#", "G", "A#"]


-- The End
