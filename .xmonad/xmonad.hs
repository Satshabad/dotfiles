import XMonad
import XMonad.Config.Gnome
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeysP)

main = do
    xmonad $ gnomeConfig {
        layoutHook = smartBorders $ layoutHook gnomeConfig
        } `additionalKeysP`
        ----- tmux remappings -----
        -- swich panes
        [ ("M4-j",   spawn "xdotool keyup j" >> spawn "xdotool key --clearmodifiers ctrl+b o")
        , ("M4-k",   spawn "xdotool keyup k" >> spawn "xdotool key --clearmodifiers ctrl+b O")
        -- move panes
        , ("M4-S-j", spawn "xdotool keyup j" >> spawn "xdotool key --clearmodifiers ctrl+b braceright")
        , ("M4-S-k", spawn "xdotool keyup k" >> spawn "xdotool key --clearmodifiers ctrl+b braceleft")
        -- zoom
        , ("M4-z", spawn "xdotool keyup z" >> spawn "xdotool key --clearmodifiers ctrl+b z")
        -- new pane
        , ("M4-<Return>", spawn "xdotool keyup Return" >> spawn "xdotool key --clearmodifiers ctrl+b v")
        , ("M4-S-<Return>", spawn "xdotool keyup Return" >> spawn "xdotool key --clearmodifiers ctrl+b s")
        -- switch windows
        , ("M4-n",   spawn "xdotool keyup n" >> spawn "xdotool key --clearmodifiers ctrl+b n")
        , ("M4-p",   spawn "xdotool keyup p" >> spawn "xdotool key --clearmodifiers ctrl+b p")
        ]
