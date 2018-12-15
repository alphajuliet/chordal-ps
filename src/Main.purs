-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal (allNotes, noteToNum)

main :: Effect Unit
main = do
  log "Chordal"
  log $ show allNotes
  log $ show $ noteToNum "D" allNotes

-- The End
