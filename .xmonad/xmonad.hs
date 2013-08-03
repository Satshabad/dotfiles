import XMonad  
import XMonad.Config.Gnome  
import XMonad.Layout.NoBorders

main = do  
    xmonad $ gnomeConfig {
        layoutHook = smartBorders $ layoutHook gnomeConfig
        }
