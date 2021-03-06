module GoogleMapsReflex.MapsLoader where

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.String
import Language.Javascript.JSaddle.Value

import JSDOM
import JSDOM.Generated.Document (createElement, getBodyUnchecked)
import JSDOM.Generated.NonElementParentNode (getElementByIdUnchecked)
import JSDOM.Generated.Element (setAttribute)
import JSDOM.Generated.Node (appendChild)
import JSDOM.Types hiding (Function, Event)

import Reflex.Dom.Core
import GoogleMapsReflex.Types
import Data.Functor
import Control.Monad.IO.Class

 --Map a trigger event to an event for when maps is ready
loadMaps :: (MonadWidget t m) => ApiKey -> Event t () -> m (Event t ())
loadMaps mapsKey event = performEventAsync (event $> insertMapsHandler mapsKey)

--Insert mapsLoaded global function which will fire event trigger when maps script loaded, or immediately when already exists
insertMapsHandler :: MonadJSM m => ApiKey -> (() -> IO()) -> m ()
insertMapsHandler mapsKey eventTrigger = liftJSM $ do
    --Check if we've done this before
    mapsLoadedUndefined <- valIsUndefined $ getProp (toJSString "mapsLoaded") global
    if mapsLoadedUndefined
        then do
            global <# "mapsLoaded" $ loadHandler eventTrigger
            insertMapsScript mapsKey
        else liftIO $ eventTrigger ()

--Insert the maps script 
insertMapsScript :: ApiKey -> JSM ()
insertMapsScript (ApiKey mapsKey) = do
    document <- currentDocumentUnchecked
    scriptNode <- createElement document "script"
    setAttribute scriptNode "src" $ "https://maps.googleapis.com/maps/api/js?key=" ++ mapsKey ++ "&callback=mapsLoaded"
    setAttribute scriptNode "async" "true"
    setAttribute scriptNode "defer" "true"
    body <- getBodyUnchecked document
    appendChild body scriptNode
    return ()

--The actual mapsloaded function - just fire the event
loadHandler :: (() -> IO ()) -> JSM Function
loadHandler eventTrigger = asyncFunction fireEvent
    where fireEvent _ _ _ = liftIO $ eventTrigger ()