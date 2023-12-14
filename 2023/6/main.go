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
	part2()
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

func part2() {
	fmt.Println("part 2")

	time := getNumber(lines[0])
	record := getNumber(lines[1])

	i := 0
	for {
		d := getDistance(i, time)
		if d > record {
			// as soon as we got the first value we can stop because the
			// same amount of distances that will be smaller than the record
			// will also be present on the right side of the values
			// the values grow as a inverted parabola
			break
		}
		i++
	}

	// for t=9, if the 1st value to beat the record is 2
	// there will be also 2 values on the right end that will not reach the record
	// 0 1 2 3 4 5 6 7 8 9
	// X X i i i i i i x x
	res := time - (i * 2) + 1

	fmt.Println(res)
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

func getNumber(line string) int {
	re := regexp.MustCompile(`\d+`)
	val, _ := strconv.Atoi(strings.Join(re.FindAllString(line, -1), ""))
	return val
}
