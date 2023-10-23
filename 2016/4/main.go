package main

import (
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

func main() {
	part1()
}

func part1() {
	total := 0
	for _, room := range lines() {
		sector, valid := isValidChecksum(room)
		fmt.Println(room, valid)
		if valid {
			total += sector
		}
	}
	fmt.Println(total)
}

func isValidChecksum(room string) (int, bool) {
	re := regexp.MustCompile(`(\w+)`)
	words := re.FindAllString(room, -1)
	valid := words[len(words)-1] == generateChecksum(words)
	sector, _ := strconv.Atoi(words[len(words)-2])
	return sector, valid
}

func generateChecksum(words []string) string {
	charMap := make(map[rune]int, 0)
	for i, word := range words {
		if i == len(words)-2 {
			break
		}
		for _, char := range word {
			_, found := charMap[rune(char)]
			if !found {
				charMap[rune(char)] = 1
			} else {
				charMap[rune(char)]++
			}
		}
	}

	charsCount := make([][]int, 0)
	for char, count := range charMap {
		charsCount = append(charsCount, []int{int(char), count})
	}

	sort.Slice(
		charsCount,
		func(i, j int) bool {
			return charsCount[i][1] > charsCount[j][1] ||
				(charsCount[i][1] == charsCount[j][1] && charsCount[i][0] < charsCount[j][0])
		},
	)
	result := ""
	for i := 0; i < 5; i++ {
		result += string(charsCount[i][0])
	}
	return result
}

func lines() []string {
	content, _ := os.ReadFile(os.Args[1])
	result := make([]string, 0)
	for _, line := range strings.Split(string(content), "\n") {
		if len(line) == 0 {
			break
		}
		result = append(result, line)
	}
	return result
}
