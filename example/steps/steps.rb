# Based on turnip/examples

step "there is a monster" do
  @monster = 1
end

step "there is a strong monster" do
  @monster = 2
end

step "there is a boss monster" do
  @monster = 3
end

step "I attack it" do
  @attack ||= 1 # no weapon
  @monster -= @attack
end

step "it should die" do
  expect(@monster).to be <= 0
end

step "Fanfare" do
end

step "I equip a weapon" do
  @attack = 2
end

step "there are monsters:" do |monsters|
  @monsters = monsters.map { |row| row[0] }
end

step "I escape" do
  @escape_result = (@monsters.count <= 2)
end

step "I was able to escape" do
  expect(@escape_result).to be_true
end

step "I could not escape" do
  expect(@escape_result).to be_false
end

step "the monster sings the following song" do |song|
  @song = song
end

step "the song should have :count lines" do |count|
  @song.to_s.split("\n").length.should eq(count.to_i)
end

