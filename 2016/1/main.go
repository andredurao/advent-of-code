package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

var Dirs = []string{"N", "E", "S", "W"}

func main() {
	path := parseInput()
	// path := []string{"R2", "L3"}
	// path := []string{"R5", "L5", "R5", "R3"}

	dir := "N"
	pos := []int{0, 0}
	for _, item := range path {
		dir = changeDirection(dir, string(item[0]))
		blocks, _ := strconv.Atoi(item[1:])
		walk(&pos, dir, blocks)
		// fmt.Println(dir, pos, blocks, item)
	}

	dist := int(math.Abs(float64(pos[0])) + math.Abs(float64(pos[1])))
	fmt.Println(pos, dist)
}

func parseInput() []string {
	line, _ := os.ReadFile("input")
	fileContent := string(line)
	fileContent = strings.TrimRight(fileContent, "\r\n")
	return strings.Split(fileContent, ", ")
}

func changeDirection(dir string, turn string) string {
	dirMap := make(map[string]int)
	dirMap["N"] = 0
	dirMap["E"] = 1
	dirMap["S"] = 2
	dirMap["W"] = 3

	dirIndex := dirMap[dir]

	if turn == "R" {
		dirIndex++
	} else {
		dirIndex--
	}

	return Dirs[(dirIndex+4)%4]
}

func walk(pos *[]int, dir string, blocks int) {
	dirMap := make(map[string][]int)
	dirMap["N"] = []int{0, 1}
	dirMap["E"] = []int{1, 0}
	dirMap["S"] = []int{0, -1}
	dirMap["W"] = []int{-1, 0}

	(*pos)[0] += blocks * dirMap[dir][0]
	(*pos)[1] += blocks * dirMap[dir][1]
}
