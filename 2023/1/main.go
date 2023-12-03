package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

var lines []string
var valuesMap = map[string]int{
	"zero":  0,
	"one":   1,
	"two":   2,
	"three": 3,
	"four":  4,
	"five":  5,
	"six":   6,
	"seven": 7,
	"eight": 8,
	"nine":  9,
}

// usage ./main filename
func main() {
	readlines()
	part1()
	part2()
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

func part2() {
	total := 0
	for _, line := range lines {
		l := leftValue(line)
		r := rightValue(line)
		// fmt.Println(line, l, r, (l*10)+r)
		total += (l * 10) + r
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

func leftValue(line string) int {
	leftIdx := 0
	valueStr := ""
	// search left
	for i := 0; i < len(line); i++ {
		r := line[i]
		if r >= '0' && r <= '9' {
			valueStr = string(r)
			leftIdx = i
			break
		}
	}

	minIndex := len(line)
	textVal := -1
	for str := range valuesMap {
		idx := strings.Index(line, str)
		if idx != -1 && idx < minIndex {
			textVal = valuesMap[str]
			minIndex = idx
		}
	}

	if minIndex < leftIdx || len(valueStr) == 0 {
		return textVal
	}

	res, _ := strconv.Atoi(valueStr)
	return res
}

func rightValue(line string) int {
	rightIdx := 0
	valueStr := ""
	// search right
	for i := len(line) - 1; i >= 0; i-- {
		r := line[i]
		if r >= '0' && r <= '9' {
			valueStr = string(r)
			rightIdx = i
			break
		}
	}

	maxIndex := 0
	textVal := -1
	for str := range valuesMap {
		idx := strings.LastIndex(line, str)
		if idx != -1 && idx > maxIndex {
			textVal = valuesMap[str]
			maxIndex = idx
		}
	}

	if maxIndex > rightIdx || len(valueStr) == 0 {
		return textVal
	}

	res, _ := strconv.Atoi(valueStr)
	return res
}
