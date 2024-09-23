require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
      # vowel constant instantiated
      # %w() is shorthand for an array, leave spaces and no need for "".

  def new
    @letters = Array.new(5) { VOWELS.sample }
    # instance variable assigned an array which is instantiated with 5 elements and passed a block.
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # same instance variable has 5 random consonants added to array via +=. << only adds one element.
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    # params[:letters]: This retrieves the letters from the submitted form data.
    # The value comes from the hidden field letters in the form (submitted as a string)
    @word = (params[:word] || "").upcase
    # params[:word]: This retrieves the word that the user has input in the form field named word.
    # || "": This part ensures that if params[:word] is nil
    # (e.g., if the user submits an empty form or no word is provided), it will default to an empty string ("") to avoid errors.
    # .upcase: Converts the user’s input word to uppercase, ensuring uniformity for comparison.
    @included = included?(@word, @letters)
    # included?(@word, @letters): This calls a method included? (which should be defined elsewhere in the controller)
    # that checks if all the characters in the user’s word (@word) can be made using the available letters (@letters).
    @english_word = english_word?(@word)
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
