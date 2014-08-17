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
	puts "  Welcome     ||-------------------------------------------------------||"
	puts "    to        ||.--.    .-._                        .----.             ||"
	puts "  Cindy's     |||==|____| |H|___            .---.___|''''|_____.--.___ ||"
	puts "  Library     |||  |====| | |xxx|_          |+++|=-=|_  _|-=+=-|==|---|||"
	puts "              |||==|    | | |   | \\         |   |   |_\\/_|Black|  | ^ |||"
	puts "              |||  |    | | |   |\\ \\   .--. |   |=-=|_/\\_|-=+=-|  | ^ |||"
	puts "              |||  |    | | |   |_\\ \\_( oo )|   |   |    |Magus|  | ^ |||"
	puts "              |||==|====| |H|xxx|  \\ \\ |''| |+++|=-=|''''|-=+=-|==|---|||"
	puts "              ||`--^----'-^-^---'   `-' ''  '---^---^----^-----^--^---^||"
	puts "              ||-------------------------------------------------------||"
	puts "              ||-------------------------------------------------------||"
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
		puts "\nPlease enter 'L' if you are a librarian or 'P' if you are a patron."
		puts "You may enter 'X' to exit the program or 'M' to return to this menu."
		user_type = gets.chomp.upcase
		if user_type == "L"
			librarian_menu
		elsif user_type == "P"
			patron_menu
		elsif user_type == "X"
			exit_program
		elsif user_type != "M"
			puts "\nInvalid option entered, please try again."
		end
	end
end

def librarian_menu
	option = nil
	while option != "m" && option != "x"
		puts "\nLIBRARIAN MENU\n"
		puts "Menu options:"
		puts "  m = return to main menu"
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
			puts "Invalid option entered, please try again."
		end
	end
end

def books_menu
	option = nil
	while option != "m" && option != "x" && option != "b"
		puts "\nBOOKS MENU for LIBRARIAN"
		puts "Menu options:"
		puts "  b = go back to librarian menu"
		puts "  m = return to main menu"
		puts "  x = exit the program"
		puts "  a = add a book to the catalog"
		puts "  f = find a book by title"
		puts "  i = find a book by ISBN-10 number"
		puts "  l = list all books in the catalog"
		puts "  c = update the number of copies of a book"
		puts "  u = update book information"
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
			update_number_copies
		elsif option == "u"
			update_book_information
		elsif option == "d"
			delete_book
		elsif option == "x"
			exit_program
		elsif option != "m"
			puts "\nInvalid option, please try again."
		end
	end
end

def add_book_to_catalog
	puts "\nEnter the title of the new book"
	new_title = gets.chomp
	puts "Enter the ISBN-10 number of the new book"
	if Book.get_by_title(new_title).empty?
		new_isbn_10 = gets.chomp
		if new_isbn_10 !~ /\d\d\d\d\d\d\d\d\d\d/
			puts "\nInvalid format for ISBN-10, please try again."
		elsif Book.get_by_isbn_10(new_isbn_10).empty?
			new_book = Book.new({:title=>new_title, :isbn_10=>new_isbn_10})
			new_book.save
			puts "\nEnter the number of book authors"
			number_authors = gets.chomp.to_i
			for author_count in (1..number_authors)
				puts "\nEnter the name of author #{author_count}"
				new_author_name = gets.chomp
				if Author.get_by_name(new_author_name).empty?
					new_author = Author.new({:name=>new_author_name})
					new_author.save
					new_author_id = new_author.id
				else
					new_author_id = Author.get_by_name(new_author_name).first.id
				end
				new_written_by = Written_by.new({:author_id=>new_author_id, :book_id=>new_book.id})
				new_written_by.save
			end
			puts "\nEnter the number of copies of the new book"
			number_copies = gets.chomp.to_i
			for copy_count in (1..number_copies)
				new_copy = Copy.new({:book_id=>new_book.id})
				new_copy.save
			end
			puts "\n#{number_copies} copies of '#{new_title}' have been added to the catalog\n"
		else
			puts "\nISBN-10 #{new_isbn_10} is already in the database; please update the number of copies instead\n"
		end
	else
		puts "\n'#{new_title}' is already in the database; please update the number of copies instead\n"
	end
end

def find_book_by_title
	puts "\nEnter the title of the book you want to find"
	the_title = gets.chomp
	the_book_array = Book.get_by_title(the_title)
	if the_book_array.empty?
		puts "\n#{the_title} is not in the catalog\n"
	else
		the_book = the_book_array.first
		number_of_copies = the_book.count_copies
		puts "\nThere are #{number_of_copies} copies of '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) in the library"
		author_array = the_book.find_authors
		author_array.each_with_index do |author, index|
			puts "  Author #{index+1}. #{author}"
		end
		puts "\n"
	end
end

def find_book_by_ISBN
	puts "\nEnter the ISBN-10 of the book you want to find"
	the_isbn_10 = gets.chomp
	the_book_array = Book.get_by_isbn_10(the_isbn_10)
	if the_book_array.empty?
		puts "\nISBN-10 #{the_isbn_10} is not in the catalog\n"
	else
		the_book = the_book_array.first
		number_of_copies = the_book.count_copies
		puts "\nThere are #{number_of_copies} copies of '#{the_book.title}' (ISBN-10 #{the_book.isbn_10}) in the library"
		author_array = the_book.find_authors
		author_array.each_with_index do |author, index|
			puts "  Author #{index+1}. #{author}"
		end
		puts "\n"
	end
end

def list_all_books
end

def update_number_copies
end

def update_book_information
end

def delete_book
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
