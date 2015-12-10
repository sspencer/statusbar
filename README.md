# StatusBar

StatusBar is an OS X status indicator app.  It is inspired by [AnyBar](https://github.com/tonsky/AnyBar), but differs by running in a app rather than the OS X menubar.  The status indictators, free from the confines of the menubar, are much, much larger.  And have labels.  And can have siblings, side by side.

Like AnyBar, the indicators can be set by sending a message over UDP.  For no good reason, StatusBar currently runs on UDP Port 9099.  One near term feature enhance is for this to be user settable via the command line.  

## Usage

StatusBar understands the commands in the following form:

    color1,color2,color3     # one or mores colors

Or

    color1:label1,color2:label2

Or any combination of the above.

For example:

    $ go run status.go "red:Tomato,orange:Tangerine,green:Apple"

Produces:

<img src="screenshot.png?raw=true" />    

The following colors are understood:

* black
* blue
* cyan
* green
* magenta
* orange
* purple
* red
* yellow
* off
