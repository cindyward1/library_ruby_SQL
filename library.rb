require "pg"
require "date"
require "./lib/book.rb"
require "./lib/copy.rb"
require "./lib/author.rb"
require "./lib/written_by.rb"
require "./lib/checkout.rb"
require "./lib/patron.rb"

DB = PG.connect(:dbname => "cindys_library")
@current_patron = nil

def choose_user
	puts "\n"
	puts "               _________________________________________________________"
	puts "              ||-------------------------------------------------------||"
	puts "              ||.--.    .-._                        .----.             ||"
	puts "              |||==|____| |H|___            .---.___|''''|_____.--.___ ||"
	puts "              |||  |====| | |xxx|_          |+++|=-=|_  _|-=+=-|==|---|||"
	puts "              |||==|    | | |   | \\         |   |   |_\\/_|Black|  | ^ |||"
	puts "              |||  |    | | |   |\\ \\   .--. |   |=-=|_/\\_|-=+=-|  | ^ |||"
	puts "              |||  |    | | |   |_\\ \\_( oo )|   |   |    |Magus|  | ^ |||"
	puts "   Welcome    |||==|====| |H|xxx|  \\ \\ |''| |+++|=-=|''''|-=+=-|==|---|||"
	puts "     to       ||`--^----'-^-^---'   `-' ''  '---^---^----^-----^--^---^||"
	puts "   Cindy's    ||-------------------------------------------------------||"
	puts "   Library    ||-------------------------------------------------------||"
	puts "              ||               ___                   .-.__.-----. .---.||"
	puts "              ||              |===| .---.   __   .---| |XX|<(*)>|_|^^^|||"
	puts "              ||         ,  /(|   |_|III|__|''|__|:x:|=|  |     |=| Q |||"
	puts "              ||      _o'{ / (|===|+|   |++|  |==|   | |  |Illum| | R |||"
	puts "              ||      '/\\\\/ _(|===|-|   |  |''|  |:x:|=|  |inati| | Y |||"
	puts "              ||_____  -\\{___(|   |-|   |  |  |  |   | |  |     | | Z |||"
	puts "              ||       _(____)|===|+|[I]|DK|''|==|:x:|=|XX|<(*)>|=|^^^|||"
	puts "              ||              `---^-^---^--^--'--^---^-^--^-----^-^---^||"
	puts "              ||-------------------------------------------------------||"
	puts "              ||_______________________________________________________||"
	puts "\n\n"
	user_type = ""
	@current_patron = nil
	while user_type != 'X'
		puts "\nMAIN MENU"
		puts "Menu options:"
		puts "  L = if you are a librarian"
		puts "  P = if you are a library patron"
		puts "  M = go to the main menu (this menu)"
		puts "  X = exit the program"
		user_type = gets.chomp.upcase
		if user_type == "L"
			librarian_menu
		elsif user_type == "P"
			patron_menu
		elsif user_type == "X"
			exit_program
		elsif user_type != "M"
			puts "\nInvalid option, try again"
		end
	end
end

def librarian_menu
	option = ""
	while option != "m" && option != "x"
		puts "\nLIBRARIAN MENU\n"
		puts "Menu options:"
		puts "  m = go back to the main menu"
		puts "  x = exit the program"
		puts "  b = go to book catalog maintenance menu"
		puts "  p = go to patron maintenance menu\n"
		option = gets.chomp.downcase
		if option == "b"
			books_menu
		elsif option == "p"
			patron_maint_menu
		elsif option == "x"
			exit_program
		elsif option != "m"
			puts "Invalid option, try again"
		end
	end
end

def books_menu
	option = ""
	while option != "m" && option != "x" && option != "b"
		puts "\nBOOKS MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to librarian menu"
		puts "  x = exit the program"
		puts "  n = check in a book"
		puts "  a = add a book to the catalog"
		puts "  f = find a book by title"
		puts "  i = find a book by ISBN-10 number"
		puts "  l = list all books in the catalog"
		puts "  c = update the number of copies of a book"
		puts "  u = update book information"
		puts "  d = delete a book from the catalog"
		option = gets.chomp.downcase
		if option == "n"
			checkin_book
		elsif option == "a"
			add_book_to_catalog
		elsif option == "f"
			find_book_by_title
		elsif option == "i"
			find_book_by_ISBN
		elsif option == "l"
			list_all_books
		elsif option == "c"
			the_book_array = []
			update_number_copies(the_book_array)
		elsif option == "u"
			update_book_information
		elsif option == "d"
			delete_book
		elsif option == "x"
			exit_program
		elsif option != "b"
			puts "\nInvalid option, try again"
		end
	end
end

def checkin_book
	puts "\nCHECK IN A RETURNED BOOK"
	the_book_array = get_book_array_by_title_or_isbn_10
	if !the_book_array.empty?
		the_book = the_book_array.first
		puts "Enter the name of the patron checking in the book"
		patron_name = gets.chomp
		the_patron_array = Patron.get_by_name(patron_name)
		if the_patron_array.empty?
			puts "\nThere is no patron #{patron_name} in the database"
		else
			the_patron = the_patron_array.first
			copy_checkout_hash_array = the_book.find_copy_checkout_from_patron_book(the_patron.id)
			if copy_checkout_hash_array.length == 1
				copy_id = copy_checkout_hash_array.first['copy_id']
				the_copy_array = Copy.get_by_id(copy_id)
			elsif copy_checkout_hash_array.length > 1
				puts "\nThe patron #{the_patron.name} has multiple copies of #{the_book.title} checked out"
				puts "Please provide the unique copy number of the book being checked in"
				copy_input_id = gets.chomp.to_i
				the_copy_array = Copy.get_by_id(copy_input_id)
				copy_id = the_copy.id
				if the_copy_array.empty?
					puts "\nCopy number #{copy_input_id} was not found for book #{the_book.title}"
					copy_id = 0
				end
			elsif copy_checkout_hash_array.length = 0
				puts "\nInternal error: checkout #{the_checkout.id} of book #{the_book.title} for patron #{the_patron.name} has no corresponding copy"
				copy_id = 0
			end
			if copy_id != 0
				the_copy = the_copy_array.first
				the_checkout = Checkout.get_by_id(the_copy.checkout_id).first
				the_copy.check_in
				today = Date.today
				today_char = today.month.to_s + "/" + today.day.to_s + "/" + today.year.to_s
				the_checkout.check_in(today_char)
				puts "\nThe book #{the_book.title} checked out by patron #{the_patron.name} has been checked in"
			end
		end
	end
end

def get_book_array_by_title_or_isbn_10
	puts "Enter the book title or ISBN-10"
	input_info = gets.chomp
	if input_info !~ /\d\d\d\d\d\d\d\d\d\d/
		the_book_array = Book.get_by_title(input_info)
	else
		the_book_array = Book.get_by_isbn_10(input_info)
	end
	if the_book_array.empty?
		puts "\nThere is no book in the catalog with the information #{input_info}"
	end
	the_book_array
end

def add_book_to_catalog
	puts "\nADD BOOK TO CATALOG"
	puts "Enter the title of the new book"
	new_title = gets.chomp
	new_book_array = Book.get_by_title(new_title)
	if new_book_array.empty?
		puts "Enter the ISBN-10 number of the new book"
		new_isbn_10 = gets.chomp
		if new_isbn_10 !~ /\d\d\d\d\d\d\d\d\d\d/
			puts "\nInvalid format for ISBN-10, try again"
		else
			new_book_array = Book.get_by_isbn_10(new_isbn_10)
			if new_book_array.empty?
				new_book = Book.new({:title=>new_title, :isbn_10=>new_isbn_10})
				new_book.save
				puts "\nEnter the number of book authors"
				number_authors = gets.chomp.to_i
				for author_count in (1..number_authors)
					add_author_and_written_by(new_book.id)
				end
				puts "\nEnter the number of copies of the new book"
				number_copies = gets.chomp.to_i
				for copy_count in (1..number_copies)
					new_copy = Copy.new({:book_id=>new_book.id, :checkout_id=>0})
					new_copy.save
				end
				plural = "copies"
				plural_verb = "were"
				if number_copies == 1
					plural = "copy"
					plural_verb = "was"
				end
				puts "\n#{number_copies} #{plural} of '#{new_book.title}' (ISBN-10 #{new_book.isbn_10}) #{plural_verb} added to the catalog\n"
			else
				new_book = new_book_array.first
				puts "\n'#{new_book.title}' (ISBN-10 #{new_book.isbn_10}) is already in the database"
				puts "Updating the number of copies instead\n"
				update_number_copies(new_book_array)
			end
		end
	else
		new_book = new_book_array.first
		puts "\n'#{new_book.title}' (ISBN-10 #{new_book.isbn_10}) is already in the database"
		puts "Updating the number of copies instead\n"
		update_number_copies(new_book_array)
	end
end

def add_author_and_written_by(new_book_id)
	puts "\nEnter the name of the author"
	new_author_name = gets.chomp
	if Author.get_by_name(new_author_name).empty?
		new_author = Author.new({:name=>new_author_name})
		new_author.save
	else
		new_author = Author.get_by_name(new_author_name).first
	end
	new_author_id = new_author.id
	new_written_by = Written_by.get_by_book_and_author_ids(new_book_id, new_author_id)
	new_book = Book.get_by_id(new_book_id).first
	if new_written_by.empty?
		new_written_by = Written_by.new({:author_id=>new_author_id, :book_id=>new_book_id})
		new_written_by.save
		puts "\nAuthor #{new_author_name} has been added to the authorship of '#{new_book.title}'"
	else
		puts "\nAuthor #{new_author_name} was already listed as an author of #{new_book.title}"
	end
end

def find_book_by_title
	puts "\nEnter the title of the book to find"
	the_title = gets.chomp
	the_book_array = Book.get_by_title(the_title)
	if the_book_array.empty?
		puts "\n#{the_title} is not in the catalog\n"
	else
		display_author_names(the_book_array.first)
	end
end

def find_book_by_ISBN
	puts "\nEnter the ISBN-10 of the book to find"
	the_isbn_10 = gets.chomp
	if the_isbn_10 !~ /\d\d\d\d\d\d\d\d\d\d/
		puts "\nInvalid format for ISBN-10, try again"
	else
		the_book_array = Book.get_by_isbn_10(the_isbn_10)
		if the_book_array.empty?
			puts "\nISBN-10 #{the_isbn_10} is not in the catalog\n"
		else
			display_author_names(the_book_array.first)
		end
	end
end

def display_author_names(the_book)
	number_of_copies = the_book.count_copies
	puts "\nThere are #{number_of_copies} copies of '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) in the library"
	author_array = the_book.find_authors
	if author_array.empty?
		puts "No authors listed for this book"
	else
		author_array.each_with_index do |author, index|
			puts "  Author #{index+1}. #{author.name}"
		end
	end
	puts "\n"
end

def list_all_books
	puts "\nCindy's Library Book Catalog\n\n"
	the_catalog = Book.all
	if the_catalog.empty?
		puts "There are no books in the catalog"
	else
		the_catalog.each_with_index do |the_book, index|
			number_of_copies = the_book.count_copies
			puts "#{index+1}. #{the_book.title} (#{number_of_copies} copies)"
		end
	end
	puts "\n"
end

def update_number_copies(the_book_array)
	if the_book_array.empty?
		the_book_array = get_book_array_by_title_or_isbn_10
	end
	if !the_book_array.empty?
		the_book = the_book_array.first
		number_copies = the_book.count_copies
		plural = "copies"
		plural_verb = "are"
		if number_copies == 1
			plural = "copy"
			plural_verb = "is"
		end
		puts "\n"
		puts "\nThere #{plural_verb} currently #{number_copies} #{plural} of '#{the_book.title}'"
		puts "Enter the number of copies to add (enter a negative number to subtract copies)"
		number_change = gets.chomp.to_i
		if number_change > 0
			for copy_count in (1..number_change)
				new_copy = Copy.new({:book_id=>the_book.id, :checkout_id=>0})
				new_copy.save
			end
			plural = "copies"
			plural_verb = "were"
			if number_change == 1
				plural = "copy"
				plural_verb = "was"
			end
			puts "\n#{number_change} #{plural} of '#{the_book.title}' #{plural_verb} added"
		elsif number_change < 0
			if number_change.abs > number_copies
				puts "\nNo copies of '#{the_book.title}' were deleted"
				puts "The requested number of copies to delete was more than the total"
			else
				copies_actually_deleted = 0
				for copy_count in (1..number_change.abs)
					the_copy_array = Copy.get_by_book_id_not_checked_out(the_book.id)
					if the_copy_array.empty?
						plural = "copies"
						plural_verb = "were"
						if copy_count-1 == 1
							plural = "copy"
							plural_verb = "was"
						end
						puts "\nOnly book copies that aren't checked out can be deleted"
						puts "There #{plural_verb} only #{copy_count-1} #{plural} of '#{the_book.title}' that #{plural_verb} not checked out"
					else
						the_copy = the_copy_array.first
						the_checkout_array = Checkout.get_by_copy_id(the_copy.id)
						the_checkout_array.each do |checkout|
							checkout.delete
						end
						the_copy.delete
						copies_actually_deleted += 1
					end
				end
				plural = "copies"
				plural_verb = "were"
				if copies_actually_deleted == 1
					plural = "copy"
					plural_verb = "was"
				end
				puts "\n#{copies_actually_deleted} #{plural} of '#{the_book.title}' #{plural_verb} deleted"
				check_copy_array = Copy.get_by_book_id(the_book.id)
				if check_copy_array.empty?
					written_by_array = Written_by.get_by_book_id(the_book.id)
					written_by_array.each do |written_by|
						written_by.delete
					end
					the_book.delete
					puts "\n'#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) was deleted"
				end
			end
		else
			puts "\nNo copies of '#{the_book.title}' were deleted; requested number of copies to delete was 0"
		end
		number_copies = the_book.count_copies
		if number_copies != 0
			plural = "copies"
			plural_verb = "are"
			if number_copies == 1
				plural = "copy"
				plural_verb = "is"
			end 
			puts "There #{plural_verb} now #{number_copies} #{plural} of '#{the_book.title}'"
		end
	end
end

def update_book_information
	the_book_array = get_book_array_by_title_or_isbn_10
	if !the_book_array.empty?
		the_book = the_book_array.first
		display_author_names(the_book)
		puts "\nUPDATE BOOK MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to the librarian's books menu"
		puts "  x = exit program"
		puts "  t = update title"
		puts "  i = update ISBN-10"
		puts "  a = update author information"
		option = gets.chomp
		if option == "t"
			puts "\nEnter the new title for '#{the_book.title}' (ISBN-10 #{the_book.isbn_10})"
			new_title = gets.chomp
			the_book.update_title(new_title)
			puts "\nThe title is now '#{new_title}' (ISBN-10 #{the_book.isbn_10})"
		elsif option == "i"
			puts "\nEnter the new ISBN-10 for '#{the_book.title}' (ISBN-10 #{the_book.isbn_10})"
			new_isbn_10 = gets.chomp
			if new_isbn_10 !~ /\d\d\d\d\d\d\d\d\d\d/
				puts "\nInvalid format for ISBN-10, try again"
			else
				the_book.update_isbn_10(new_isbn_10)
				puts "\nThe ISBN-10 is now #{new_isbn_10} (title '#{the_book.title}')"
			end
		elsif option == "a"
			author_array = the_book.find_authors
			if author_array.length > 0
				puts "\nThe author(s) for '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) are"
				author_array.each_with_index do |author, index|
					puts "  Author #{index+1}. #{author.name}"
				end
			else
				puts "\nThere are no authors for '#{the_book.title}; consider adding authors"
			end
			update_author_menu(the_book, author_array)
		elsif option == "x"
			exit_program
		elsif option != "b"
			puts "\nInvalid option, try again"
		end
	end
end

def update_author_menu(the_book, author_array)
	puts "\nUPDATE AUTHOR MENU for LIBRARIAN"
	puts "Menu options:"
	puts "  b = go back to the librarian's books menu"
	puts "  x = exit the program"
	puts "  d = delete an author"
	puts "  a = add an author"
	puts "  u = update the author's name"
	option = gets.chomp.downcase
	if option == "a"
		add_author_and_written_by(the_book.id)
	elsif option == "u" || option == "d"
		word_hash = {"u"=>"change","d"=>"delete"}
		puts "\nSelect the index of the author whose name to #{word_hash.fetch(option)}"
		author_index = gets.chomp.to_i
		author = author_array[author_index-1]
		if option == "u" && author_index > 0
			add_author_and_written_by(the_book.id)
		end
		if author_index > 0
			written_by_array = Written_by.get_by_author_id(author.id)
			written_by_array.each do |written_by|
				written_by.delete
			end
			puts "\nAuthor #{author.name} has been deleted from the authorship of '#{the_book.title}'"
		end
	elsif option == "x"
			exit_program
	elsif option != "b"
		puts "\nInvalid option, try again"
	end
end

def delete_book
	the_book_array = get_book_array_by_title_or_isbn_10
	if !the_book_array.empty?
		the_book = the_book_array.first
		puts "\nDeleting a book will remove all of its checkout history"
		puts "This operation cannot be undone! Enter 'y' or 'yes' to delete"
		puts "Enter 'x' to exit the program or 'b' to go back to the librarian's books menu"
		option = gets.chomp.slice(0,1).downcase
		if option == "y"
			copies_array_available = Copy.get_by_book_id_not_checked_out(the_book.id)
			copies_array_total = Copy.get_by_book_id(the_book.id)
			if copies_array_available.length < copies_array_total.length && copies_array_total.length > 0
				puts "\nThere are checked-out copies of '#{the_book.title}'; the book cannot be deleted"
			elsif copies_array_total.length == 0
				puts "\nThere are no copies of '#{the_book.title}' to delete"
			else
				copies_array_available.each do |copy|
					the_checkout_array = Checkout.get_by_copy_id(copy.id)
					the_checkout_array.each do |checkout|
						checkout.delete
					end
					copy.delete;
				end
				written_by_array = Written_by.get_by_book_id(the_book.id)
				written_by_array.each do |written_by|
					written_by.delete
				end
				the_book.delete
				puts "\n'#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) was deleted"
			end
		elsif option == "x"
			exit_program
		elsif option != "b"
			puts "Invalid option, try again"
		end
	end
end


def patron_maint_menu
option = ""
	while option != "m" && option != "x" && option != "b"
		puts "\nPATRON MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to librarian menu"
		puts "  x = exit the program"
		puts "  a = add a patron to the database"
		puts "  f = find a patron by name"
		puts "  i = find a patron by phone number"
		puts "  l = list all patrons in the database"
		puts "  n = update a patron's name"
		puts "  u = update a patron's phone number"
		puts "  d = delete a patron from the database"
		puts "  p = find a patron's overdue books"
		puts "  o = find all patron's overdue books"
		option = gets.chomp.downcase
		if option == "a"
			add_patron_to_database
		elsif option == "f"
			find_patron_by_name
		elsif option == "i"
			find_patron_by_phone_number
		elsif option == "l"
			list_all_patrons
		elsif option == "n"
			update_patron_name
		elsif option == "u"
			update_patron_phone_number
		elsif option == "d"
			delete_patron
		elsif option == "p"
			find_patron_overdue_books
		elsif option == "o"
			find_all_patrons_overdue_books
		elsif option == "x"
			exit_program
		elsif option != "b"
			puts "\nInvalid option, try again"
		end
	end
end

def add_patron_to_database
	puts "\nEnter the name of the new patron"
	new_name = gets.chomp
	new_patron_array = Patron.get_by_name(new_name)
	if new_patron_array.empty?
		puts "Enter the patron's phone number"
		new_phone = gets.chomp
		if new_phone !~ /\d\d\d-\d\d\d-\d\d\d\d/
			puts "\nInvalid format for phone number, try again"
		else
			new_patron = Patron.new({:name=>new_name, :phone_number=>new_phone})
			new_patron.save
			puts "\nPatron #{new_name}, phone number #{new_phone}, has been added to the database\n"
		end
	else
		new_patron = new_patron_array.first
		puts "\nPatron #{new_patron.name}, phone number #{new_patron.phone_number}, is already in the database"
	end
end

def find_patron_by_name
	puts "\nEnter the name of the patron to find"
	the_name = gets.chomp
	the_patron_array = Patron.get_by_name(the_name)
	if the_patron_array.empty?
		puts "\nPatron #{the_name} is not in the patron database\n"
	else
		the_patron = the_patron_array.first
		puts "\nPatron #{the_patron.name} is at phone number #{the_patron.phone_number}"
	end
	the_patron_array
end

def find_patron_by_phone_number
	puts "\nEnter the phone number of the patron to find"
	the_phone = gets.chomp
	the_patron_array = Patron.get_by_phone_number(the_phone)
	if the_phone !~ /\d\d\d-\d\d\d-\d\d\d\d/
		puts "\nInvalid format for phone number, try again"
	elsif the_patron_array.empty?
		puts "\nPhone number #{the_phone} is not in the patron database\n"
	else
		puts "\nThe list of patrons with phone number #{the_phone}\n"
		the_patron_array.each_with_index do |the_patron, patron_index|
			puts "#{patron_index+1}. #{the_patron.name}\n"
		end
		return the_patron_array
	end
end

def list_all_patrons
	puts "\nCindy's Library Patron Database\n\n"
	the_database = Patron.all
	if the_database.empty?
		puts "There are no patrons in the database"
	else
		the_database.each_with_index do |the_patron, index|
			number_checkouts = the_patron.count_checkouts
			number_overdue = the_patron.count_overdue
			puts "#{index+1}. #{the_patron.name} (phone number #{the_patron.phone_number})"
			puts "            Number of books currently checked out: #{number_checkouts}"
			puts "            Number of books overdue: #{number_overdue}\n"
		end
	end
	puts "\n"
end

def update_patron_name
	the_patron_array = find_patron_by_name
	the_patron = the_patron_array.first
	puts "\nEnter the new name for #{the_patron.name} (phone number #{the_patron.phone_number})"
	new_name = gets.chomp
	the_patron.update_name(new_name)
	puts "\nThe patron's name has been changed to #{new_name}"
end

def update_patron_phone_number
	the_patron_array = find_patron_by_phone_number
	puts "\nSelect the index of the patron's phone number to change"
	the_patron_index = gets.chomp.to_i
	the_patron = the_patron_array[the_patron_index-1]
	puts "\nEnter the new phone number for the patron"
	new_phone = gets.chomp
	if new_phone !~ /\d\d\d-\d\d\d-\d\d\d\d/
		puts "\nInvalid format for phone number, try again"
		the_patron.update_phone_number(new_phone)		
		puts "\nThe phone number of patron #{the_patron.name} has been changed to #{new_phone}"
	end
end

def delete_patron
	the_patron_array = find_patron_by_name
	the_patron = the_patron_array.first
	puts "\nPatron #{the_patron.name} and all of their checkout history will be deleted"
	puts "\nThis operation cannot be undone!! Enter 'y' or 'yes' to delete"
	puts "Enter 'x' to exit the program or 'p' to go back to the librarian's patron menu"
	option = gets.chomp.slice(0,1).downcase
	if option == "y"
		checkout_array = Checkout.get_by_patron_id(the_patron.id)
		has_checkouts = false
		checkout_array.each do |checkout|
			if checkout.checkin_date == "00/00/0000" || checkout.checkin_date == "01/01/0001"
				has_checkouts = true
			end
		end
		if has_checkouts
			puts "Patron #{the_patron.name} currently has books checked out and cannot be deleted"
		else
			checkout_array.each do |checkout|
				checkout.delete
			end
			puts "\nPatron #{the_patron.name} has been deleted"
			the_patron.delete
		end
	elsif option == "x"
		exit_program
	elsif option != "p"
		puts "Invalid option, try again"
	end
end

def find_patron_overdue_books
end

def find_all_patrons_overdue_books
end


def patron_menu
	puts "\n\nPlease enter your name"
	patron_name = gets.chomp
	the_patron_array = Patron.get_by_name(patron_name)
	if !the_patron_array.empty?			
		@current_patron = the_patron_array.first
		puts "\nWelcome to Cindy's Library, #{@current_patron.name}"
		option = ""
		while option != "m" && option != "x"
			puts "\nPATRON MENU"
			puts "Menu options:"
			puts "  m = go back to the main menu"
			puts "  x = exit the program"
			puts "  o = check out a book"
			puts "  c = check number of available copies of a book"
			puts "  h = see checkout history"
			puts "  d = check the due date of a book\n\n"
			option = gets.chomp.downcase
			if option == "o"
				checkout_book
			elsif option == "n"
				checkin_book
			elsif option == "c"
				available_copies_book
			elsif option == "h"
				checkout_history
			elsif option == "d"
				check_due_date_book
			elsif option == "x"
				exit_program
			elsif option != "m"
				puts "Invalid option, try again"
			end
		end
	else
		puts "\nYour name #{patron_name} is not in the patron database"
		puts "Please talk to the librarian about your privileges at Cindy's Library!"
	end
end

def checkout_book
	puts "\nCHECK OUT A BOOK\n"
	puts "#{@current_patron.name}, enter the book title to check out"
	checkout_title = gets.chomp
	the_book_array = Book.get_by_title(checkout_title)
	if !the_book_array.empty?
		the_book = the_book_array.first
		the_copy_array = Copy.get_by_book_id_not_checked_out(the_book.id)
		if !the_copy_array.empty?
			the_copy = the_copy_array.first
			today = Date.today
			checkout_date_formatted = today.month.to_s + "/" + today.day.to_s + "/" + today.year.to_s
			due_date = today + 30
			due_date_formatted = due_date.month.to_s + "/" + due_date.day.to_s + "/" + due_date.year.to_s
			checkin_date = "00/00/0000"
			the_checkout = Checkout.new({:patron_id=>@current_patron.id, :copy_id=>the_copy.id, :checkout_date=>checkout_date_formatted, 
																	 :due_date=>due_date_formatted, :checkin_date=>checkin_date})
			the_checkout.save
			the_copy.check_out(the_checkout.id)
			puts "\nYou checked out '#{the_book.title}' on #{checkout_date_formatted}, " +
						"due back on #{due_date_formatted}"
		else
			puts "\nThere is no copy of '#{the_book.title}' available to check out"
		end
	else
			puts "\nThe book '#{checkout_title}' is not in the catalog"
	end
end

def available_copies_book
	puts "\nCHECK THE NUMBER OF AVAILABLE COPIES OF A BOOK"
	the_book_array = get_book_array_by_title_or_isbn_10
	if !the_book_array.empty?
		the_book = the_book_array.first
		available_copies_array = Copy.get_by_book_id_not_checked_out(the_book.id)
		number_available_copies = available_copies_array.length
		plural = "copies"
		plural_verb = "are"
		if number_available_copies == 1
			plural = "copy"
			plural_verb = "is"
		end 
		puts "\n#{@current_patron.name}, there #{plural_verb} #{number_available_copies} #{plural} of #{the_book.title} available for checkout\n"
	end
end

def checkout_history
	puts "\nCHECKOUT HISTORY FOR #{@current_patron.name}\n\n"
	checked_out_array = Checkout.get_by_patron_id(@current_patron.id)
	checked_out_array.each_with_index do |checkout, index|
		the_book = Book.get_from_checkout(checkout.id).first
		if checkout.checkin_date == "00/00/0000" || checkout.checkin_date == "01/01/0001"
			checkout_string = "Checked out"
			due_date_string = "Due date: #{checkout.due_date}"
		else
			checkout_string = checkout.checkin_date + " "
			due_date_string = ""
		end
		puts "#{index+1}. #{the_book.title} (ISBN-10 #{the_book.isbn_10})"
		puts "   Checked in on: #{checkout_string}   Checked out on: #{checkout.checkout_date}   #{due_date_string}\n\n"
	end
	puts "\n"
end

def check_due_date_book
	puts "\nCHECK THE DUE DATE OF A BOOK"
	the_book_array = get_book_array_by_title_or_isbn_10
	if !the_book_array.empty?
		the_book = the_book_array.first
		copy_checkout_hash_array = the_book.find_copy_checkout_from_patron_book(@current_patron.id)
		puts "!!! line 754"
		p copy_checkout_hash_array
		copy_checkout_hash_array.each do |copy_checkout|
			checkout_id = copy_checkout['checkout_id']
			the_checkout_array = Checkout.get_by_id(checkout_id)
			puts "@@@ line 759"
			p the_checkout_array
			if !the_checkout_array.empty?
				the_checkout = the_checkout_array.first
				if the_checkout.checkin_date == "00/00/0000" || the_checkout.checkin_date == "01/01/0001"
					puts "\n#{@current_patron.name}, #{the_book.title} is due on #{the_checkout.due_date}"
				else
					puts "\n#{@current_patron.name}, you do not have #{the_book.title} currently checked out"
				end
			else
				puts "\n#{@current_patron.name}, you do not have #{the_book.title} currently checked out"
			end
		end
	end
end

def exit_program
	puts "\nThanks for visiting Cindy's Library! Come back again soon!\n\n"
	exit
end

choose_user
