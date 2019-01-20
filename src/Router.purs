-- Router.purs
-- AndrewJ 2019-01-20

-- Chordal routing engine, using purescript-routing

module Router 
  where

import Prelude
import Data.Either
import Control.Alternative ((<|>))
import Data.Foldable (oneOf)
import Routing (match)
import Routing.Match (Match, root, lit, int, str, end)
import Chordal (allNotes, allChords, getChord, allScales, getScale, transposeNotes, Options)

-- -------------------------------

-- | Type aliases for the route arguments
type NoteName = String
type ChordName = String
type ScaleName = String

-- | Define the available routes
data API
  = Notes
  | Chords
  | Chord NoteName ChordName Options
  | Scales
  | Scale NoteName ScaleName Options
  | TransposeNotes String Options

-- | For testing
instance showAPI :: Show API where 
  show Notes = "Notes"
  show Chords = "Chords"
  show _ = "API route"

-- -------------------------------

-- | Set up the routing options
chordalAPI :: Match API
chordalAPI = 
  root *> oneOf
  [ Notes <$ lit "notes"
  , Chords <$ lit "chords"
  ] <* end

-- -------------------------------

matchAPI :: String -> Either String API
matchAPI = match chordalAPI

test1 = matchAPI "notes"
test2 = matchAPI "chords"
test3 = matchAPI "chord/C/min"
test4 = matchAPI "chrod/D/abc"


-- The End
