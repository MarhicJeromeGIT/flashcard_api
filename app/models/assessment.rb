class Assessment < Ohm::Model
  attribute :rating
  attribute :elapsed_time
  attribute :time
  reference :card, :Card
end
