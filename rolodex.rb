require_relative "utilities"
include Utilities

class Rolodex
	attr_accessor :name, :contact_array

	def initialize(name)
		@name = name	
		@contact_array = []
		@id_to_assign = 1000
	end

 	def add_contact
 		error_msg = "This field is mandatory."
 		first_name = mandatory_gets("First name: ", error_msg)
 		last_name = mandatory_gets("Last name: ", error_msg)
 		email = mandatory_gets("Email: ", error_msg)
 		note = mandatory_gets("Note: ", error_msg)

 		contact = Contact.new(first_name, last_name, email, note)
 		assign_id(contact)
		@contact_array << contact
 	end

	def assign_id(contact)
		contact.id =  @id_to_assign
		@id_to_assign += 1		
	end

	def find_contact
 		field = identify_search_field
		return nil if field==5
		query = identify_search_query
		search_rolodex(field, query)
	end

	def search_rolodex(field, query)
		matches = @contact_array.map	do |contact|
			case field
			when 1 
				contact if contact.first_name.include?(query)
			when 2 
				contact if contact.last_name.include?(query)
			when 3 
				contact if contact.email.include?(query)
			when 4 
				contact if contact.note.include?(query)
			end
		end
		puts "\nHere are the results:"
		matches.each {|contact| contact.print_contact}
		results_action
	end

	def print_action_options
		puts "\nWhat do you want to do?"
		puts "[1] Modify a record"
		puts "[2] Delete a record"
		puts "[3] Search again"
		puts "[4] Return to main menu"
	end

	def results_action
		print_action_options
		input = gets.chomp.to_i
		unless (1..4).include?(input)
			print "\nThat is not a valid choice."
			results_action
		end
		case input
		when 1
			modify_contact
		when 2
			delete_contact
		when 3
			find_contact
		end
	end

	def identify_search_query
		print "Enter a search term: "
		input=gets.chomp
		until input != ""
			identify_search_query
		end
		return input
	end

 	def identify_search_field
 		print_search_options
 		input = gets.chomp.to_i
		unless (1..5).include?(input)
	 		print "\nThat is not a valid choice."
	 		identify_search_field
	 	end
	 	return input
 	end
 	
 	def print_search_options
		puts "\nPlease choose the attribute you want to search for: "
		puts "[1] First name"
	  puts "[2] Last name"
	  puts "[3] Email"
	  puts "[4] Note" 	
	  puts "[5] Cancel"	
 	end

 	def print_all
 		@contact_array.each {|contact| contact.print_contact}
 	end

end