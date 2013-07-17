termnotify
================
Demonstrate how to post NStermnotify from CLI(without Application Bundle) on OS X 10.8.

Install
-------
Clone repository and install `/usr/local/bin/termnotify`

	git clone https://github.com/derek-wangpch/termnotify.git
	cd termnotify
	sudo xcrun xcodebuild clean install DSTROOT=/

Or use

    cc -framework foundation main.c -o termnotify

Usage
-----

	Usage: termnotify  [--title <title>] [--subtitle <subtitle>] [--message <text>] [--identifier <identifier>]
	
	Options:
	   -i, --identifier NAME        some existing app identifier(default: com.apple.terminal)
	   -t, --title TEXT             title text
	   -s, --subtitle TEXT          subtitle text
	   -i, --informativeText TEXT   informative text

License
-------

	(The WTFPL)
	
	            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
	                    Version 2, December 2004
	
	 Copyright (C) 2013 Derek Wang
	
	 Everyone is permitted to copy and distribute verbatim or modified
	 copies of this license document, and changing it is allowed as long
	 as the name is changed.
	
	            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
	   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
	
	  0. You just DO WHAT THE FUCK YOU WANT TO.
