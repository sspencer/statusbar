# StatusBar

StatusBar is an OS X status indicator app.  It is inspired by [AnyBar](https://github.com/tonsky/AnyBar), but differs by running in a app window rather than the OS X menubar.  The status indictators, free from the confines of the menubar, are much, much larger.  And have labels.  And can have siblings, side by side.  The status indicators are, at least for now, fixed in size (180x180) and only drawn horizontally, left to right.

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

## Sample Client Snippet

Have not checked client code yet, but to test StatusBar, I just lightly modified the [anybar go repo](https://github.com/justincampbell/anybar).

The meat of the code:

```go
const DefaultPort = 9099

func Send(msg string) {
	address := fmt.Sprintf("localhost:%v", DefaultPort)
	conn, err := net.Dial("udp", address)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer conn.Close()

	cnt, err := conn.Write([]byte(msg))
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Printf("Sent %d bytes\n", cnt)
}
```

