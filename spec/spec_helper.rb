require "pg"
require "rspec"
require "book"
require "copy"
require "author"
require "written_by"
require "checkout"
require "patron"

DB = PG.connect(:dbname => "cindys_library")

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM book *;")
    DB.exec("ALTER SEQUENCE book_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM author *;")
    DB.exec("ALTER SEQUENCE author_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM patron *;")
    DB.exec("ALTER SEQUENCE patron_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM copy *;")
    DB.exec("ALTER SEQUENCE copy_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM written_by *;")
    DB.exec("ALTER SEQUENCE written_by_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM checkout *;")
    DB.exec("ALTER SEQUENCE checkout_id_seq RESTART WITH 1;")

  end
end
