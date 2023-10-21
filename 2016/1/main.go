package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

var Dirs = []string{"N", "E", "S", "W"}
var DirMap = make(map[string][]int)

func main() {
	DirMap["N"] = []int{0, 1}
	DirMap["E"] = []int{1, 0}
	DirMap["S"] = []int{0, -1}
	DirMap["W"] = []int{-1, 0}

	part1()
	part2()
}

func part1() {
	path := parseInput()
	// path := []string{"R2", "L3"}
	// path := []string{"R5", "L5", "R5", "R3"}
	dir := "N"
	pos := []int{0, 0}
	for _, item := range path {
		dir = changeDirection(dir, string(item[0]))
		blocks, _ := strconv.Atoi(item[1:])
		walk(&pos, dir, blocks)
	}

	dist := int(math.Abs(float64(pos[0])) + math.Abs(float64(pos[1])))
	fmt.Println("part1", pos, dist)
}

func part2() {
	path := parseInput()
	// path := []string{"R8", "R4", "R4", "R8"}

	visitMap := make(map[string]bool)

	dir := "N"
	pos := []int{0, 0}
	posCoords := fmt.Sprintf("%d,%d", pos[0], pos[1])
	visitMap[posCoords] = true
	for _, item := range path {
		dir = changeDirection(dir, string(item[0]))
		blocks, _ := strconv.Atoi(item[1:])
		for i := 0; i < blocks; i++ {
			pos[0] += DirMap[dir][0]
			pos[1] += DirMap[dir][1]
			// fmt.Println(pos)
			posCoords = fmt.Sprintf("%d,%d", pos[0], pos[1])
			_, found := visitMap[posCoords]
			if found {
				dist := int(math.Abs(float64(pos[0])) + math.Abs(float64(pos[1])))
				fmt.Println("part2", pos, dist)
				return
			} else {
				visitMap[posCoords] = true
			}
		}
	}

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
	(*pos)[0] += blocks * DirMap[dir][0]
	(*pos)[1] += blocks * DirMap[dir][1]
}
