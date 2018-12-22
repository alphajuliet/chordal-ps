-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal (allNotes, noteToNum, numToNote, getChord)

main :: Effect Unit
main = do
  log "Chordal"
  log $ show allNotes
  log $ show $ noteToNum "D" allNotes
  log $ show $ getChord "D#" "min7" { transpose: 2 }

-- The End
