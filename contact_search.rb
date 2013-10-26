require_relative "utilities"
include Utilities

class ContactSearch
	attr_reader :results

	def initialize(contact_array)
 		@contact_array = contact_array
 		field = identify_search_field
		return nil if field==5
		query = identify_search_query
		@results = search_rolodex(field, query)
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
		clear
		puts "\nWhich attribute do you want to search for?"
		puts "[1] First name"
	  puts "[2] Last name"
	  puts "[3] Email"
	  puts "[4] Note" 	
	  puts "[5] CANCEL"
	  print "\nCHOICE: "	
 	end

	def identify_search_query
		print "Enter a search term: "
		input=gets.chomp.downcase
		until input != ""
			print "I can't search for nothing! "
			identify_search_query
		end
		return input
	end

	def search_rolodex(field, query)
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

	def print_matches
		clear
		puts "\nHere are the results:"
		@results.each {|contact| contact.print_contact}
	end

end