{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.Types where

import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Values
import Data.Default
import Language.Javascript.JSaddle.Value
import Reflex

newtype ApiKey = ApiKey String

data Config = Config {
    _config_mapOptions :: MapOptions,
    _config_markers :: [MarkerOptions]
} deriving (Eq, Ord)

instance Default Config where
    def = Config def []

data MapsState e = MapsState {
    _mapsState_mapElement :: e,
    _mapsState_mapVal :: MapVal,
    _mapsState_markers :: [MarkerVal]
}

type GoogleMaps t e = Dynamic t (Maybe (MapsState e))