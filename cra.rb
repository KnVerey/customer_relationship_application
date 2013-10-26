require_relative "contact"
require_relative "rolodex"
require_relative "utilities"
include Utilities

class CRA
	def self.run
		clear			
		puts_hr
		puts "\n\t   Welcome to your CRM!\n\n".upcase
		puts_hr		
		puts "\nPlease enter a name for your contact book."
		print "NAME: "
		name = gets.chomp
		@rolodex = Rolodex.new(name)
		main_menu
	end

	def self.main_menu
		selection = 1
		while selection != 4
			print_main_menu
			selection = gets.chomp.to_i
			execute_selection(selection)
		end
	end

	def self.print_main_menu
 		puts "\e[H\e[2J"
		puts_hr
		puts @rolodex.name.upcase + ": Main Menu"
		puts_hr
		puts "\nPlease select one of the following options:"
		puts "[1] Add a new contact"
	  puts "[2] Find an existing contact"
	  puts "[3] Display all contacts"
	  puts "[4] Exit"
	  print "\nCHOICE: "
	end

	def self.execute_selection(selection)
		case selection
		when 1
			@rolodex.add_contact
		when 2
 			@rolodex.interact_contacts
		when 3
			@rolodex.print_all
 		when 4
			clear
		else
			puts "\nInvalid selection. Here are your options:"
		end
 	end
end

CRA.run