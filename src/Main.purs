-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal (allNotes, getChord, getScale)

main :: Effect Unit
main = do
  log "Chordal"
  log $ show allNotes
  log $ show $ getChord "E" "min7" { transpose: 2, invert: 0 }
  log $ show $ getScale "C" "major" { transpose: 0, invert: 0 }

-- The End
