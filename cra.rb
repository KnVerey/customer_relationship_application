require_relative "contact"
require_relative "rolodex"

class CRA
	def self.run
		puts "\e[H\e[2J"
		puts "\nWelcome to your CRM!".upcase
		print "Please enter a name for your contact book: "
		name = gets.chomp
		@contact_book = Rolodex.new(name)
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
		puts "\nPlease select one of the following options:"
		puts "[1] Add a new contact"
	  puts "[2] Find an existing contact"
	  puts "[3] Display all contacts"
	  puts "[4] Exit"
	  print "Enter a number: "
	end

	def self.execute_selection(selection)
		case selection
		when 1
			@contact_book.add_contact
		when 2
 			contact = @contact_book.find_contact
		when 3
			@contact_book.print_all
 		when 4
			puts "\nGoodbye!"
		else
			puts "\nInvalid selection. Here are your options:"
		end
 	end
end

CRA.run