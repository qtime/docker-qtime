#/bin/bash

sudo startx &
sudo x11vnc -forever -usepw -display :0 -ultrafilexfer &
