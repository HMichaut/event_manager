require 'csv'
require 'date'

def clean_phone_number(phone_number)
  only_digits_phone_number = phone_number.scan(/\d+/).join
  phone_number_length = only_digits_phone_number.length
  if phone_number_length == 10
    return only_digits_phone_number
  elsif phone_number_length == 11 && only_digits_phone_number[0] == 1
    return only_digits_phone_number[1..-1]
  else
    return "Bad number"
  end
end

def clean_time(regdate)
  DateTime.strptime(regdate, '%m/%d/%Y %H:%M').hour
end

def clean_day(regdate)
  DateTime.strptime(regdate, '%m/%d/%Y %H:%M').wday
end

puts 'clean_phone_number initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

time_table = Array.new(24, 0)
day_table = Array.new(7, 0)
day_list = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone_number = clean_phone_number(row[:homephone])

  registration_hour = clean_time(row[:regdate])
  time_table[registration_hour] += 1

  registration_day = clean_day(row[:regdate])
  day_table[registration_day] += 1

  puts "#{id} #{name} #{phone_number}"
end

sorted_time_table = time_table.sort.reverse
hours_array = time_table.map.with_index.sort.map(&:last).reverse
puts ""
puts "HOURS ANALYSIS"
sorted_time_table.each_with_index do |value, index|
  if value == 0
    next
  elsif value == 1
    puts "#{index + 1}. #{value} person has registered at #{hours_array[index]} hour"
  else
    puts "#{index + 1}. #{value} persons have registered at #{hours_array[index]} hour"
  end
end

sorted_day_table = day_table.sort.reverse
days_array = day_table.map.with_index.sort.map(&:last).reverse
puts ""
puts "DAYS ANALYSIS"
sorted_day_table.each_with_index do |value, index|
  if value == 0
    next
  elsif value == 1
    puts "#{index + 1}. #{value} person has registered on #{day_list[days_array[index]]}"
  else
    puts "#{index + 1}. #{value} persons have registered on #{day_list[days_array[index]]}"
  end
end
