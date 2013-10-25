class Rolodex
	attr_accessor :name, :contact_array

	def initialize(name)
		@name = name	
		@contact_array = []
		@id_to_assign = 1000
	end

	def add_contact_to_book(contact)
		contact.id =  @id_to_assign
		@id_to_assign += 1		
		@contact_array << contact
	end

	def modify_contact
		puts "Let's find the contact you want to modify."
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
		puts matches.to_s
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
	 		print "That is not a valid choice."
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
end