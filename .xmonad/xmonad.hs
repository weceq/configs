{-# LANGUAGE OverloadedStrings #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

import XMonad.Layout.NoBorders
import XMonad.Actions.GridSelect
import XMonad.Config.Gnome

import System.IO

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    -- search window in claws-mail
    , stringProperty "WM_WINDOW_ROLE" =? "message_search" --> doFloat
    , isFullscreen --> doFullFloat
    ]

gsconfig2 colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 30, gs_cellwidth = 100 }
 -- | A green monochrome colorizer based on window class
greenColorizer = colorRangeFromClassName
                     (0x2F,0x2F,0x2F)            -- lowest inactive bg
                     (0xAF,0xAF,0xAF) -- highest inactive bg
                     (0xE5,0xE5,0xE5)            -- active bg
                     white            -- inactive fg
                     black            -- active fg
  where black = minBound
        white = maxBound

main = do
--    xmproc <- spawnPipe "xmobar"
--    xmproc <- spawnPipe "dzen2"
--    xmonad $ defaultConfig
    dbus <- D.connectSession
    getWellKnownName dbus
    xmonad $ gnomeConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
--                        <+> manageHook defaultConfig
                        <+> manageHook gnomeConfig
--        , layoutHook = smartBorders $ avoidStruts  $  layoutHook defaultConfig
        , layoutHook = smartBorders $ avoidStruts  $  layoutHook gnomeConfig
--        , logHook = dynamicLogWithPP $ dzenPP
--                        { ppOutput = System.IO.hPutStrLn xmproc
--                        , ppTitle = dzenColor "green" "" . shorten 50
--                        }
        , logHook = dynamicLogWithPP (prettyPrinter dbus)
--        , logHook = dynamicLogWithPP $ xmobarPP
--                        { ppOutput = System.IO.hPutStrLn xmproc
--                        , ppTitle = xmobarColor "green" "" . shorten 50
--                        }
	, terminal = "urxvt"
	-- , terminal = "gnome-terminal"
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
	-- screenshot screen
    	, ((mod4Mask, xK_Print), spawn "/usr/local/bin/screenshot scr")
	-- screenshot window or area
    	, ((mod4Mask .|. shiftMask, xK_Print), spawn "/usr/local/bin/screenshot win")
	, ((mod4Mask, xK_p), spawn "/usr/bin/dmenu_run")
        , ((0, 0x1008ff11) , spawn "amixer set Master 3%-")
        , ((0, 0x1008ff13) , spawn "amixer set Master 3%+")
	, ((0, 0x1008ff12) , spawn "amixer set Master toggle")
	, ((mod4Mask .|. shiftMask, xK_space), spawn "xrandr --output eDP-1 --auto --left-of VGA-1 --output VGA-1 --auto")
	, ((mod4Mask .|. shiftMask .|. controlMask, xK_space), spawn "xrandr --output eDP-1 --auto --same-as VGA-1 --output VGA-1 --auto")
	, ((mod4Mask, xK_s), goToSelected $ gsconfig2 greenColorizer)
	, ((mod4Mask, xK_o), spawnSelected defaultGSConfig ["midori","claws-mail","emacsclient -c","netbeans","skype","keepassx"])
--	, ((mod4Mask, xK_w), gridselectWorkspace (\ws -> W.greedyView ws . W.shift ws))
        ]

prettyPrinter :: D.Client -> PP                                                 
prettyPrinter dbus = defaultPP                                                  
    { ppOutput   = dbusOutput dbus                                              
    , ppTitle    = pangoSanitize                                                
    , ppCurrent  = pangoColor "lightgreen" . wrap "[" "]" . pangoSanitize            
    , ppVisible  = pangoColor "yellow" . wrap "(" ")" . pangoSanitize           
    --  , ppHidden   = const ""                                                     
    , ppHidden   = pangoColor "gray" . pangoSanitize
    , ppUrgent   = pangoColor "red"                                             
    , ppLayout   = pangoColor "gray" . pangoSanitize
    , ppSep      = " : "                                                          
    }                                                                           

getWellKnownName :: D.Client -> IO ()                                           
getWellKnownName dbus = do                                                      
  D.requestName dbus (D.busName_ "org.xmonad.Log")                              
                [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()                                                                     
                                                                                
dbusOutput :: D.Client -> String -> IO ()                                       
dbusOutput dbus str = do                                                        
    let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {       
            D.signalBody = [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]
        }                                                                       
    D.emit dbus signal                                                          
                                                                                
pangoColor :: String -> String -> String                                        
pangoColor fg = wrap left right                                                 
  where                                                                         
    left  = "<span foreground=\"" ++ fg ++ "\">"                                
    right = "</span>"                                                           
                                                                                
pangoSanitize :: String -> String                                               
pangoSanitize = foldr sanitize ""                                               
  where                                                                         
    sanitize '>'  xs = "&gt;" ++ xs                                             
    sanitize '<'  xs = "&lt;" ++ xs                                             
    sanitize '\"' xs = "&quot;" ++ xs                                           
    sanitize '&'  xs = "&amp;" ++ xs                                            
    sanitize x    xs = x:xs 
