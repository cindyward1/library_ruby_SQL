require "pg"
require "./lib/book.rb"
require "./lib/copy.rb"
require "./lib/author.rb"
require "./lib/written_by.rb"
require "./lib/checkout.rb"
require "./lib/patron.rb"

DB = PG.connect(:dbname => "cindys_library")

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
	user_type = nil
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
			puts "\nInvalid option entered, try again"
		end
	end
end

def librarian_menu
	option = nil
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
			puts "Invalid option entered, try again"
		end
	end
end

def books_menu
	option = nil
	while option != "m" && option != "x" && option != "b"
		puts "\nBOOKS MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to librarian menu"
		puts "  x = exit the program"
		puts "  a = add a book to the catalog"
		puts "  f = find a book by title"
		puts "  i = find a book by ISBN-10 number"
		puts "  l = list all books in the catalog"
		puts "  c = update the number of copies of a book"
		puts "  u = update book information"
		puts "  d = delete a book from the catalog"
		puts "  o = find all overdue books"
		option = gets.chomp.downcase
		if option == "a"
			add_book_to_catalog
		elsif option == "f"
			find_book_by_title
		elsif option == "i"
			find_book_by_ISBN
		elsif option == "l"
			list_all_books
		elsif option == "c"
			update_number_copies (nil)
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

def add_book_to_catalog
	puts "\nEnter the title of the new book"
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
				puts "\n'#{new_book.title}' (ISBN-10 #{new_book.isbn_10}) is already in the database; update the number of copies instead\n"
				update_number_copies(new_book_array)
			end
		end
	else
		new_book = new_book_array.first
		puts "\n'#{new_book.title}' (ISBN-10 #{new_book.isbn_10}) is already in the database; update the number of copies instead\n"
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
	new_written_by = Written_by.new({:author_id=>new_author_id, :book_id=>new_book_id})
	new_written_by.save
	new_book = Book.get_by_id(new_book_id).first
	puts "\nAuthor #{new_author_name} has been added to the authorship of '#{new_book.title}'"
end

def find_book_by_title
	puts "\nEnter the title of the book you want to find"
	the_title = gets.chomp
	the_book_array = Book.get_by_title(the_title)
	if the_book_array.empty?
		puts "\n#{the_title} is not in the catalog\n"
	else
		display_author_names(the_book_array.first)
	end
end

def find_book_by_ISBN
	puts "\nEnter the ISBN-10 of the book you want to find"
	the_isbn_10 = gets.chomp
	the_book_array = Book.get_by_isbn_10(the_isbn_10)
	if the_book_array.empty?
		puts "\nISBN-10 #{the_isbn_10} is not in the catalog\n"
	else
		display_author_names(the_book_array.first)
	end
end

def display_author_names(the_book)
	number_of_copies = the_book.count_copies
	puts "\nThere are #{number_of_copies} copies of '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) in the library"
	author_array = the_book.find_authors
	author_array.each_with_index do |author, index|
		puts "  Author #{index+1}. #{author.name}"
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
	if the_book_array == nil
		puts "\nEnter the title or ISBN-10 number of the book of which to update the number of copies"
		update_element = gets.chomp
		if update_element =~ /\d\d\d\d\d\d\d\d\d\d/
			the_book_array = Book.get_by_isbn_10(update_element)
		else
			the_book_array = Book.get_by_title(update_element)
		end
	end
	if the_book_array.length > 0
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
		puts "Enter the requested change in the number of copies (enter a negative number to subtract copies)"
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
				for copy_count in (1..number_change.abs)
					the_copy_array = Copy.get_by_book_id(the_book.id)
					if the_copy_array.empty?
						plural = copies
						plural_verb = were
						if copy_count-1 == 1
							plural = "copy"
							plural_verb = "was"
						end
						puts "\nOnly book copies that aren't checked out can be deleted"
						puts "There #{plural_verb} only #{copy_count-1} #{plural} of '#{the_book.title} that #{plural_verb} not checked out"
					else
						the_copy = the_copy_array.first
						the_copy.delete
					end
				end
				plural = "copies"
				plural_verb = "were"
				if number_change.abs == 1
					plural = "copy"
					plural_verb = "was"
				end
				puts "\n#{number_change.abs} #{plural} of '#{the_book.title}' #{plural_verb} deleted"
			end
		else
			puts "\nNo copies of '#{the_book.title}' were deleted because the requested number of copies to delete was 0"
		end
		number_copies = the_book.count_copies
		plural = "copies"
		plural_verb = "are"
		if number_copies == 1
			plural = "copy"
			plural_verb = "is"
		end 
		puts "There #{plural_verb} now #{number_copies} #{plural} of '#{the_book.title}'"
	else
		puts "\n#{update_element} does not exist in the library catalog"
	end
end

def update_book_information
	puts "\nEnter the title or ISBN-10 number of the book of which to change information"
	update_element = gets.chomp
	if update_element =~ /\d\d\d\d\d\d\d\d\d\d/
		the_book_array = Book.get_by_isbn_10(update_element)
	else
		the_book_array = Book.get_by_title(update_element)
	end
	if the_book_array.length > 0
		the_book = the_book_array.first
		puts "\nUPDATE BOOK MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to the librarian's books menu"
		puts "  x = exit program"
		puts "  t = change title"
		puts "  i = change ISBN-10"
		puts "  a = change author information"
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
				puts "\nThe authors for '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) are"
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
	else
		puts "\nThere are no copies of #{update_element} to update"
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
		p author_array
		author = author_array[author_index-1]
		puts "**** update_author_menu"
		p author
		if option == "u" && author_index > 0
			puts "\nEnter the new name for the author"
			new_author_name = gets.chomp
			new_author_array = Author.get_by_name(new_author_name)
			if new_author_array.empty?
				new_autnor = Author.new(:author_name=>new_author_name)
				new_author.save
			else
				new_author = new_author_array.first
			end
			written_by_array = Written_by.get_by_author_id(new_author.id)
			if !written_by_array.empty?
				book_found = false
				written_by_array.each do |written_by|
					if written_by.book_id == the_book.id
						found = true
					end
				end
			end
			if !book_found || written_by_array.empty?
				new_written_by = Written_by.new(:book_id=>the_book.id, :author_id=>new_author.id)
				puts "\nThe new author name for '#{the_book.title}' is #{new_author.name}"
			end
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
		puts "\nInvalid option entered, try again"
	end
end

def delete_book
	puts "\nEnter the title or ISBN-10 number of the book of which to change information"
	update_element = gets.chomp
	if update_element =~ /\d\d\d\d\d\d\d\d\d\d/
		the_book_array = Book.get_by_isbn_10(update_element)
	else
		the_book_array = Book.get_by_title(update_element)
	end
	if the_book_array.length > 0
		the_book = the_book_array.first
		puts "\nThis operation cannot be undone!! Enter 'y' or 'yes' to delete"
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
	else
		puts "\n#{update_element} does not exist in the library catalog"
	end
end


def patron_maint_menu
end

def patron_menu
end

def exit_program
	puts "\nThanks for visiting Cindy's Library! Come back again soon!\n\n"
	exit
end

choose_user
