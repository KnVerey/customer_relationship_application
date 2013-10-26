require_relative "contact"
require_relative "rolodex"
require_relative "utilities"
include Utilities

class CRA
	def self.run
		clear			
		puts welcome_header
		load_rolodex_list

		if @rolodex_list.empty?
			puts "You don't have any contact books yet."
			add_new_rolodex
		else
			choose_rolodex
		end
		main_menu
	end

	def self.load_rolodex_list
		@rolodex_list = []
	end

	def self.add_new_rolodex
		name = mandatory_gets("Please enter a name for your new contact book.\nNAME: ", welcome_header + "\nNaming the book is mandatory.")
		@rolodex = Rolodex.new(name)
		@rolodex_list << @rolodex
	end

	def self.choose_rolodex
		
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
		puts hr
		puts @rolodex.name.upcase + ": Main Menu"
		puts hr
		puts "\nPlease select one of the following options:"
		puts "[1] Add a new contact"
	  puts "[2] Find an existing contact (view, change or delete)"
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