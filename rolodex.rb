require_relative "utilities"
require_relative "contact_search"
require_relative "sample_data"
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
 		contact_header = rolodex_header("Add contact") #string
 		puts contact_header
 		error_msg = "\n\nThis field is mandatory."
 		first_name = mandatory_gets("First name: ", (contact_header + error_msg))
 		last_name = mandatory_gets("Last name: ", (contact_header+"\nFirst name: #{first_name}"+ error_msg))
 		email = get_valid_email(first_name,last_name, error_msg)
 		note = mandatory_gets("Note: ", (contact_header+"\nFirst name: #{first_name}\nLast name: #{last_name}\nEmail:#{email}"+ error_msg))

 		contact = Contact.new(first_name, last_name, email, note)
 		assign_id(contact)
		@contact_array << contact
		sort_by_name
		clear
		puts rolodex_header("Add contact")
		puts contact.print_contact
		puts "Contact added! Press enter to continue."
		gets
 	end

 	def get_valid_email(first_name, last_name, error_msg)
 		email = mandatory_gets("Email: ", (rolodex_header("Add contact")+"\nFirst name: #{first_name}\nLast name: #{last_name}"+ error_msg))
 		return email if email.include?("@") && email.include?(".")
 		clear
 		puts rolodex_header("Add contact")+"\nFirst name: #{first_name}\nLast name: #{last_name}\n"
 		print "\n#{email} isn't a valid email address. "
 		email = get_valid_email(first_name,last_name,error_msg)
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

	def modify_contact(contact) #Code similar to search class
		clear
		contact.print_contact
		field=identify_mod_field(contact)
		clear
		contact.print_contact
		case field
		when 1
			value = get_value(contact, "first name")
			contact.first_name.replace value
		when 2
			value = get_value(contact, "last name")
			contact.last_name.replace value
		when 3
			value = get_value(contact, "email")
			contact.email.replace value
		when 4
			value = get_value(contact, "note")
			contact.note.replace value
		when 5
			clear
			gets
			return nil
		end
		clear
		puts contact.print_contact
		puts "Record successfully modified! Press enter to continue."
		gets
	end

	def get_value(contact, field)
		print "Enter the new #{field}: "
		input = gets.chomp
		if input == ""
			clear
			contact.print_contact
			print "You can't make the #{field} field blank. "
			input = get_value(contact, field)
		end
		if field == "email"
			return input if input.include?("@") && input.include?(".")
			clear
			contact.print_contact
			print "#{input} isn't a valid email address. "
			input = get_value(contact, field)
		end
		return input
	end

	def identify_mod_field(contact)
 		print_field_options
 		input = gets.chomp.to_i
		unless (1..5).include?(input)
	 		clear
	 		contact.print_contact
	 		print "\nThat is not a valid choice."
	 		input = identify_mod_field(contact)
	 	end
	 	return input
 	end
 	
 	def print_field_options
		puts "\nWhich attribute do you want to modify?"
		puts "[1] First name"
	  puts "[2] Last name"
	  puts "[3] Email"
	  puts "[4] Note" 	
	  puts "[5] CANCEL"
	  print "\nCHOICE: "	
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
		puts rolodex_header("Delete contact")
		puts "Contact deleted! Press enter to continue."
		gets
	end


 	def print_all
 		clear
 		puts rolodex_header("All contacts".upcase)
 		@contact_array.each {|contact| contact.print_contact}
 		puts "Press enter to continue."
 		gets
 	end

end