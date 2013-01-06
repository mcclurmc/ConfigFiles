import Control.Monad
import Data.List
import Data.Ratio ((%))
import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.Volume
import XMonad.Actions.Warp
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers -- (isFullscreen,doFullFloat)
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- gnomeConfig {
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad gnomeConfig {
         terminal   = "gnome-terminal"
       , borderWidth = 2  
       --, normalBorderColor = "#abc123"  
       , focusedBorderColor = "#456def"         
       , modMask    = mod4Mask
       , layoutHook = myLayout2
       , keys       = newKeys
       , manageHook = myManageHook
       , startupHook= startup
       , logHook    = dynamicLogWithPP xmobarPP { 
           ppOutput = hPutStrLn xmproc ,
           ppTitle  = xmobarColor "green" "" . shorten 50
         }

       }

myLayout =
  smartBorders (layoutHook gnomeConfig)
--  smartBorders (layoutHook defaultConfig)
--  ||| ThreeCol 1 (3/100) (4/5)
  ||| ThreeColMid 1 (3/100) (4/5)
  -- withIM (1%7) (ClassName "Pidgin") Grid 
  |||
  avoidStruts (tall ||| (smartBorders simpleTabbed))
    where tall = Tall 1 (5/100) (1/2)

myLayout2 = avoidStruts $ 
                smartBorders (layoutHook gnomeConfig) 
            ||| smartBorders simpleTabbed
            ||| ThreeColMid 1 (3/100) (4/5)

newKeys x  = M.union (M.fromList (myKeys x)) (keys defaultConfig x)

myKeys conf@(XConfig {XMonad.modMask = modm}) =
    [ ((modm, xK_bracketleft), prevWS)
    , ((modm, xK_bracketright), nextWS)
    -- , ((0, xF86XK_Sleep), spawn "sudo pm-suspend")
    -- , ((0, xF86XK_AudioRaiseVolume), raiseVolume 4 >> return ())
    -- , ((0, xF86XK_AudioLowerVolume), lowerVolume 4 >> return ())
    -- , ((0, xK_Pause), spawn "gnome-screensaver-command -a")
    , ((modm, xK_j), windows W.focusUp)
    , ((modm, xK_k), windows W.focusDown)
    , ((modm .|. shiftMask, xK_j), windows W.swapUp)
    , ((modm .|. shiftMask, xK_k), windows W.swapDown)
    , ((modm, xK_grave), toggleWS)
    , ((modm, xK_b), sendMessage ToggleStruts)
      -- bottom middle of current window
    , ((modm, xK_semicolon), warpToWindow (1/2) 1)
      -- middle of current window
    , ((modm, xK_quoteright), warpToWindow (1/2) (1/2))
    ]

myManageHook = composeAll [
    -- manageHook gnomeConfig
    -- needs: import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat)
    isFullscreen --> doFullFloat
    -- other hooks,
  -- , className =? "Unity-2d-panel"    --> doIgnore
  -- , className =? "Unity-2d-launcher" --> doIgnore
    -- more hooks for floating windows
  , isDialog --> doFloat
  , isDialog --> insertPosition Above Older
  , className =? "dmenu" --> doFloat
  , className =? "Gimp" --> doFloat
  , className =? "mplayer2" --> doFloat
  , title =? "Eclipse Platform" --> doFloat
  , title =? "VNC: QEMU" --> doFloat
  , title =? "Thunderbird Preferences" --> doFloat
  , insertPosition Above Newer
  , manageDocks
  ]

startup = do
  --runOrRaise "gnome-terminal" (title =? "Terminal")
  runOrRaise "emacsclient -c" (className =? "emacs")
