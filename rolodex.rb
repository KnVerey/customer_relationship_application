require_relative "utilities"
require_relative "contact_search"
include Utilities

class Rolodex
	attr_accessor :name, :contact_array

	def initialize(name)
		@name = name	
		@contact_array = []
		@id_to_assign = 1000

		#SAMPLE DATA#
		contact = Contact.new("Mary", "Poppins","mp@gmail.com","nada")
		assign_id(contact)
		@contact_array << contact
		contact = Contact.new("Famous", "Person","vain@gmail.com","ok")
		assign_id(contact)
		@contact_array << contact
		contact = Contact.new("Betty","Smith","bsmith@yahoo.ca","canada")
		assign_id(contact)
		@contact_array << contact
		#END SAMPLE DATA#
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

	def interact_contacts
 		search = ContactSearch.new(@contact_array)
 		if search.results.empty?
 			puts "Sorry, I didn't find anything."
 			interact_contact
 		end
 		unless search.nil? 			
 			propose_actions(search.results)
		end
	end

 	def propose_actions(results)
		results.each do |contact|
			clear
			input = get_action_choice(contact)
			case input
			when 1
				modify_contact(contact)
				break
			when 2
				delete_contact(contact)
				break
			when 3
				#do nothing, continue loop
			end
		end
		clear
		puts "There are no more results. Press enter to continue."
		gets
	end

	def get_action_choice(contact)
		contact.print_contact
		print_action_options
		input = gets.chomp.to_i
		unless (1..3).include?(input)
			clear
			print "\nThat is not a valid choice."
			get_action_choice
		end
		return input
	end

	def print_action_options
		puts "\nWhat do you want to do?"
		puts "[1] Modify this record"
		puts "[2] Delete this record"
		puts "[3] Next result"
		print "\nCHOICE: "
	end

	def modify_contact(matches)
		clear
		print_matches(matches)
		print "Enter the ID number for the contact you want to modify:"
		id = gets.chomp.to_i
		until valid_id?(id)
			modify_contact
		end
	end

	def valid_id?(id)
		if id == 0 || id == ""
			puts "That is not a valid ID number."
			return false
		end
		@contact_array.each {|contact| return true if contact.id==id}
	end

	def delete_contact
		
	end


 	def print_all
 		clear
 		@contact_array.each {|contact| contact.print_contact}
 	end

end