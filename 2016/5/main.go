package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"os"
)

// usage ./main abc
func main() {
	part1()
}

func part1() {
	room := os.Args[1]
	passwd := ""
	start := 0
	for len(passwd) < 8 {
		str, i := lookupChar(room, start)
		// fmt.Println(str, i)
		passwd = passwd + string(str[5])
		start = i + 1
	}
	fmt.Println(passwd)
}

func lookupChar(room string, start int) (string, int) {
	i := start
	for {
		h := md5.New()
		test := fmt.Sprintf("%s%d", room, i)
		io.WriteString(h, test)
		str := fmt.Sprintf("%x", h.Sum(nil))
		if str[0:5] == "00000" {
			return str, i
		}
		i++
	}
}
