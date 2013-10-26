require_relative "rolodex"

module Utilities
	def puts_hr
		puts "--------------------------------------------"
	end

	def mandatory_gets(prompt,error_msg)
		print prompt
		input = gets.chomp
		if input == ""
			print error_msg + " "
			input = mandatory_gets(prompt, error_msg)
		end
		return input
	end

	def clear
 		puts "\e[H\e[2J"
	end
end