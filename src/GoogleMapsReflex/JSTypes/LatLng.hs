{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.LatLng where
    
import GoogleMapsReflex.Common
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value

data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
 }

instance ToJSVal LatLng where
    toJSVal LatLng{..} = new (gmaps ! "LatLng") (_latLng_lat, _latLng_lng)