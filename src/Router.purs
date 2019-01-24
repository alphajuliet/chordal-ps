-- Router.purs
-- AndrewJ 2019-01-20

-- Chordal routing engine, using purescript-routing

module Router 
  ( route
  )
  where

import Prelude
import Effect (Effect)
import Effect.Console (logShow)
import Data.Int (fromString)
import Data.Map (Map, lookup, empty) as M
import Data.Either (Either(..))
import Data.Maybe (Maybe, fromMaybe, maybe)
import Data.Foldable (oneOf)
import Data.String (split, Pattern(..)) as S
import Routing (match)
import Routing.Match (Match, root, lit, str, params, end, optionalMatch)
import Simple.JSON as JSON
import Chordal (getAllNotes, getAllChords, getChord, getAllScales, getScale, getNote, Options, Output) as C

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
  | Note NoteName Params

-- | For testing
instance showAPI :: Show ChordalAPI where 
  show Notes = "Notes"
  show Chords = "Chords"
  show (Chord a b _) = "Chord " <> a <> b
  show Scales = "Scales"
  show (Scale a b _) = "Scale " <> a <> b
  show (Note a _) = "Note " <> a

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
  , Note <$> (lit "note" *> str) <*> optParams
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

-- -------------------------------

matchAPI :: String -> Either String ChordalAPI
matchAPI = match chordalAPI

-- | Route a URI string to a Chordal function
route :: String -> String
route r = case (matchAPI r) of
            (Right Notes) -> JSON.writeJSON C.getAllNotes
            (Right Chords) -> JSON.writeJSON C.getAllChords 
            (Right (Chord a b p)) -> JSON.writeJSON $ C.getChord a b $ options p
            (Right Scales) -> JSON.writeJSON C.getAllScales
            (Right (Scale a b p)) -> JSON.writeJSON $ C.getScale a b $ options p
            (Right (Note a p)) -> JSON.writeJSON $ C.getNote a $ options p
            (Left err) -> JSON.writeJSON { error: "Route error" }

-- The End
