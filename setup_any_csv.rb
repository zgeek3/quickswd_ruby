
require "./setup_start"
require "./setup_csv"

ARGV.each do|a|
  puts "Running test on: #{a}"

	starttest

	csvit(a)

	endtest
end
