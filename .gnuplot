# Gruvbox dark palette
GRUV_BG      = "#282828"
GRUV_BG_DARK = "#1d2021"
GRUV_FG      = "#ebdbb2"
GRUV_MUTED   = "#a89984"
#GRUV_GRID    = "#504945"
GRUV_GRID    = "#665c54"

GRUV_RED     = "#fb4934"
GRUV_GREEN   = "#b8bb26"
GRUV_YELLOW  = "#fabd2f"
GRUV_BLUE    = "#83a598"
GRUV_PURPLE  = "#d3869b"
GRUV_AQUA    = "#8ec07c"
GRUV_ORANGE  = "#fe8019"

set grid xtics ytics lc rgb GRUV_FG lw 1 dashtype 2 front
# Plot background
#set object 1 rectangle \
#    from screen 0,0 to screen 1,1 \
#    behind \
#    fillcolor rgb GRUV_BG \
#    noborder

GRUV_BG = "0x282828"
set object 1 rectangle from screen 0,0 to screen 1,1 behind fc rgb "#282828"




# Text, axes, and grid
set border lc rgb GRUV_MUTED lw 1
set tics textcolor rgb GRUV_FG
set xlabel textcolor rgb GRUV_FG
set ylabel textcolor rgb GRUV_FG
set zlabel textcolor rgb GRUV_FG
set title textcolor rgb GRUV_FG
set key textcolor rgb GRUV_FG

set grid xtics ytics \
    lc rgb GRUV_GRID \
    lw 1 \
    dashtype 2 \
#    font

# Gruvbox line colors
set linetype 1 lc rgb GRUV_RED    lw 2
set linetype 2 lc rgb GRUV_GREEN  lw 2
set linetype 3 lc rgb GRUV_YELLOW lw 2
set linetype 4 lc rgb GRUV_BLUE   lw 2
set linetype 5 lc rgb GRUV_PURPLE lw 2
set linetype 6 lc rgb GRUV_AQUA   lw 2
set linetype 7 lc rgb GRUV_ORANGE lw 2
set linetype 8 lc rgb GRUV_FG     lw 2

set linetype cycle 8

#For terminals that support a background option, you can also set it explicitly, for example:

#```gnuplot
set terminal pngcairo background rgb GRUV_BG
#```

#For interactive Qt:

#```gnuplot
set terminal wxt background rgb "#282828"
#set terminal x11 background rgb "#282828"

# vim ft=conf
