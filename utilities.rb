module Utilities
	def mandatory_gets(prompt,error_msg)
		print prompt
		input = gets.chomp
		if input == ""
			print error_msg + " "
			mandatory_gets(prompt, error_msg)
		end
		return input
	end
end