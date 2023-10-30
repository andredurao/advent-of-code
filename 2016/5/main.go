package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"os"
	"strconv"
)

// usage ./main abc
func main() {
	part1()
	part2()
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

func part2() {
	room := os.Args[1]
	passwd := make([]rune, 8)
	start := 0
	size := 0
	for size < 8 {
		str, i := lookupChar(room, start)
		// fmt.Println(str, i)
		index, err := strconv.Atoi(string(str[5]))
		if index < 8 && passwd[index] == 0 && err == nil {
			size++
			passwd[index] = rune(str[6])
		}
		start = i + 1
	}
	fmt.Println(string(passwd))
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
