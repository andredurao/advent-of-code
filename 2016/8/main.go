package main

import (
	"fmt"
	"os"
	"strings"
)

var lines []string
var screen [][]byte
var functionsMap map[string]func([]string)

const Height = 6
const Width = 50

func main() {
	readLines()
	initScreen()
	functionsMap = make(map[string]func([]string), 0)
	functionsMap["rect"] = rect
	functionsMap["rotate"] = rotate
	part1()
	part2()
}

func readLines() {
	filename := os.Args[1]
	content, _ := os.ReadFile(filename)
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func initScreen() {
	screen = make([][]byte, Height)
	for i := 0; i < Height; i++ {
		screen[i] = make([]byte, Width)
	}
}

func printScreen() {
	for i := 0; i < Height; i++ {
		for j := 0; j < Width; j++ {
			ch := ""
			if screen[i][j] == 0 {
				ch = " "
			} else {
				ch = "#"
			}
			fmt.Printf("%s", ch)
		}
		fmt.Printf("\n")
	}
}

func part1() {
	for _, line := range lines {
		parse(line)
	}
	total := 0
	for i := 0; i < Height; i++ {
		for j := 0; j < Width; j++ {
			if screen[i][j] != 0 {
				total++
			}
		}
	}
	fmt.Println("part1", total)
}

func part2() {
	fmt.Println("part2")
	printScreen()
}

func parse(line string) {
	tokens := strings.Split(line, " ")
	fn := functionsMap[tokens[0]]
	fn(tokens)
}

func rect(args []string) {
	var x, y int
	_, err := fmt.Sscanf(args[1], "%dx%x", &x, &y)
	if err != nil {
		panic(err)
	}
	for i := 0; i < y; i++ {
		for j := 0; j < x; j++ {
			screen[i][j] = 1
		}
	}
}

func rotate(args []string) {
	if args[1] == "column" {
		// rotate column x=1 by 1
		x := 0
		shift := 0
		fmt.Sscanf(args[2], "x=%d", &x)
		fmt.Sscanf(args[4], "%d", &shift)
		tmp := make([]byte, Height)
		for i := 0; i < Height; i++ {
			index := (i + shift) % Height
			tmp[index] = screen[i][x]
		}
		for i := 0; i < Height; i++ {
			screen[i][x] = tmp[i]
		}
	} else if args[1] == "row" {
		// rotate row y=0 by 4
		y := 0
		shift := 0
		fmt.Sscanf(args[2], "y=%d", &y)
		fmt.Sscanf(args[4], "%d", &shift)
		tmp := make([]byte, Width)
		for i := 0; i < Width; i++ {
			index := (i + shift) % Width
			tmp[index] = screen[y][i]
		}
		for i := 0; i < Width; i++ {
			screen[y][i] = tmp[i]
		}
	}
}
