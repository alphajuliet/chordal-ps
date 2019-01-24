-- test/Main.purs
-- AndrewJ 2018-12-12

module Test.Main where

import Prelude (Unit, discard, map, negate, ($), (+), (==))
import Data.Maybe (Maybe(..))
-- import Data.List (head)
import Effect (Effect)

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert)

import Chordal (Chord, Options, allChords, allNotes, capitalise, collapseNotes, 
  findItemByName, getChord, getScale, noteToNum, numToNote, rotateLeft, 
  transpose, getNote)


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
       assert "noteToNum X"  $ (noteToNum allNotes "X") == Nothing

       assert "numToNote 2"  $ (numToNote allNotes 2) == ["D"]
       assert "numToNote 14" $ (numToNote allNotes 15) == ["D#", "Eb"]

       assert "collapseNotes" $ (collapseNotes "C" ["C#", "Db"]) == "C#"
       assert "collapseNotes" $ (collapseNotes "C#" ["C#", "Db"]) == "C#"
       assert "collapseNotes" $ (collapseNotes "Eb" ["C#", "Db"]) == "Db"

    test "Other note functions" do
       assert "transpose" $ (transpose 1 2) == 3
       assert "transpose" $ (transpose 11 2) == 1
       assert "transpose" $ (transpose 1 (-2)) == 11

       assert "rotateLeft 0" $ (rotateLeft 0 [1, 2, 3]) == [1, 2, 3]
       assert "rotateLeft 1" $ (rotateLeft 1 [1, 2, 3]) == [2, 3, 1]
       assert "rotateLeft 4" $ (rotateLeft 4 [1, 2, 3]) == [2, 3, 1]

    test "Find chord by name" do
       let x = findItemByName "dim7" allChords :: Maybe Chord
       assert "findItemByName dim7" $ map _.name x == Just ["dim7", "dim7th"]
       assert "findItemByName dim7" $ map _.notes x == Just [0, 3, 6, 9]
       assert "findItemByName abc" $ (findItemByName "abc" allChords) == Nothing

    test "Get chord notes" do
       let opts1 = { transpose: 2, inversion: 0 } :: Options
       let opts2 = { transpose: 2, inversion: 1 } :: Options
       assert "getChord C_abcd" $ (getChord "C" "abcd" opts1).notes == Nothing
       assert "getChord X_min" $ (getChord "X" "min7" opts1).notes == Just ["D", "F", "A", "C"]
       assert "getChord C_min7" $ (getChord "C" "min7" opts1).notes == Just ["D", "F", "A", "C"]
       assert "getChord D#_min7" $ (getChord "D#" "min7" opts1).notes == Just ["F", "G#", "C", "D#"]
       assert "getChord Eb_min7" $ (getChord "Eb" "min7" opts1).notes == Just ["F", "Ab", "C", "Eb"]
       assert "getChord C_min7 inverted" $ (getChord "C" "min7" opts2).notes == Just ["F", "A", "C", "D"]

    test "Get scale notes" do
       let opts1 = { transpose: 0, inversion: 0 } :: Options
       assert "getScale C_maj" $ (getScale "C" "major" opts1).notes == Just ["C", "D", "E", "F", "G", "A", "B"] 
       assert "getScale C min7" $ (getScale "C" "min7" opts1).notes == Nothing

    test "Transpose notes" do
       let opts = { transpose: 2, inversion: 0 }
       assert "getNote 2" $ (getNote "C,D,Eb" opts) == Just ["D", "E", "F"]
       assert "getNote 2" $ (getNote "C,X,Eb" opts) == Nothing

-- The End
