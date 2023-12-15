package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

type Card struct {
	Rank  rune
	Value int
}

type Hand struct {
	Cards    [5]*Card
	Counter  map[int]int
	Value    int
	Rank     int
	SumValue int
	Bet      int
}

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
	hands := make([]*Hand, len(lines))
	for i, line := range lines {
		hands[i] = parseHand(line)
	}

	handsMap := map[int][]*Hand{}
	for _, hand := range hands {
		_, found := handsMap[hand.Value]
		if !found {
			handsMap[hand.Value] = []*Hand{}
		}
		handsMap[hand.Value] = append(handsMap[hand.Value], hand)
	}

	rank := 1

	res := []*Hand{}

	for value := 0; value <= 6; value++ {
		_, found := handsMap[value]
		if !found {
			continue
		}

		sort.Slice(
			handsMap[value],
			func(i, j int) bool { return handsMap[value][i].SumValue < handsMap[value][j].SumValue },
		)

		for _, hand := range handsMap[value] {
			hand.Rank = rank
			rank++
		}

		res = append(res, handsMap[value]...)
	}

	total := 0
	for _, hand := range res {
		total += hand.Rank * hand.Bet
	}

	fmt.Println(total)
}

// Use the implementation from poker that I've did for project euler
// But in this case, there will be no check for flushes neither straight flushes
// Because there's no suits information

// given a string with the 5 cards, it will return a sorted array of cards
func parseHand(line string) *Hand {
	strs := strings.Split(line, " ")
	hand := Hand{}
	newCards := make([]*Card, 5)
	for i, v := range strs[0] {
		newCards[i] = newCard(string(v))
	}
	// the [:] forces the copy from a slice to an array
	copy(hand.Cards[:], newCards)

	hand.setCounter()
	hand.setValue()
	bet, _ := strconv.Atoi(strs[1])
	hand.setBet(bet)
	hand.setSumValue()

	return &hand
}

func newCard(token string) *Card {
	valuesMap := map[rune]int{
		'2': 1,
		'3': 2,
		'4': 3,
		'5': 4,
		'6': 5,
		'7': 6,
		'8': 7,
		'9': 8,
		'T': 9,
		'J': 10,
		'Q': 11,
		'K': 12,
		'A': 13,
	}
	tokens := []rune(token)
	return &Card{tokens[0], valuesMap[tokens[0]]}
}

func (card Card) String() string {
	return fmt.Sprintf("%s", string(card.Rank))
}

// returns -1, 0 or 1: the compare result among card and card2
func (card *Card) cmp(card2 *Card) (result int) {
	result = card.Value - card2.Value
	if result > 0 {
		result = 1
	} else if result < 0 {
		result = -1
	}
	return
}

func (hand Hand) String() string {
	return fmt.Sprintf(
		"Cards: [%s %s %s %s %s] Value: %d Rank: %d Bet: %d Sum %d",
		hand.Cards[0].String(),
		hand.Cards[1].String(),
		hand.Cards[2].String(),
		hand.Cards[3].String(),
		hand.Cards[4].String(),
		hand.Value,
		hand.Rank,
		hand.Bet,
		hand.SumValue,
	)
}

func (hand *Hand) setCounter() {
	hand.Counter = make(map[int]int)
	for _, card := range hand.Cards {
		_, found := hand.Counter[card.Value]
		if found {
			hand.Counter[card.Value]++
		} else {
			hand.Counter[card.Value] = 1
		}
	}
}

func (hand *Hand) isFullHouse() bool {
	return hand.isThreeOfAKind() && hand.isPair()
}

func (hand *Hand) isFour() bool {
	for _, v := range hand.Counter {
		if v == 4 {
			return true
		}
	}
	return false
}

func (hand *Hand) isFive() bool {
	for _, v := range hand.Counter {
		if v == 5 {
			return true
		}
	}
	return false
}

func (hand *Hand) isThreeOfAKind() bool {
	for _, v := range hand.Counter {
		if v == 3 {
			return true
		}
	}
	return false
}

func (hand *Hand) isTwoPairs() bool {
	pairCounter := 0
	for _, v := range hand.Counter {
		if v == 2 {
			pairCounter++
		}
	}
	return pairCounter == 2
}

func (hand *Hand) isPair() bool {
	for _, v := range hand.Counter {
		if v == 2 {
			return true
		}
	}
	return false
}

func (hand *Hand) setValue() {
	result := 0 // high card
	if hand.isFive() {
		result = 6
	} else if hand.isFour() {
		result = 5
	} else if hand.isFullHouse() {
		result = 4
	} else if hand.isThreeOfAKind() {
		result = 3
	} else if hand.isTwoPairs() {
		result = 2
	} else if hand.isPair() {
		result = 1
	}
	hand.Value = result
}

func (hand *Hand) setBet(bet int) {
	hand.Bet = bet
}

// converting from "base 14" to base 10,
func (hand *Hand) setSumValue() {
	hand.SumValue = (38416 * hand.Cards[0].Value) +
		(2744 * hand.Cards[1].Value) +
		(196 * hand.Cards[2].Value) +
		(14 * hand.Cards[3].Value) +
		(hand.Cards[4].Value)
}

func highCardIndex(hands []*Hand) int {
	for i := 0; i < 5; i++ {
		if hands[0].Cards[i].Value > hands[1].Cards[i].Value {
			return 0
		} else if hands[1].Cards[i].Value > hands[0].Cards[i].Value {
			return 1
		}
	}
	return -1 // a draw
}
