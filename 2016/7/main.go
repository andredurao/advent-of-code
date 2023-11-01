package main

import (
	"fmt"
	"os"
	"strings"
)

var lines []string

// usage ./main filename
func main() {
	ReadLines()
	Part1()
}

func ReadLines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:(len(lines) - 1)]
}

func Part1() {
	total := 0
	for _, line := range lines {
		if isTLS(line) {
			total++
		}
	}
	fmt.Println(total)
}

func isTLS(line string) bool {
	blocks := splitLine(line)
	// fmt.Printf("%s -> %v\n", line, blocks)
	// strings inside square braces
	for _, block := range blocks[1] {
		if hasAbba(block) {
			return false
		}
	}

	// strings outside square braces
	for _, block := range blocks[0] {
		if hasAbba(block) {
			return true
		}
	}

	return false
}

func splitLine(line string) [][]string {
	result := make([][]string, 2)
	result[0] = []string{}
	result[1] = []string{}
	inSquareIndex := 0
	tmp := ""
	for _, ch := range line {
		if ch == '[' || ch == ']' {
			result[inSquareIndex] = append(result[inSquareIndex], tmp)
			inSquareIndex = (inSquareIndex + 1) % 2
			tmp = ""
		} else {
			tmp = tmp + string(ch)
		}
	}
	result[inSquareIndex] = append(result[inSquareIndex], tmp)
	return result
}

func hasAbba(str string) bool {
	if len(str) < 4 {
		return false
	}

	for i := 0; i+4 <= len(str); i++ {
		subStr := str[i : i+4]
		if subStr[0] == subStr[3] && subStr[1] == subStr[2] && subStr[0] != subStr[1] {
			return true
		}
	}

	return false
}
