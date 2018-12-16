module Test.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
{-- import Effect.Console (log) --}

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert

import Chordal (allNotes, allChords, noteToNum, numToNote, transpose,
rotateLeft, findChordByName)

main :: Effect Unit
main = runTest do
  suite "Unit tests" do
    test "Sanity check" do
        Assert.assert "2+2=4" $ (2 + 2) == 4

    test "Conversion functions" do
       Assert.assert "noteToNum" $ (noteToNum "D" allNotes) == Just 2
       Assert.assert "noteToNum" $ (noteToNum "H" allNotes) == Nothing
       Assert.assert "numToNote" $ (numToNote 2 allNotes) == Just ["D"]
       Assert.assert "numToNote" $ (numToNote 14 allNotes) == Just ["D"]

    test "Other note functions" do
       Assert.assert "transpose" $ (transpose 1 2) == 3
       Assert.assert "transpose" $ (transpose 11 2) == 1
       Assert.assert "rotateLeft 0" $ (rotateLeft 0 [1, 2, 3]) == [1, 2, 3]
       Assert.assert "rotateLeft 1" $ (rotateLeft 1 [1, 2, 3]) == [2, 3, 1]
       Assert.assert "rotateLeft 4" $ (rotateLeft 4 [1, 2, 3]) == [2, 3, 1]

    test "Find chord by name" do
       Assert.assert "findChordByName" $ (findChordByName "dim7" allChords) ==
         Just { name: ["dim7", "dim7th"], notes: [0, 3, 6, 9], description: "diminished 7th (C-E♭-G♭-B♭♭)" }
       Assert.assert "findChordByName" $ (findChordByName "abc" allChords) ==
         Nothing


-- The End
