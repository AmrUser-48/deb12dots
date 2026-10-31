#   disable log .xsessionerrors
#  exec 2>/dev/null

  xrdb ~/.Xresources


#   Fonts
  xset +fp ~/.fonts/terminus-powerline/pcf/
  xset fp rehash


#   Color calib
  xrandr --output LVDS-1 --brightness .82
  xrandr --output LVDS1 --brightness .82


#   Mouse & Keyboard {{{
  #xinput --set-prop 'SiliconWin mouse' 'libinput Accel Profile Enabled' 0 1

# Kbd linux like
  xset r rate 230 30

#   Nat scroll, inertscroll
# synclient VertScrollDelta=-25 CoastingSpeed=0
# synclient TapButton1=1
# synclient ClickPad=0

# synclient PalmDetect=0 
# synclient PalmMinWidth=0 
# synclient PalmMinZ=0
# synclient GrabEventDevice=1

# synclient MaxDoubleTapTime=0
# synclient SingleTapTimeout=0

#   }}}

 

#   WINDOW MANAGER
#  exec dbus-launch --sh-syntax --exit-with-session openbox-session
#  exec herbstluftwm
#  ROX  don't have confs
#  exec rox --pinboard=je & exec openbox-session
  exec openbox-session



#   vi: ts=2 sw=2 ft=sh
