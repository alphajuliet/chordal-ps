-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal (allNotes, getChord)

main :: Effect Unit
main = do
  log "Chordal"
  log $ show allNotes
  log $ show $ getChord "D#" "min7" { transpose: 2, invert: 0 }

-- The End
