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
		
	end
end