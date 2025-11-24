require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10){('A'..'Z').to_a.sample}
    session[:total_score] ||= 0
  end

  def score
    @user_word = params[:user_word].upcase
    @letters = params[:letters].split

    if word_in_grid?(@user_word, @letters)
      if english_word?(@user_word)
        @score = @user_word.length
        @result = "Well done ! #{@user_word} is a valid word. It contains #{@score} letters"
      else
        @score = 0
        @result = "Sorry, #{@user_word} is not a valid English word."
      end
      else
        @score = 0
        @result = "Sorry, #{@user_word} can't be constructed from the grid."
      end
      session[:total_score] ||= 0
      session[:total_score] += @score
      @total_score = session[:total_score]
  end
end


private

def letterscount(list)
  frequencies = Hash.new(0)
  list.each { |letter| frequencies[letter] += 1 }
  frequencies
end

def word_in_grid?(word, grid)
  word_freq = letterscount(word.chars)
  grid_freq = letterscount(grid)
  word_freq.all? do |letter, count|
    count <= grid_freq[letter]
  end
 end

 def english_word?(word)
  url = "https://dictionary.lewagon.com/#{word.downcase}"
  response = URI.open(url).read
  json = JSON.parse(response)
  json['found']
 end
