module Utilities
	def puts_hr
		puts "--------------------------------------------"
	end

	def mandatory_gets(prompt,error_msg)
		print prompt
		input = gets.chomp
		if input == ""
			clear
			print error_msg + " "
			input = mandatory_gets(prompt, error_msg)
		end
		return input
	end

	def clear
 		puts "\e[H\e[2J"
	end
end

module SampleData
require_relative "contact"

	def import_sample_data
		contact = Contact.new("Mary", "Poppins","mp@gmail.com","American")
		assign_id(contact)
		@contact_array << contact
		contact = Contact.new("Mary", "Lamb","ml@gmail.com","For two same names tests")
		assign_id(contact)
		@contact_array << contact
		contact = Contact.new("Betty","Smith","bsmith@yahoo.ca","Canadian")
		assign_id(contact)
		@contact_array << contact
		contact = Contact.new("Betsy","Smith","bsmith2@yahoo.ca","For name sort test")
		assign_id(contact)
		@contact_array << contact
	end
end
