// https://adventofcode.com/2016/day/9
package main

import (
	"fmt"
	"os"
	"strings"
)

var lines []string

// usage ./main filename
func main() {
	readLines()
	// part1()
	part2()
}

func readLines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func part1() {
	for _, line := range lines {
		str := decompress(line)
		fmt.Println(str, len(str))
	}
}

func part2() {
	// won't scale
	// line := "X(8x2)(3x3)ABCY"
	// for strings.Contains(line, "(") {
	// 	line = decompress(line)
	// 	fmt.Println(line)
	// }

	// X(8x2)(3x3)ABCY
	// packs := [][]int{{1, 0, 0}, {5, 8, 2}, {5, 3, 3}, {4, 0, 0}}
	// (27x12)(20x12)(13x14)(7x10)(1x12)A
	// packs := [][]int{{7, 27, 12}, {7, 20, 12}, {7, 13, 14}, {6, 7, 10}, {6, 1, 12}, {1, 0, 0}}
	// (25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN
	packs := [][]int{{6, 25, 3}, {5, 3, 3}, {3, 0, 0}, {5, 2, 3}, {2, 0, 0}, {5, 5, 2}, {6, 0, 0}, {6, 18, 9}, {5, 3, 2}, {3, 0, 0}, {5, 5, 7}, {5, 0, 0}}
	// result := unpack(packs)
	// fmt.Printf("%v\n", packs)
	// fmt.Printf("%v\n", result)

	for hasBlock(&packs) {
		packs = unpack(packs)
		fmt.Printf("=> %v\n", packs)
	}

	total := 0
	for _, pack := range packs {
		total = total + pack[0]
	}
	fmt.Println(total)

	// XABCABCABCABCABCABCY XABCABCABCABCABCABCY
	// for _, line := range lines {
	// 	str := decompress(line)
	// 	fmt.Println(str, len(str))
	// }

}

func unpack(packs [][]int) [][]int {
	result := [][]int{}

	buff := [][]int{}
	buffSize := -1
	buffStart := -1
	blockFinished := false
	for i, pack := range packs {
		if pack[1] == 0 {
			blockFinished = unpackStatic(&packs, &buff, &result, pack, &buffSize, &buffStart, i)
		} else {
			blockFinished = unpackBlock(&packs, &buff, &result, pack, &buffSize, &buffStart, i)
		}
		if blockFinished {
			break
		}
	}

	return result
}

func hasBlock(packs *[][]int) bool {
	for _, pack := range *packs {
		if pack[1] != 0 {
			return true
		}
	}
	return false
}

func unpackStatic(packs *[][]int, buff *[][]int, result *[][]int, pack []int, buffSize *int, buffStart *int, i int) bool {
	if *buffStart != -1 {
		remaining := *buffSize - pack[0]
		if remaining < 0 {
			// create new static with what's left in buff
			*buff = append(*buff, []int{*buffSize, 0, 0})
		} else {
			// create new static with pack
			*buff = append(*buff, pack)
			*buffSize = *buffSize - pack[0]
		}
		if remaining <= 0 {
			value := 0
			for i := len(*buff) - 1; i >= 0; i-- {
				buffItem := (*buff)[i]
				if buffItem[1] == 0 { // static
					value = value + buffItem[0]
				} else {
					value = value * buffItem[2]
				}
			}
			*result = append(*result, []int{value, 0, 0})

			if remaining < 0 {
				// append the remaining static block
				*result = append(*result, []int{-remaining, 0, 0})
			}
			*result = append(*result, (*packs)[i+1:]...)
			return true
		}
	} else {
		*result = append(*result, pack)
	}
	return false
}

func unpackBlock(packs *[][]int, buff *[][]int, result *[][]int, pack []int, buffSize *int, buffStart *int, i int) bool {
	if *buffStart != -1 {
		remaining := *buffSize - pack[0]
		if remaining < 0 {
			panic("Error during unpack")
		}
		*buffSize = *buffSize - pack[0]
	} else {
		*buffStart = i
		*buffSize = pack[1]
	}
	*buff = append(*buff, pack)
	return false
}

func decompress(line string) string {
	result := ""
	markerString := ""
	inMarker := false
	markerSize := -1
	markerCounter := -1
	markerBlock := -1
	for _, c := range line {
		if inMarker {
			if c == ')' {
				inMarker = false
				fmt.Sscanf(markerString, "%dx%d", &markerCounter, &markerBlock)
				markerSize = markerCounter
				markerString = ""
			} else {
				markerString = markerString + string(c)
			}
		} else {
			if c == '(' && markerCounter <= 0 {
				inMarker = true
			} else {
				result = result + string(c)
				markerCounter--
				if markerCounter == 0 {
					block := result[len(result)-markerSize:]
					for i := 0; i < markerBlock-1; i++ {
						result = result + block
					}
				}
			}
		}
	}

	return result
}
