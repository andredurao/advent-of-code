package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	part1()
}

func part1() {
	moves := make(map[rune][]int)
	moves['U'] = []int{0, -1}
	moves['R'] = []int{1, 0}
	moves['D'] = []int{0, 1}
	moves['L'] = []int{-1, 0}

	keypad := [][]rune{
		{'1', '2', '3'},
		{'4', '5', '6'},
		{'7', '8', '9'},
	}
	pos := []int{1, 1}
	code := ""
	content, _ := os.ReadFile("input")
	instructions := strings.Split(string(content), "\n")
	for _, line := range instructions {
		if len(line) == 0 {
			break
		}
		for _, ch := range line {
			move, _ := moves[ch]
			newPos := []int{pos[0] + move[0], pos[1] + move[1]}
			if newPos[0] < 0 || newPos[1] < 0 || newPos[0] > 2 || newPos[1] > 2 {
				continue
			}
			pos = newPos
		}
		code = code + string(keypad[pos[1]][pos[0]])
	}
	fmt.Println(code)
}
