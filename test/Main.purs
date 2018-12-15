module Test.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
{-- import Effect.Console (log) --}

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert

import Chordal

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


-- The End
