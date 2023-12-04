package main

import (
	"fmt"
	"os"
	"regexp"
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
	total := 0
	for _, line := range lines {
		id := gameId(line)
		games := games(line)
		maxR := 0
		maxG := 0
		maxB := 0
		for _, game := range games {
			r, g, b := gameValues(game)
			maxR = max(maxR, r)
			maxG = max(maxG, g)
			maxB = max(maxB, b)
		}
		if maxR <= 12 && maxG <= 13 && maxB <= 14 {
			total += id
		}
	}
	fmt.Println(total)
}

func part2() {
	var total int64

	for _, line := range lines {
		games := games(line)
		maxR := 0
		maxG := 0
		maxB := 0
		for _, game := range games {
			r, g, b := gameValues(game)
			maxR = max(maxR, r)
			maxG = max(maxG, g)
			maxB = max(maxB, b)
		}
		power := maxR * maxG * maxB
		total += int64(power)
	}
	fmt.Println(total)
}

func gameId(line string) (id int) {
	fmt.Sscanf(line, "Game %d:", &id)
	return
}

func games(line string) []string {
	re := regexp.MustCompile(`Game \d+: (.*)`)
	matches := re.FindStringSubmatch(line)
	return strings.Split(matches[1], "; ")
}

func gameValues(game string) (int, int, int) {
	r := searchColor(game, "red")
	g := searchColor(game, "green")
	b := searchColor(game, "blue")
	return r, g, b
}

// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
func searchColor(game string, color string) int {
	for _, str := range strings.Split(game, ", ") {
		if strings.Index(str, color) != -1 {
			val := 0
			fmt.Sscanf(str, "%d "+color, &val)
			return val
		}
	}
	return 0
}
