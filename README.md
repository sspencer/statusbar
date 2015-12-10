# StatusBar

StatusBar is an OS X status indicator app.  It is inspired by [AnyBar](https://github.com/tonsky/AnyBar), but differs by running in a app window rather than the OS X menubar.  The status indictators, free from the confines of the menubar, are much, much larger.  And have labels.  And can have siblings, side by side.  The status indicators are, at least for now, fixed in size (180x180) and only drawn horizontally, left to right.

Like AnyBar, the indicators can be set by sending a message over UDP.  For no good reason, StatusBar currently runs on UDP Port 9099.  One near term feature enhance is for this to be user settable via the command line.

## Usage

Once launched, send a message from the command line to StatusBar:

    echo -n "red:Tomato,orange:Tangerine,green:Apple" | nc -4u -w0 localhost 9099

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

Any color not understood is rendered as **off**, which shows as a transparent indicator.

StatusBar understands the commands in the following form:

    color1,color2,color3     # one or mores colors

Or

    color1:label1,color2:label2


## Client Support

It is really easy to control StatusBar in the language of your choice.  For example, using a lightly modified version of the [anybar Go client](https://github.com/justincampbell/anybar), you'd just need a function like this:

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

