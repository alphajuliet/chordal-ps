-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal (allNotes, getChord, getScale)

main :: Effect Unit
main = do
  log "chordal-ps"
  log $ show allNotes
  log $ show $ getChord "E" "min7" { transpose: 2, inversion: 0 }
  log $ show $ getScale "C" "major" { transpose: 0, inversion: 0 }

-- The End
