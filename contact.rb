class Contact
	attr_accessor :id, :first_name, :last_name, :email, :note

	def initialize(first_name, last_name, email, note)
		@first_name = first_name
		@last_name = last_name
		@email = email
		@note = note
	end

	def print_contact
		puts "--------------------------------------------"
		puts "Contact No: " + @id.to_s
		puts "--------------------------------------------"
		puts @last_name.upcase + ", " + @first_name.upcase
		puts "Email: " + @email
		puts "Notes: " + @note
		puts
	end

end