-- Router.purs
-- AndrewJ 2019-01-20

-- Chordal routing engine, using purescript-routing

module Router 
  where

import Prelude
import Effect (Effect)
import Effect.Console (logShow)
import Data.Int (floor, fromString)
import Data.Map (Map, lookup, empty) as M
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Foldable (oneOf)
import Data.String (split, Pattern(..)) as S
import Routing (match)
import Routing.Match (Match, root, lit, str, params, end, optionalMatch)
import Chordal (allNotes, allChords, getChord, allScales, getScale, transposeNotes, Options) as C

-- -------------------------------

-- | Type aliases for the route arguments
type NoteName = String
type ChordName = String
type ScaleName = String
type Params = M.Map String String

-- | Define the available routes
data ChordalAPI
  = Notes
  | Chords
  | Chord NoteName ChordName Params
  | Scales
  | Scale NoteName ScaleName Params
  {-- | TransposeNotes String Params --}

-- | For testing
instance showAPI :: Show ChordalAPI where 
  show Notes = "Notes"
  show Chords = "Chords"
  show (Chord a b _) = "Chord " <> a <> b
  show Scales = "Scales"
  show (Scale a b _) = "Scale " <> a <> b
  {-- show (TransposeNotes a _) = "Transpose " <> a --}

-- -------------------------------

optParams :: Match (M.Map String String)
optParams = maybe M.empty identity <$> optionalMatch params <* end

-- | Match the URI to the route
chordalAPI :: Match ChordalAPI
chordalAPI = 
  root *> oneOf
  [ Notes  <$ lit "notes"
  , Chords <$ lit "chords"
  , Chord <$> (lit "chord" *> str) <*> str <*> optParams
  , Scales <$ lit "scales"
  , Scale <$> (lit "scale" *> str) <*> str <*> optParams
  {-- , TransposeNotes <$> (lit "notes" *> params) <*> optParams --}
  ] <* end

-- -------------------------------

-- | Convert a URI parameter value to an integer
stringToInt :: Maybe String -> Int
stringToInt s = fromMaybe 0 $ s >>= fromString

-- | Convert a list of notes to an array
stringToArray :: Maybe String -> Array String
stringToArray s = fromMaybe [] $ S.split (S.Pattern ",") <$> s

-- | Convert URI optional parameters to Chordal options
options :: Params -> C.Options
options p = { "transpose": tr, "inversion": inv }
  where tr = (stringToInt <<< M.lookup "transpose") p
        inv = (stringToInt <<< M.lookup "inversion") p


matchAPI :: String -> Either String ChordalAPI
matchAPI = match chordalAPI

-- | Route a URI string to a Chordal function
route :: String -> Effect Unit
route r = case (matchAPI r) of
  (Right Notes) -> logShow C.allNotes
  (Right Chords) -> logShow C.allChords
  (Right (Chord a b p)) -> logShow $ C.getChord a b $ options p
  (Right Scales) -> logShow C.allScales
  (Right (Scale a b p)) -> logShow $ C.getScale a b $ options p
  {-- (Right (TransposeNotes a p)) -> logShow $ C.transposeNotes $ stringToArray p $ options p --}
  (Left err) -> logShow "Route error"

-- The End
