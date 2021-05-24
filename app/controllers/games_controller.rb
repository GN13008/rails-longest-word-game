require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    #Generate 10 Random Letter
    array_of_letter = ("A".."Z").to_a
    @letters = []
    (0..9).each do
      @letters << array_of_letter.sample
    end
  end

  def score
    @score = 0
    @message_result = ""
    @word = params[:word]
    @letters = params[:letters].chars
    @exist = word_check(@word)

    if @exist
      @message_result = using_the_grid(@word, @letters)
      @score += 10 if @message_result == "Well Done !"
    else
      @message_result = "Sorry but #{@word} does not seem to be a valid English word..."
    end

    # def run_game(attempt, grid, start_time, end_time)
    #   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    #   # run_game
    #   word_check = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    #   result = { attempt: attempt, time: (end_time - start_time).to_i, score: 0, message: "" }
    
    #   result[:message] = using_the_grid(attempt, grid)
    
    #   hash_bonus = counting_bonus(attempt, result, grid)
    
    #   result = word_check_method(attempt, word_check, result, hash_bonus)
    
    #   return result
    # end
    
    # def counting_bonus(attempt, result, grid)
    #   hash_bonus = {
    #     quicker_point: 0,
    #     length_point: 0,
    #     double_point: 0
    #   }
    #   hash_bonus[:quicker_point] = 10 if result[:time] < 8
    #   hash_bonus[:quicker_point] = 10 if attempt.length > (grid.length / 2)
    #   return hash_bonus
    # end
    
    # def word_check_method(attempt, word_check, result, hash_bonus)
    #   if word_check["found"] && result[:message] == ""
    #     result[:score] = attempt.length + hash_bonus[:quicker_point] + hash_bonus[:length_point] + hash_bonus[:double_point]
    #     result[:message] = "well done ! you earn #{result[:score]}"
    #   else
    #     result[:message] = "This word is not an english word, your are so bad" if result[:message] == ""
    #     result[:score] = 0
    #   end
    #   return result
    # end
    
    # def run_game(attempt, grid, start_time, end_time)
    #   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    #   # run_game
    #   word_check = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    #   result = { attempt: attempt, time: (end_time - start_time).to_i, score: 0, message: "" }
    
    #   result[:message] = using_the_grid(attempt, grid)
    
    #   hash_bonus = counting_bonus(attempt, result, grid)
    
    #   result = word_check_method(attempt, word_check, result, hash_bonus)
    
    #   return result
    # end
  end
  
  def word_check(word)
    word_check = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    return word_check["found"]
  end

  def using_the_grid(attempt, grid)
    # creer un hash de ma grid avec les lettre et le nombre doccurence
    hash_letter = {}
    grid.each { |letter| hash_letter.key?(letter) ? hash_letter[letter] += 1 : hash_letter[letter] = 1 }

    # verifier que le mot utilise que des lettres de ma grid
    message = "Well Done !"
    attempt.upcase.chars.each do |letter|
      if hash_letter.key?(letter.to_s)
        hash_letter[letter.to_s].positive? ? hash_letter[letter.to_s] -= 1 : message = "it's not in the grid"
      else
        message = "You are using wrong letter, it's not in the grid"
      end
    end
    return message
  end
end
