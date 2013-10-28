require_relative "contact"
require_relative "rolodex"
require_relative "utilities"
include Utilities

class CRA

	def self.run
		clear			
		puts welcome_header
		@rolodex_list = []
		load_saved_rolodexes if File::exists?("./data/rolodex_list")

		if @rolodex_list.empty?
			puts "You don't have any contact books yet."
			add_new_rolodex
		else
			choose_rolodex
		end
		main_menu
	end

	def self.load_saved_rolodexes
		file_list = IO.read("./data/rolodex_list").split("\n")
		file_list.each do |filename|
			 new_rolodex = Rolodex.new(filename)
			 all_contacts = IO.read("./data/"+filename).split("\n")
			 id_counter=[]
			 until all_contacts == []
			 		id = all_contacts.slice!(0).to_i
			 		first_name = all_contacts.slice!(0)
			 		last_name = all_contacts.slice!(0)
			 		email = all_contacts.slice!(0)
			 		note = all_contacts.slice!(0)
			 		new_rolodex.insert_database_contact(id, first_name, last_name, email, note)
			 		id_counter << id
			 end
			 if id_counter.empty? #empty contact book
			 		new_rolodex.id_to_assign = 1
			 else
			 		new_rolodex.id_to_assign = (id_counter.sort.last + 1)
			 end
			 @rolodex_list << new_rolodex
			 new_rolodex.sort_by_name
		end
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
		puts
		puts "[#{selector}]: Add a new book" #incremented after last book
		puts "[#{selector+1}]: Delete an existing book"
		print "\nCHOICE: "
		input = gets.chomp.to_i

		if (1..(selector-1)).include? input #within indices
			open_rolodex(input-1) #i.e. index
		elsif input == selector #i.e. add new
			clear
			puts cra_header("Add new contact book")
			add_new_rolodex
		elsif input==(selector+1) #i.e. delete
			clear
			puts cra_header("Delete a contact book")
			puts "Which book do you want to delete?"
			delete_a_book
		else
			clear
	 		puts cra_header("Choose contact book")
	 		print "\nThat is not a valid choice. "
	 		input = choose_rolodex
		end
	end

	def self.delete_a_book
		selector = 1 #0 cannot be a valid choice (string.to_i)
		@rolodex_list.each do |book|
			puts "[#{selector}]: #{book.name}"
			selector += 1
		end
		puts "[#{selector}]: CANCEL"
		print "\nCHOICE: "
		input = gets.chomp.to_i

		if (1..(selector-1)).include? input #within indices
			clear
			puts cra_header("Delete a contact book")

			if really_delete_book?(input-1)
				@rolodex_list.delete_at(input-1) #i.e. index
				clear
				puts cra_header("Delete a contact book")
				puts "Contact book successfully deleted. Press enter to continue."
				gets
				clear
				puts cra_header("Choose contact book")
				choose_rolodex
			else
				clear
				puts cra_header("Delete a contact book")
				puts "Deletion cancelled. Press enter to continue."
				gets
				clear
				puts cra_header("Choose contact book")
				choose_rolodex
			end
		elsif selector==input #i.e. cancel
			clear
			puts cra_header("Choose contact book")
 			choose_rolodex
		else
			clear
			puts cra_header("Delete a contact book")
			puts "\n That is not a valid choice. "
			input = delete_a_book
		end
	end

def self.really_delete_book?(book_index)
		name = @rolodex_list[book_index].name
		puts "\nAre you sure you want to delete #{name}?"
		puts "[1] Yes"
		puts "[2] Cancel\n"
		print "CHOICE: "
		input = gets.chomp.to_i
		unless (1..2).include?(input)
			clear
			puts header("Delete a contact book")
			puts "\n That is not a valid choice."
			input = really_delete_book?(book_index)
		end
		input==1? true : false
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
			save_database
		when 2
 			@rolodex_list[@current_index].interact_contacts
 			save_database
		when 3
			@rolodex_list[@current_index].print_all
		when 4
			save_database
			clear
			puts cra_header("Choose contact book")
			choose_rolodex
			save_database
 		when 5
			clear
		else
			puts "\nInvalid selection. Here are your options:"
		end
 	end

 	def self.save_database
 		file_list=""
 		@rolodex_list.each do |rolodex|
 			file_list << "#{rolodex.name}\n"
 			output = File.new("./data/"+rolodex.name, "w")
 			rolodex.contact_array.each do |contact|
 				output.puts(contact.id.to_s + "\n")
 				output.puts(contact.first_name + "\n")
 				output.puts(contact.last_name + "\n")
 				output.puts(contact.email + "\n")
 				output.puts(contact.note + "\n")
 			end
 			output.close
 		end

 		list = File.new("./data/rolodex_list", "w")
 		list.puts(file_list)
 		list.close
 	end

end

CRA.run