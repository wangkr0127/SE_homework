class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :cnt
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
    @cnt = 0
    for i in 1..word.size
	    @word_with_guesses.concat('-')
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def judge_letter(letter)
    if (letter >= 'a' and letter <= 'z') or (letter >= 'A' and letter <= 'Z')
      return true
    else
      return false
    end
  end

  def guess(letter)
    raise ArgumentError if letter == '' or letter==nil
    raise ArgumentError if !judge_letter(letter)
    letter=letter.downcase

    if guesses.include? letter or wrong_guesses.include? letter
      return false
    end

    if word.include? letter
      l = 0
      while true do
        if letter == word[l]
          word_with_guesses[l] = letter
        end 
        l += 1
        if (l == word.size)
          break
        end
      end
      @guesses = letter
      @cnt += 1
      return true
    else
      @wrong_guesses = letter
      @cnt += 1
      return true   
    end
  end

  def check_win_or_lose()
    if word_with_guesses == word
      return :win
    elsif @cnt >= 7
      return :lose
    else
      return :play
    end
  end
end