package main

import (
	"fmt"
	"os"
	"strings"
)

var lines []string

// usage ./main filename
func main() {
	part1()
	part2()
}

func part1() {
	filename := os.Args[1]
	content, _ := os.ReadFile(filename)
	lines = strings.Split(string(content), "\n")

	code := ""
	for i := range lines[0] {
		charMap := frequencies(lines, i)
		code = code + string(mostFrequentChar(charMap))
	}
	fmt.Println(code)
}

func part2() {
	filename := os.Args[1]
	content, _ := os.ReadFile(filename)
	lines = strings.Split(string(content), "\n")

	code := ""
	for i := range lines[0] {
		charMap := frequencies(lines, i)
		code = code + string(leastFrequentChar(charMap))
	}
	fmt.Println(code)
}

func frequencies(lines []string, col int) (charMap map[rune]int) {
	charMap = make(map[rune]int, 0)

	for _, line := range lines {
		if len(line) == 0 {
			break
		}
		char := rune(line[col])
		_, found := charMap[char]
		if found {
			charMap[char]++
		} else {
			charMap[char] = 1
		}
	}
	return
}

func mostFrequentChar(charMap map[rune]int) rune {
	max := 0
	result := '0'
	for char, count := range charMap {
		if count > max {
			result = char
			max = count
		}
	}
	return result
}

func leastFrequentChar(charMap map[rune]int) rune {
	min := 0
	result := '0'
	for char, count := range charMap {
		if count < min || min == 0 {
			result = char
			min = count
		}
	}
	return result
}
