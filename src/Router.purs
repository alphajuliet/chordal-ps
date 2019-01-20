-- Router.purs
-- AndrewJ 2019-01-20

-- Chordal routing engine, using purescript-routing

module Router 
  where

import Prelude
import Effect (Effect)
import Effect.Console (logShow)
import Data.Either (Either(..))
import Data.Foldable (oneOf)
import Routing (match)
import Routing.Match (Match, root, lit, int, str, end)
import Chordal (allNotes, allChords, getChord, allScales, getScale, transposeNotes, Options) as C

-- -------------------------------

-- | Type aliases for the route arguments
type NoteName = String
type ChordName = String
type ScaleName = String

-- | Define the available routes
data API
  = Notes
  | Chords
  | Chord NoteName ChordName
  | Scales
  | Scale NoteName ScaleName
  {-- | TransposeNotes String --}

-- | For testing
instance showAPI :: Show API where 
  show Notes = "Notes"
  show Chords = "Chords"
  show (Chord a b) = "Chord " <> a <> b
  show Scales = "Scales"
  show (Scale a b) = "Scale " <> a <> b
  show _ = "Other API route"

-- -------------------------------

-- | Match the URI to the route
chordalAPI :: Match API
chordalAPI = 
  root *> oneOf
  [ Notes  <$ lit "notes"
  , Chords <$ lit "chords"
  {-- , Chord <$> lit "chord" *> str <*> str --}
  , Scales <$ lit "scales"
  {-- , Scale <$> lit "scale" *> str <*> str --}
  ] <* end

-- -------------------------------

matchAPI :: String -> Either String API
matchAPI = match chordalAPI

route :: String -> Effect Unit
route r = 
  case m of
       (Right Notes) -> logShow C.allNotes
       (Right Chords) -> logShow C.allChords
       _ -> logShow "Error"
       where m = matchAPI r

{-- test1 = matchAPI "notes" --}
{-- test2 = matchAPI "chords" --}
{-- test3 = matchAPI "chord/C/min" --}
{-- test4 = matchAPI "chrod/D/abc" --}




-- The End
