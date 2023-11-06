// https://adventofcode.com/2016/day/9
package main

import (
	"fmt"
	"os"
	"strings"
)

var lines []string

// usage ./main filename
func main() {
	readLines()
	part1()
}

func readLines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func part1() {
	fmt.Printf("%v\n", lines)
	for _, line := range lines {
		str := decompress(line)
		fmt.Println(str, len(str))
	}
}

func decompress(line string) string {
	result := ""
	markerString := ""
	inMarker := false
	markerSize := -1
	markerCounter := -1
	markerBlock := -1
	for _, c := range line {
		if inMarker {
			if c == ')' {
				inMarker = false
				fmt.Sscanf(markerString, "%dx%d", &markerCounter, &markerBlock)
				markerSize = markerCounter
				markerString = ""
			} else {
				markerString = markerString + string(c)
			}
		} else {
			if c == '(' && markerCounter <= 0 {
				inMarker = true
			} else {
				result = result + string(c)
				markerCounter--
				if markerCounter == 0 {
					block := result[len(result)-markerSize:]
					for i := 0; i < markerBlock-1; i++ {
						result = result + block
					}
				}
			}
		}
	}

	return result
}
