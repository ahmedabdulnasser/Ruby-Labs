require 'json'


def load_json_data(filename = './books.json')
    return [] unless File.exist?(filename)
    file = File.read(filename)
    books_data = JSON.parse(file)
end 

def save_to_json(filename = './books.json')
  updated_books = Inventory.get_json_books 
  File.write(filename, JSON.pretty_generate(updated_books)) 
  puts "Inventory saved to #{filename}"

end



books_data = load_json_data()


class Book 
  attr_accessor :title, :author, :isbn, :count
  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
    @count = 0
  end
end 


class Inventory
  @@books_list = []
  @@books_count = 0

  def self.list_books()
    @@books_list.sort_by(&:isbn).each do |book|
        puts book.author, book.title, book.isbn, book.count
    end
  end 

    def self.add_book(book)
      if (book.title.nil? || book.author.nil? || book.isbn.nil? || book.title.empty? || book.author.empty? || book.isbn.empty?) 
        puts 'Missing arguments when adding book'
        false
      else 
        existing_index = @@books_list.find_index { |existing_book| existing_book.isbn == book.isbn }
      if existing_index
        curr_count =  @@books_list[existing_index].count
         @@books_list[existing_index] = book
         @@books_list[existing_index].count = curr_count + 1 
      else 
        book.count = 1
        @@books_list.push book
        @@books_count += 1
      end 
        save_to_json()
        @@books_list.sort_by!(&:isbn)
    end
  end


    def self.books_count 
      @@books_count
    end 

    def self.search_book(isbn)
      idx = @@books_list.find_index { |book| book.isbn == isbn }
      if idx 
        idx
      else 
        puts 'not found'
        nil
      end
    end


    def self.remove_book(isbn)
      idx = @@books_list.find_index { |book| book.isbn == isbn }
      if (idx)
        book_to_remove = @@books_list[idx]

        if book_to_remove.count > 1
          book_to_remove.count -= 1
        else 
          @@books_list.delete_at idx
          @@books_count -=1
        end

        save_to_json()
        true 
      else 
        false
      end
    end

    def self.get_json_books 
      @@books_list.map do |book|
          {
            'title'=> book.title,
            'author' => book.author,
            'isbn' => book.isbn,
            'count' => book.count
          }
        end
    end


end


books_data.each do |book_data| 
  Inventory.add_book Book.new(book_data['title'], book_data['author'], book_data['isbn'])
end


def console_menu
  loop do
    puts "\n=== Book Inventory System ==="
    puts "1. Add Book"
    puts "2. List All Books"
    puts "3. Search Book by ISBN"
    puts "4. Remove Book by ISBN"
    puts "5. Show Books Count"
    puts "6. Exit"
    print "Choose an option (1-6): "

    choice = gets.chomp.to_i

    case choice

    when 1
      print 'Book Title: '
      title = gets.chomp

      print 'Book Author: '
      author = gets.chomp

      print 'Book ISBN: '
      isbn = gets.chomp

      if Inventory.add_book(Book.new(title, author, isbn))
        puts "Book added successfully"
      end

    when 2 
      if Inventory.books_count > 0
        Inventory.list_books
      else 
        puts "No books in inventory"
      end

    when 3
      print "ISBN to search: "
      isbn = gets.chomp 
      result = Inventory.search_book(isbn)
      if result 
        puts "Book found at #{result}"
      end
    when 4
      print "Enter ISBN to remove: "
      isbn = gets.chomp
      if Inventory.remove_book(isbn)
        puts "Book removed successfully"
      else
        puts "Book was not found"
      end
      
    when 5
      puts "Total books in inventory: #{Inventory.books_count}"
      
    when 6
      puts "Goodbye!"
      break

    else 
      puts 'invalid option'
    end
end
end

console_menu