module Utilities

 	def rolodex_header(message)
		hr + "\n" + self.name.upcase + ": " + message + "\n" + hr
	end

	def hr
		"--------------------------------------------"
	end

	def welcome_header
		hr + "\n\n   Welcome to Rolodex contact management!\n\n".upcase + hr
	end

	def cra_header(message)
		hr + "\n" + message + "\n" + hr
	end

	def mandatory_gets(prompt,error_msg)
		print prompt
		input = gets.chomp
		if input == ""
			clear
			print error_msg + " "
			input = mandatory_gets(prompt, error_msg)
		end
		return input
	end

	def clear
 		puts "\e[H\e[2J"
	end
end
