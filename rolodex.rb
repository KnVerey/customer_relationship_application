require_relative "utilities"
require_relative "contact_search"
include Utilities
include SampleData

class Rolodex
	attr_accessor :name, :contact_array

	def initialize(name)
		@name = name	
		@contact_array = []
		@id_to_assign = 1

		#COMMENT OUT LINE BELOW TO REMOVE SAMPLE DATA
		import_sample_data; sort_by_name
	end

 	def add_contact
 		clear
 		error_msg = "This field is mandatory."
 		first_name = mandatory_gets("First name: ", error_msg)
 		last_name = mandatory_gets("Last name: ", error_msg)
 		email = get_valid_email
 		note = mandatory_gets("Note: ", error_msg)

 		contact = Contact.new(first_name, last_name, email, note)
 		assign_id(contact)
		@contact_array << contact
		sort_by_name
		puts "\nContact added! Press enter to continue."
		gets
 	end

 	def get_valid_email
 		email = mandatory_gets("Email: ", "This field is mandatory.")
 		return email if email.include?("@") && email.include?(".")
 		clear
 		puts "#{email} isn't a valid email address.\n"
 		email = get_valid_email
 	end

	def assign_id(contact)
		contact.id =  @id_to_assign
		@id_to_assign += 1		
	end

	def sort_by_name
		@contact_array.sort_by! {|contact| contact.last_name + contact.first_name}
	end

	def interact_contacts
 		search = ContactSearch.new(@contact_array)
 		if search.results.nil?
 			return nil #Nil result means user cancelled search
 		elsif search.results.empty?
 			puts "Sorry, I didn't find anything."
 			puts "Press enter to continue."
 			gets
 			return nil
 		else 			
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
				return
			when 2
				clear
				if validate_deletion(contact)
					index = identify_index(contact)
					delete_contact(index)
				else
					clear
					puts "Deletion cancelled."
					puts "Press enter to continue."
					gets
				end
				return
			when 3
				#do nothing, continue loop to next result
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
			puts "\nThat is not a valid choice."
			input = get_action_choice(contact)
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

	def modify_contact(contact)

	end

	def validate_deletion(contact)
		contact.print_contact
		puts "\nAre you sure you want to delete this contact?"
		puts "[1] Yes"
		puts "[2] No\n"
		print "CHOICE: "
		input = gets.chomp.to_i
		unless (1..2).include?(input)
			clear
			puts "\n That is not a valid choice."
			input = validate_deletion(contact)
		end
		input==1? true : false
	end

	def identify_index(desired_contact)
		index = 0
		@contact_array.each do |contact|
			return index if contact.id == desired_contact.id
			index += 1
		end
	end

	def delete_contact(index)
		@contact_array.delete_at(index)		
		clear
		puts "Contact deleted! Press enter to continue."
		gets
	end


 	def print_all
 		clear
 		@contact_array.each {|contact| contact.print_contact}
 		puts "Press enter to continue."
 		gets
 	end

end