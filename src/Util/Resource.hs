{-# LANGUAGE RankNTypes      #-}

module Util.Resource
  ( Resource(..)
  , apply
  , ResourceConstructor(..)
  ) where

import Control.Exception (bracket)
import Control.Monad (liftM, ap)

data Resource a = Resource {use :: forall b . (a -> IO b) -> IO b}

data ResourceConstructor a = ResourceConstructor 
  { acquire :: IO a
  , release :: a -> IO ()
  }

apply :: ResourceConstructor a -> Resource a
apply resourceConstructor = Resource
  {
    use = \f -> 
      bracket 
        (acquire resourceConstructor)
        (release resourceConstructor)
        f
  }

instance Functor Resource where
  fmap = liftM

instance Applicative Resource where
  pure = return
  (<*>) = ap

instance Monad Resource where
  return a = Resource {
    use = \f -> f a
  }
  (>>=) resource f = Resource {
    use = \g -> use resource (\a -> use (f a) g )
  }