module Escape
  step "I escape" do
    @escape_result = (@monsters.count <= 2)
  end

  step "I was able to escape" do
    expect(@escape_result).to be true
  end

  step "I could not escape" do
    expect(@escape_result).to be false
  end
end

steps_for :escape do
  include Escape
end

steps_for :master_of_escape do
  include Escape

  step "I escape" do
    @escape_result = (@monsters.count <= 100)
  end
end
