min_len = ARGV.shift.to_i
max_len = ARGV.shift.to_i
per_len = 100

perms = (min_len..max_len).map do |length|
  random_numbers = (length+2).times.map do
    rand(100)
  end
  random_perms = random_numbers.combination(length).to_a
  puts "randoms: #{random_perms.length}"
  r = random_perms.sample(per_len)
  puts "L: #{length} :: #{r.length}"
  r
end
perms.flatten!(1)
perms.map! do |perm|
  "#{perm.join(',')}:#{perm.sort.join(',')}"
end

File.write('./out.txt', perms.join(" "))
puts "DONE: #{perms.length}"
