require_relative "utilities"
require_relative "contact_search"
include Utilities
include ContactSearch

class Rolodex
	attr_accessor :name, :contact_array, :id_to_assign

	def initialize(name)
		@name = name	
		@contact_array = []
		@id_to_assign = 1
	end

	def header(message)
		hr + "\n" + self.name.upcase + ": " + message + "\n" + hr
	end

 	def insert_database_contact(id, first_name, last_name, email, note)
 		contact = Contact.new(id, first_name, last_name,email, note)
 		@contact_array << contact
 	end

 	def add_contact
 		clear
 		contact_header = header("Add contact") #string
 		puts contact_header
 		error_msg = "\n\nThis field is mandatory."
 		first_name = mandatory_gets("First name: ", (contact_header + error_msg))
 		last_name = mandatory_gets("Last name: ", (contact_header+"\nFirst name: #{first_name}"+ error_msg))
 		email = get_valid_email(first_name,last_name, error_msg)
 		note = mandatory_gets("Note: ", (contact_header+"\nFirst name: #{first_name}\nLast name: #{last_name}\nEmail:#{email}"+ error_msg))

 		id = @id_to_assign
 		@id_to_assign += 1
 		contact = Contact.new(id, first_name, last_name, email, note)
		@contact_array << contact
		sort_by_name
		clear
		puts header("Add contact")
		puts contact.print_contact
		puts "Contact added! Press enter to continue."
		gets
 	end

 	def get_valid_email(first_name, last_name, error_msg)
 		email = mandatory_gets("Email: ", (header("Add contact")+"\nFirst name: #{first_name}\nLast name: #{last_name}"+ error_msg))
 		return email if email.include?("@") && email.include?(".")
 		clear
 		puts header("Add contact")+"\nFirst name: #{first_name}\nLast name: #{last_name}\n"
 		print "\n#{email} isn't a valid email address. "
 		email = get_valid_email(first_name,last_name,error_msg)
 	end

	def sort_by_name
		@contact_array.sort_by! {|contact| contact.last_name + contact.first_name}
	end

	def interact_contacts
 		results = search_contacts
 		if results.nil?
 			return nil #Nil result means user cancelled search
 		elsif results.empty?
 			clear
 			puts header("Search")
 			puts "Sorry, I didn't find anything."
 			puts "Press enter to continue."
 			gets
 			return nil
 		else 			
 			propose_actions(results)
		end
	end

 	def propose_actions(results)
		counter = 0
		results.each do |contact|
			counter += 1
			clear
			puts header("Search results (Match #{counter} of #{results.length})")
			
			input = get_action_choice(contact, counter, results.length)
			case input
			when 1
				modify_contact(contact)
				return
			when 2
				clear
				puts header("Delete contact")
				if validate_deletion(contact)
					index = identify_index(contact)
					delete_contact(index)
				else
					clear
					puts header("Delete contact")
					puts "Deletion cancelled. Press enter to continue."
					gets
				end
				return
			when 3
				#do nothing, continue loop to next result or exit
			end
		end
	end

	def get_action_choice(contact, result_num, total_results)
		contact.print_contact
		puts "\nWhat do you want to do?"
		puts "[1] Modify this record"
		puts "[2] Delete this record"
		puts result_num==total_results ? "[3] Return to main menu" : "[3] Next result"
		print "\nCHOICE: "

		input = gets.chomp.to_i
		unless (1..3).include?(input)
			clear
			puts header("Search results (Match #{result_num} of #{total_results})")
			puts "\nThat is not a valid choice."
			input = get_action_choice(contact, result_num, total_results)
		end
		return input
	end

	def modify_contact(contact) #Code similar to search module
		clear
		puts header("Modify contact")
		contact.print_contact
		field=identify_mod_field(contact)
		clear
		puts header("Modify contact")
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
			puts header("Modify contact")
			puts "Modification cancelled. Press enter to continue."
			gets
			return nil
		end
		clear
		puts header("Modify contact")
		puts contact.print_contact
		puts "Record successfully modified! Press enter to continue."
		gets
	end

	def get_value(contact, field)
		print "Enter the new #{field}: "
		input = gets.chomp
		if input == ""
			clear
			puts header("Modify contact")
			contact.print_contact
			print "You can't make the #{field} field blank. "
			input = get_value(contact, field)
		end
		if field == "email"
			return input if input.include?("@") && input.include?(".")
			clear
			puts header("Modify contact")
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
			puts header("Modify contact")
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
		puts "[2] Cancel\n"
		print "CHOICE: "
		input = gets.chomp.to_i
		unless (1..2).include?(input)
			clear
			puts header("Delete contact")
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
		puts header("Delete contact")
		puts "Contact deleted! Press enter to continue."
		gets
	end

 	def print_all
 		clear
 		puts header("All contacts".upcase)
 		@contact_array.each {|contact| contact.print_contact}
 		puts "Press enter to continue."
 		gets
 	end

end