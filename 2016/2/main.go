package main

import (
	"fmt"
	"os"
	"strings"
)

var Moves = make(map[rune][]int)

func main() {
	Moves['U'] = []int{0, -1}
	Moves['R'] = []int{1, 0}
	Moves['D'] = []int{0, 1}
	Moves['L'] = []int{-1, 0}

	part1()
	part2()
}

func part1() {
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
			move, _ := Moves[ch]
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

func part2() {
	keypad := [][]rune{
		{' ', ' ', '1', ' ', ' '},
		{' ', '2', '3', '4', ' '},
		{'5', '6', '7', '8', '9'},
		{' ', 'A', 'B', 'C', ' '},
		{' ', ' ', 'D', ' ', ' '},
	}
	pos := []int{0, 2}
	code := ""
	content, _ := os.ReadFile("input")
	instructions := strings.Split(string(content), "\n")
	for _, line := range instructions {
		if len(line) == 0 {
			break
		}
		for _, ch := range line {
			move, _ := Moves[ch]
			newPos := []int{pos[0] + move[0], pos[1] + move[1]}
			// fmt.Println(string(ch), pos, newPos)
			if newPos[0] < 0 || newPos[1] < 0 || newPos[0] > 4 || newPos[1] > 4 || keypad[newPos[1]][newPos[0]] == ' ' {
				continue
			}
			pos = newPos
		}
		code = code + string(keypad[pos[1]][pos[0]])
	}
	fmt.Println(code)
}
