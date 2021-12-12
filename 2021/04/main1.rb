class Card
  def initialize(rows)
    @rows = rows
  end

  def mark(value)
    0.upto(4) do |row_index|
      0.upto(4) do |col_index|
        current = @rows[row_index][col_index]
        @rows[row_index][col_index] = -1 if current == value
      end
    end
  end

  def score
    total = 0
    0.upto(4) do |row_index|
      0.upto(4) do |col_index|
        current = @rows[row_index][col_index]
        total += current if current > 0
      end
    end
    total
  end

  def won?
    0.upto(4) do |row_index|
      total = @rows[row_index].inject(:+)
      return true if total == -5
    end

    0.upto(4) do |col_index|
      total = 0
      0.upto(4) do |row_index|
        total += @rows[row_index][col_index]
      end
      return true if total == -5
    end

    return false
  end
end

#body = File.readlines('example', chomp: true)
body = File.readlines('input', chomp: true)
numbers = body[0].split(',').map(&:to_i)
cards = []
buf = []
2.upto(body.size) do |line_no|
  line = body[line_no]
  if (line || '').empty?
    cards << Card.new(buf)
    buf = []
  else
    buf << line.split.map(&:to_i) if line
  end
end

numbers.each do |n|
  cards.each do |card|
    p n
    card.mark(n)
    if card.won?
      p card
      p card.score * n
      return
    end
  end
end
