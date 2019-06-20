
Debian
====================
This directory contains files used to package socialnoded/socialnode-qt
for Debian-based Linux systems. If you compile socialnoded/socialnode-qt yourself, there are some useful files here.

## socialnode: URI support ##


socialnode-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install socialnode-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your socialnodeqt binary to `/usr/bin`
and the `../../share/pixmaps/socialnode128.png` to `/usr/share/pixmaps`

socialnode-qt.protocol (KDE)

