class Card < ApplicationRecord
  # To make it work with Ohm
  # because Card is not a Ohm::Model
  def self.[](index)
    Card.find_by_id(index)
  end
end
