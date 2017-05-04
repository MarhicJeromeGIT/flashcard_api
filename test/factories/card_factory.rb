FactoryGirl.define do
  factory :card do
    transient do
      x { rand(100) }
      y { rand(100) }
    end

    question { "#{x} * #{y}?" }
    answer { (x * y).to_s }
  end
end
