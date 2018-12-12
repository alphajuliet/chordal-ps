-- Main.ps

module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Chordal

main :: Effect Unit
main = do
  log "Chordal"
  log $ show allNotes

-- The End
