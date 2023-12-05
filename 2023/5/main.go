package main

import (
	"fmt"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
)

var lines []string
var seedToSoil [][]int
var soilToFertilizer [][]int
var fertilizerToWater [][]int
var waterToLight [][]int
var lightToTemperature [][]int
var temperatureToHumidity [][]int
var humidityToLocation [][]int

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
	seeds := getSeeds()
	fmt.Println(seeds)
	seedToSoil = getRanges("seed-to-soil map:")
	soilToFertilizer = getRanges("soil-to-fertilizer map:")
	fertilizerToWater = getRanges("fertilizer-to-water map:")
	waterToLight = getRanges("water-to-light map:")
	lightToTemperature = getRanges("light-to-temperature map:")
	temperatureToHumidity = getRanges("temperature-to-humidity map:")
	humidityToLocation = getRanges("humidity-to-location map:")

	res := math.MaxInt32

	for _, seed := range seeds {
		soil := searchInRange(seed, seedToSoil)
		fertilizer := searchInRange(soil, soilToFertilizer)
		water := searchInRange(fertilizer, fertilizerToWater)
		light := searchInRange(water, waterToLight)
		temperature := searchInRange(light, lightToTemperature)
		humidity := searchInRange(temperature, temperatureToHumidity)
		location := searchInRange(humidity, humidityToLocation)
		res = min(res, location)
	}
	fmt.Println("min location", res)

}

func searchInRange(val int, rangeMap [][]int) int {
	// range: dst src size
	for _, vals := range rangeMap {
		start := vals[1]
		end := vals[1] + vals[2]
		delta := vals[0] - vals[1]
		if val >= start && val <= end {
			return val + delta
		}
	}
	return val
}

// seeds: 79 14 55 13
func getSeeds() []int {
	res := []int{}
	re := regexp.MustCompile(`(\d+)`)
	for _, str := range re.FindAllString(lines[0], -1) {
		val, _ := strconv.Atoi(str)
		res = append(res, val)
	}

	return res
}

func getRanges(header string) [][]int {
	res := [][]int{}
	start := false
	for _, line := range lines {
		if line == header {
			start = true
			continue
		}
		if start {
			if len(line) == 0 {
				break
			}
			dst := 0
			src := 0
			size := 0
			fmt.Sscanf(line, "%d %d %d", &dst, &src, &size)
			res = append(res, []int{dst, src, size})
		}
	}
	return res
}
