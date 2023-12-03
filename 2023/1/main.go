package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

var lines []string

// usage ./main filename
func main() {
	readlines()
	part1()
}

func readlines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func part1() {
	total := 0
	for _, line := range lines {
		// fmt.Println(line, calibrationValue(line))
		total += calibrationValue(line)
	}
	fmt.Println(total)
}

func calibrationValue(line string) int {
	valueStr := ""
	// search left
	for i := 0; i < len(line); i++ {
		r := line[i]
		if r >= '0' && r <= '9' {
			valueStr += string(r)
			break
		}
	}
	// search right
	for i := len(line) - 1; i >= 0; i-- {
		r := line[i]
		if r >= '0' && r <= '9' {
			valueStr += string(r)
			break
		}
	}
	res, _ := strconv.Atoi(valueStr)
	return res
}
