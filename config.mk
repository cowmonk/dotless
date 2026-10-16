# 
# dotless - make configuration
# cowmonk <cowmonk@based.pt>
#

# paths
PREFIX ?= /
TOP     = $(PWD)
SRCDIR  = $(TOP)/sources
EXTDIR  = $(TOP)/extracted

# Optional configurations
LAPTOP  ?= 0  # laptop mode enables certain keybinds and battery monitoring
YASH    ?= 0  # install yash configuration
SCRIPTS ?= 0  # whether or not to install the useful scripts (auto enable if laptop mode is enabled)
VOL     ?= 0  # default volume step percent (default is 5 when at 0)
BSD     ?= 0  # enables support for the BSDs (in config.mk and stuff)
MIXER   ?= 0  # /dev/mixer support, if not then it falls back to amixer hacky script (only on linux)
FONT    ?= "" # set the global font for dmenu, and dwm (default: cozette:size=10)
ST_FONT ?= "" # set the font for st (default: cozette:size=12).

# very very optional configuration
NOUSR ?= 0 # specifically for my suckless systems where I do not have a /usr

# dwm
VER_dwm  = 6.8
NAME_dwm = dwm-$(VER_dwm)
URL_dwm  = https://dl.suckless.org/dwm/$(NAME_dwm).tar.gz

# st
VER_st  = 0.9.3
NAME_st = st-$(VER_st)
URL_st  = https://dl.suckless.org/st/$(NAME_st).tar.gz

# dmenu
VER_dmenu  = 5.4
NAME_dmenu = dmenu-$(VER_dmenu)
URL_dmenu  = https://dl.suckless.org/tools/$(NAME_dmenu).tar.gz

# slstatus
VER_slstatus  = 1.1
NAME_slstatus = slstatus-$(VER_slstatus)
URL_slstatus  = https://dl.suckless.org/tools/$(NAME_slstatus).tar.gz

# make program
MAKE = make

# compiler
CC = cc
