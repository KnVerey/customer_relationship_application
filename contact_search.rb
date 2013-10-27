module ContactSearch

	def search_contacts
 		clear
 		puts header("Search")
 		field = identify_search_field
		return nil if field==5
		search_rolodex(field)
	end

	def identify_search_field
 		print_search_options
 		input = gets.chomp.to_i
		unless (1..5).include?(input)
	 		clear
	 		puts header("Search")
	 		print "\nThat is not a valid choice."
	 		input = identify_search_field
	 	end
	 	return input
 	end
 	
 	def print_search_options
		puts "\nWhich attribute do you want to search for?"
		puts "[1] First name"
	  puts "[2] Last name"
	  puts "[3] Email"
	  puts "[4] Note" 	
	  puts "[5] CANCEL"
	  print "\nCHOICE: "	
 	end

	def search_rolodex(field)
		clear
		puts header("Search")
		query = get_query
		results = []
		@contact_array.each	do |contact|
			case field
			when 1
				results<<contact if contact.first_name.downcase.include?(query)
			when 2 
				results<<contact if contact.last_name.downcase.include?(query)
			when 3 
				results<<contact if contact.email.downcase.include?(query)
			when 4 
				results<<contact if contact.note.downcase.include?(query)
			end
		end
		return results
	end

	def get_query
		print "Enter a search term: "
		input=gets.chomp.downcase
		until input != ""
			clear
			puts header("Search")
			print "I can't search for nothing! "
			input = get_query
		end
		return input
	end

end