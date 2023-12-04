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
	// repo := make([][]int, len(lines))
	res := 0
	neighborsMap := map[string]int{}

	for i, line := range lines {
		// fmt.Println("line =>", line)
		for j, ch := range line {
			if isSymbol(ch) {
				// fmt.Println("symbol!", string(ch), i, j)
				pos := []int{i, j}
				for _, neighbor := range neighbors(pos) {
					if isValisPos(neighbor) && isDigit(neighbor) {
						storeNumber(neighbor, neighborsMap)
					}
				}
			}
		}
	}
	for _, v := range neighborsMap {
		// fmt.Println("vals =>", k, v)
		res += v
	}
	fmt.Println(res)
}

func storeNumber(pos []int, neighborsMap map[string]int) {
	start := pos[1]
	for start >= 0 {
		ch := lines[pos[0]][start]
		if ch < '0' || ch > '9' {
			start++
			break
		}
		start--
	}
	if start == -1 {
		start = 0
	}
	end := start
	for end < len(lines[pos[0]]) {
		ch := lines[pos[0]][end]
		if ch < '0' || ch > '9' {
			break
		}
		end++
	}

	numberStr := ""
	if end == len(lines[pos[0]]) {
		numberStr = lines[pos[0]][start:]
	} else {
		numberStr = lines[pos[0]][start:end]
	}

	value, _ := strconv.Atoi(numberStr)
	key := fmt.Sprintf("%d-[%d:%d]", pos[0], start, end)
	neighborsMap[key] = value
}

func isSymbol(ch rune) bool {
	symbols := []rune{'@', '#', '$', '%', '^', '&', '*', '-', '=', '+', '/'}
	for _, symbol := range symbols {
		if ch == symbol {
			return true
		}
	}
	return false
}

// i, j pos of the symbol
func neighbors(pos []int) [][]int {
	surroundings := [][]int{{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}}
	res := make([][]int, 8)
	for i, delta := range surroundings {
		res[i] = []int{pos[0] + delta[0], pos[1] + delta[1]}
	}

	return res
}

func isValisPos(pos []int) bool {
	return pos[0] >= 0 && pos[0] < len(lines) && pos[1] >= 0 && pos[1] < len(lines[pos[0]])
}

func isDigit(pos []int) bool {
	ch := lines[pos[0]][pos[1]]
	return ch >= '0' && ch <= '9'
}
