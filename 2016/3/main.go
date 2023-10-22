package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	part1()
}

func part1() {
	content, _ := os.ReadFile("input")
	lines := strings.Split(string(content), "\n")
	count := 0
	for _, line := range lines {
		if len(line) == 0 {
			continue
		}
		re := regexp.MustCompile(`\d+`)
		ss := re.FindAllString(line, -1)
		sides := make([]int, 3)
		for i, side := range ss {
			sides[i], _ = strconv.Atoi(side)
		}
		if validTriangle(sides) {
			count++
		}
	}
	fmt.Println(count)
}

func validTriangle(sides []int) bool {
	return !(((sides[0] + sides[1]) <= sides[2]) ||
		((sides[0] + sides[2]) <= sides[1]) ||
		((sides[1] + sides[2]) <= sides[0]))
}
