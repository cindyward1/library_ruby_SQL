
#library_ruby_SQL
====================

##README for the Library application written in Ruby using PostgreSQL

* Author: Cindy Ward <cindyward@yahoo.com>
* Date created: August 16, 2014
* Last modification date: August 21, 2014
* Created for:  Epicodus, Summer 2014 session

##Included; written by author:
* ./README.md (this file)
* ./LICENSE.md (using the "Unlicense" template)
* ./library.rb (main application file)
* ./lib/author.rb (class Author implementation)
* ./lib/book.rb (class Book implementation)
* ./lib/checkout.rb (class Checkout implementation)
* ./lib/copy.rb (class Copy implementation)
* ./lib/patron.rb (class Patron implementation)
* ./lib/written_by.rb (class Patron implementation)
* ./spec/author_spec.rb (test cases for class Author)
* ./spec/book_spec.rb (test cases for class Book)
* ./spec/checkout_spec.rb (test cases for class Checkout)
* ./spec/copy_spec.rb (test cases for class Copy)
* ./spec/patron_spec.rb (test cases for class Patron)
* ./spec/written_by_spec.rb (test cases for class Written_by)

##Requirements for execution:
* [The Ruby language interpreter](https://www.ruby-lang.org/en/downloads/) must be installed. Please use version 2.1.2. 
* [git clone](http://github.com/) the image available at http://github.com/cindyward1/library_ruby_SQL, which will create a library_ruby_SQL directory with lib and spec subdirectories.
* [Homebrew](http://brew.sh/) Homebrew is a package installer for Apple computers. To install homebrew, enter the following at a terminal application prompt $: ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
* [PostgreSQL](http://http://www.postgresql.org/) To install PostgreSQL on an Apple computer, enter the following at a terminal application prompt: brew install postgres . To configure PostgreSQL, enter the following commands at a terminal application prompt $: 
> $: echo "export PGDATA=/usr/local/var/postgres" >> ~/.bash_profile
> $: echo "export PGHOST=/tmp" >> ~/.bash_profile
> $: source ~/.bash_profile
* To start the PostgreSQL server, enter the following at a terminal application prompt $: postgres . It is necessary to leave the window open for the server to continue to run. To create a database with the user's login name, enter the following at a teriminal application prompt: createdb $USER .
* To create the database required for this application, enter the following at a terminal application prompt to run the PostgreSQL application $: psql . To create the database, enter the following at a psql prompt #. (Please note that semicolons ARE required where indicated below)
  * # CREATE DATABASE cindys_library
  * # \c cindys_library
  * # CREATE TABLE book (id serial PRIMARY KEY, title varchar, isbn_10 varchar);
  * # CREATE TABLE author (id serial PRIMARY KEY, name varchar);
  * # CREATE TABLE patron (id serial PRIMARY KEY, name varchar, phone_number varchar);
  * # CREATE TABLE copy (id serial PRIMARY KEY, book_id int, checkout_id int);
  * # CREATE TABLE written_by (id serial PRIMARY KEY, author_id int, book_id int);
  * # CREATE TABLE checkout (id serial PRIMARY KEY, patron_id int, copy_id int, checkout_date timestamp, checkin_date timestamp, due_date timestamp);
* To run the application, cd to (clone location)/library_ruby_SQL and enter the following at a terminal application prompt $: ruby library.rb
* You can also test a non-interactive version of the method against its test cases found in (your working directory)/library_ruby_SQL/spec/*.rb using [rspec](https://rubygems.org/gems/rspec). Please use version 3.1.1. To run rspec, cd to (clone location)/library_ruby_SQL and enter the following string at a terminal application $: "rspec" (This command will automatically execute any .rb file it finds in ./spec/.)
* Please note that this repository has only been tested with [Google Chrome browser](http://www.google.com/intl/en/chrome/browser) version 36.0.1985.125 on an iMac running [Apple](http://www.apple.com) OS X version 10.9.4 (Mavericks). Execution on any other computing platform, browser or operating system is at the user's risk.

##Description:
This Ruby application implements a character user interface to a library application. The user interface is divided into two parts: the actions a librarian performs to maintain the library, and the actions a patron performs to check books out and back in and to keep track of those transactions.
###The librarian is able to: 
1. Create, read, update, delete, and list all books in the catalog to keep track of inventory.
2. Search for a book by author or title to find a particular book.
3. Enter multiple authors for a book so book catalog information is accurate.
4. See a list of overdue books including the name and phone number of each patron who has an overdue book checked out.
5. Check in a book (this was not specified in the original assignment)
###The patron is able to:
1. Check out a book
2. Determine how many copies of a book are available to be checked out.
3. See a history of all books that he/she has checked out in the past.
4. Determine when a checked-out book is due.

##Thanks:
My thanks to Chris of [chris.com](http://chris.com) for the ASCII art I used in my application.
