require 'sinatra/base'

module Sinatra
  module HangmanHelpers
    def set_game
      session[:word] = random_word
      session[:tries] = 6
      session[:hidden_word] = session[:word].gsub(/./, '_')
      session[:guesses] = []
      session[:message] = ''
    end

    def update_game(guess)
      if valid_input?(guess)
        update_variables(guess)
      else
        session[:message] = 'Input is empty or already been guessed'
      end
    end

    def update_variables(guess)
      if guess.length == 1
        session[:guesses].push(guess)
        session[:tries] = tries - 1 unless letter_in_word?(guess)
        update_hidden_word(guess) if letter_in_word?(guess)
      else
        session[:tries] = 0
        session[:hidden_word] = word if guess == word
      end
    end

    def update_hidden_word(guess)
      indexes = (0...word.length).find_all { |i| word[i] == guess }
      indexes.each { |index| session[:hidden_word][index] = word[index] }
    end

    def random_word
      word = ''
      word = generate_word until word.length.between?(5, 12)
      word
    end

    def generate_word
      all_words[rand(all_words.length - 1)].upcase
    end

    def all_words
      lines = File.open('./dictionary.txt', 'r', &:readlines)
      lines.map!(&:strip)
    end

    def show_hidden_word
      show_off = hidden_word.gsub(/./) { |c| c + '   ' }
      show_off.strip
    end

    def generate_image_link
      img_link = "img/hangman#{tries}.png"
      img_link = 'img/hangman_win.png' if win?
      img_link
    end

    def letter_in_word?(guess)
      word.split('').include?(guess)
    end

    def valid_input?(guess)
      !guess.empty? && !guesses.include?(guess)
    end

    def win?
      hidden_word == word
    end

    def lose?
      tries.zero? && hidden_word != word
    end

    def message
      session[:message]
    end

    def guesses
      session[:guesses]
    end

    def tries
      session[:tries]
    end

    def word
      session[:word]
    end

    def hidden_word
      session[:hidden_word]
    end
  end

  helpers HangmanHelpers
end
