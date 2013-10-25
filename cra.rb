require_relative "contact"
require_relative "rolodex"

class CRA
	def initialize
		puts "\e[H\e[2J"
		puts "\nWelcome to your CRM!".upcase
		print "Please enter a name for your contact book: "
		name = gets.chomp
		@contact_book = Rolodex.new(name)
	end

	def main_menu
		selection = 1
		while selection != 6
			print_main_menu
			selection = gets.chomp.to_i
			run_option(selection)
		end
	end

	def print_main_menu
		puts "\nPlease select one of the following options:"
		puts "[1] Add a new contact"
	  puts "[2] Modify an existing contact"
	  puts "[3] Delete a contact"
	  puts "[4] Display all the contacts"
	  puts "[5] Display an attribute" 
	  puts "[6] Exit"
	  print "Enter a number: "
	end

	def run_option(selection)
		case selection
		when 1
			add_contact
		when 2
			field = identify_search_field
			puts field
 			@contact_book.modify_contact unless field==5
		when 3
			contact = identify_contact
			@contact_book.delete_contact(contact)
		when 4
			@contact_book.display_all_contacts
		when 5
			display_attribute
		when 6
			puts "\nGoodbye!"
		else
			puts "\nInvalid selection. Here are your options:"
		end
 	end

 	def identify_search_field
 		print_search_options
 		input = gets.chomp.to_i
		unless (1..5).include?(input)
	 		print "That is not a valid choice. Try again: "
	 		identify_search_field
	 	end
	 	input=input_to_field(input) unless input==5
	 	return input
 	end

 	def input_to_field(input)
 		case input
 		when 1; "first_name"
 		when 2; "last_name"
 		when 3; "email"
 		when 4; "note"
 		when 5; "abort"
 		end
 	end
 	
 	def print_search_options
		puts "\nPlease choose the attribute you want to search for: "
		puts "[1] First name"
	  puts "[2] Last name"
	  puts "[3] Email"
	  puts "[4] Note" 	
	  puts "[5] Cancel"	
 	end

 	def mandatory_get(prompt)
		print prompt
		input = gets.chomp
		if input == ""
			print "This field is mandatory. "
			mandatory_get(prompt)
		end
		return input
	end

 	def add_contact
 		first_name = mandatory_get("First name: ")
 		last_name = mandatory_get("Last name: ")
 		email = mandatory_get("Email: ")
 		note = mandatory_get("Note: ")

 		contact = Contact.new(first_name, last_name, email, note)
 		@contact_book.add_contact_to_book(contact)
 	end
end

CRA.new.main_menu