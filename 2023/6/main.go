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
}

func readlines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func part1() {
	fmt.Println("part 1")

	times := getNumbers(lines[0])
	records := getNumbers(lines[1])

	total := 1
	for race := range times {
		ways := 0
		for i := 0; i <= times[race]; i++ {
			d := getDistance(i, times[race])
			if d > records[race] {
				ways++
			}
		}
		total *= ways
	}
	fmt.Println(total)

}

func getDistance(t int, limit int) int {
	return (limit - t) * t
}

func getNumbers(line string) []int {
	res := []int{}
	re := regexp.MustCompile(`\d+`)
	for _, number := range re.FindAllString(line, -1) {
		val, _ := strconv.Atoi(number)
		res = append(res, val)
	}
	return res
}
