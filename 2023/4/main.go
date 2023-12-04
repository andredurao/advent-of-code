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
	part2()
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

func part2() {
	fmt.Println("part 2")

	cardCounts := make([]int, len(lines))
	for i := range lines {
		cardCounts[i] = 1
	}

	for i, line := range lines {
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
		if base > 0 {
			for j := 0; j < base; j++ {
				cardCounts[i+1+j] += cardCounts[i]
			}
		}
	}
	res := 0
	for _, val := range cardCounts {
		res += val
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
