module Sol; end
class Sol::Renderer
  Ranks = [nil, 'A', *(2..9).map(&:to_s), 'T', 'J', 'Q', 'K']
  Suits = {:clubs => 'c', :diamonds => 'D', :spades => 's', :hearts => 'H'}
  def initialize(session)
    @layout = [
      [session.waste],
      *((0..6).map {|i| [session.facedown[i], session.faceup[i]] }),
      *((0..3).map {|i| [session.discard[i]] }),
    ]

  end

  def headings
    ['sTack', *(1..7).to_a, *%w{D H c s}].map {|h| "[#{h}]"}.join(" ")
  end
  def card_rows
    board = []
    @layout.each_index do |col|
      row = 0
      @layout[col].each do |pile|
        pile.cards.each do |card|
          board[row] ||= Array.new(@layout.length)
          board[row][col] = card
          row = row + 1
        end
      end
    end
    return board.map do |row|
      '   ' + row.map do |card|
        sprintf('%3s', self.class.render_card(card) )
      end.join(' ')
    end
  end
  def self.render_card(c)
    return '' if c.nil?
    return '**' unless c.pile.visible?
    return Suits[c.suit] + Ranks[c.rank]
  end

  def render
    [headings, *card_rows, ''].join("\n")
  end
end
