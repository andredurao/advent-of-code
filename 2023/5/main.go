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
	loadRanges()
	part1()
	part2()
}

func readlines() {
	content, _ := os.ReadFile(os.Args[1])
	lines = strings.Split(string(content), "\n")
	lines = lines[:len(lines)-1]
}

func loadRanges() {
	seedToSoil = getRanges("seed-to-soil map:")
	soilToFertilizer = getRanges("soil-to-fertilizer map:")
	fertilizerToWater = getRanges("fertilizer-to-water map:")
	waterToLight = getRanges("water-to-light map:")
	lightToTemperature = getRanges("light-to-temperature map:")
	temperatureToHumidity = getRanges("temperature-to-humidity map:")
	humidityToLocation = getRanges("humidity-to-location map:")
}

func part1() {
	fmt.Println("part 1")
	seeds := getSeeds()
	fmt.Println(seeds)

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

func part2() {
	fmt.Println("part 2")
	seeds := getSeeds()
	location := 0

	for {
		humidity := reverseSearchInRange(location, humidityToLocation)
		temperature := reverseSearchInRange(humidity, temperatureToHumidity)
		light := reverseSearchInRange(temperature, lightToTemperature)
		water := reverseSearchInRange(light, waterToLight)
		fertilizer := reverseSearchInRange(water, fertilizerToWater)
		soil := reverseSearchInRange(fertilizer, soilToFertilizer)
		seed := reverseSearchInRange(soil, seedToSoil)
		for i := 0; i < len(seeds)/2; i++ {
			start := seeds[i*2]
			end := seeds[i*2] + seeds[i*2+1] - 1
			if seed >= start && seed <= end {
				fmt.Println("min location", location)
				return
			}
		}
		location++
	}

}

func reverseSearchInRange(val int, rangeMap [][]int) int {
	// range: dst src size | 50 98 2 ex: rev(50) -> 98
	for _, vals := range rangeMap {
		start := vals[0]
		end := vals[0] + vals[2]
		delta := vals[1] - vals[0]
		if val >= start && val <= end {
			return val + delta
		}
	}
	return val
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
