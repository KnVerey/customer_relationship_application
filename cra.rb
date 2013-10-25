class CRA
	def main_menu
		selection = 1
		while selection != 6
			print_main_menu
			selection = gets.chomp.to_i
			run_option(selection)
		end
	end

	def print_main_menu
		puts "Please select one of the following options:"
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
			modify_contact
		when 3
			delete_contact
		when 4
			display_all_contacts
		when 5
			display_attribute
		when 6
			puts "\nGoodbye!"
		else
			puts "\nInvalid selection. Here are your options:"
		end

	end
end

CRA.new.main_menu