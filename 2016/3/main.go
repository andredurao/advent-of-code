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
	part2()
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

func part2() {
	content, _ := os.ReadFile("input")
	lines := strings.Split(string(content), "\n")
	trianglesArray := make([][]int, 0)
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
		trianglesArray = append(trianglesArray, sides)
	}

	count := 0
	for i := 0; i < len(trianglesArray)/3; i++ {
		row := i * 3
		for j := 0; j < 3; j++ {
			triangle := []int{
				trianglesArray[row][j],
				trianglesArray[row+1][j],
				trianglesArray[row+2][j],
			}
			if validTriangle(triangle) {
				count++
			}
		}
	}
	fmt.Println(count)
}

func validTriangle(sides []int) bool {
	return !(((sides[0] + sides[1]) <= sides[2]) ||
		((sides[0] + sides[2]) <= sides[1]) ||
		((sides[1] + sides[2]) <= sides[0]))
}
