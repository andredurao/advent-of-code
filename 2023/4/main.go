package main

import (
	"fmt"
	"os"
	"regexp"
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
	fmt.Println("part 1")

	res := 0

	for _, line := range lines {
		start := strings.Index(line, ":")
		bar := strings.Index(line, "|")
		winningNumbers := getNumbers(line[start+2 : bar-1])
		numbersSet := map[int]struct{}{}
		for _, n := range winningNumbers {
			numbersSet[n] = struct{}{}
		}
		base := 0
		for _, n := range getNumbers(line[bar+2:]) {
			_, found := numbersSet[n]
			if found {
				base++
			}
		}
		// fmt.Println(line, winningNumbers, base)
		if base > 0 {
			res += 1 << (base - 1)
		}
	}
	fmt.Println(res)
}

func getNumbers(str string) []int {
	res := []int{}
	re := regexp.MustCompile(`\d+`)
	for _, n := range re.FindAllString(str, -1) {
		val, _ := strconv.Atoi(n)
		res = append(res, val)
	}
	return res
}
