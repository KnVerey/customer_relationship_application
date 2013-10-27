require_relative "contact"
require_relative "rolodex"
require_relative "utilities"
require_relative "sample_data"
include Utilities
include SampleData

class CRA

	def self.run
		clear			
		puts welcome_header
		load_rolodex_list

		if @rolodex_list.empty?
			puts "You don't have any contact books yet."
			add_new_rolodex
		else
			choose_rolodex
		end
		main_menu
	end

	def self.load_rolodex_list
		@rolodex_list = []
		#DELETE BELOW TO REMOVE SAMPLE BOOK
		import_sample_books
	end

	def self.add_new_rolodex
		name = mandatory_gets("Please enter a name for your new contact book.\nNAME: ", (cra_header("Add new contact book") + "\nNaming the book is mandatory."))
		rolodex = Rolodex.new(name)
		@rolodex_list << rolodex
		open_rolodex(-1)
	end

	def self.choose_rolodex
		puts "Please choose which contact book to open."
		selector = 1 #0 cannot be a valid choice (string.to_i)
		@rolodex_list.each do |book|
			puts "[#{selector}]: #{book.name}"
			selector += 1
		end
		puts "[#{selector}]: Add a new book" #incremented after last book
		print "\nCHOICE: "
		input = gets.chomp.to_i

		if (1..(selector-1)).include? input
			open_rolodex(input-1) #i.e. index
		elsif input == selector #i.e. add new
				clear
				puts cra_header("Add new contact book")
				add_new_rolodex
		else
			clear
	 		puts cra_header("Choose contact book")
	 		print "\nThat is not a valid choice. "
	 		input = choose_rolodex
		end
	end

	def self.open_rolodex(index)
		@current_index = index
	end

	def self.main_menu
		selection = 1
		while selection != 5
			print_main_menu
			selection = gets.chomp.to_i
			execute_selection(selection)
		end
	end

	def self.print_main_menu
 		clear
 		puts cra_header(@rolodex_list[@current_index].name.upcase + ": Main menu")
		puts "\nPlease select one of the following options:"
		puts "[1] Add a new contact"
	  puts "[2] Find an existing contact (view, change or delete)"
	  puts "[3] Display all contacts"
	  puts "[4] Load or create a different contact book"
	  puts "[5] Exit"
	  print "\nCHOICE: "
	end

	def self.execute_selection(selection)
		case selection
		when 1
			@rolodex_list[@current_index].add_contact
		when 2
 			@rolodex_list[@current_index].interact_contacts
		when 3
			@rolodex_list[@current_index].print_all
		when 4
			clear
			puts cra_header("Choose contact book")
			choose_rolodex
 		when 5
			clear
			save_database
		else
			puts "\nInvalid selection. Here are your options:"
		end
 	end

 	def self.save_database
 		file_list=""
 		@rolodex_list.each do |rolodex|
 			file_list << "#{rolodex.name}\n"
 			output = File.new(rolodex.name, "w")
 			rolodex.contact_array.each do |contact|
 				output.puts(contact.id.to_s + "\n")
 				output.puts(contact.last_name + "\n")
 				output.puts(contact.first_name + "\n")
 				output.puts(contact.email + "\n")
 				output.puts(contact.note + "\n")
 			end
 			output.close
 		end

 		list = File.new("rolodex_list", "w")
 		list.puts(file_list)
 		list.close
 	end

end

CRA.run