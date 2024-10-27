//using System.Text.Json;
//using System.Xml.Serialization;
//using System;
//using System.Collections.Generic;
//using System.IO;


//namespace BookAuthorSerialization
//{

//    public class Book
//    {
//        public int BookID { get; set; }
//        public string Title { get; set; }
//        public string Genre { get; set; }
//        public decimal Price { get; set; }
//    }

//    public class Author
//    {
//        public int AuthorID { get; set; }
//        public string Name { get; set; }
//        public string Country { get; set; }
//    }

//    public class BookAuthor
//    {
//        public static void Main()
//        {
//            // Step 1 & 2: Create lists with hardcoded data for Books and Authors
//            List<Book> books = new List<Book>
//        {
//            new Book { BookID = 1, Title = "The Power of Your Subconscious Mind", Genre = "Self-Help", Price = 9.99m },
//            new Book { BookID = 2, Title = "Think Like a Monk", Genre = "Self-Help", Price = 15.99m },
//            new Book { BookID = 3, Title = "Atomic Habits", Genre = "Personal Development", Price = 11.99m },
//            new Book { BookID = 4, Title = "Deep Work", Genre = "Productivity", Price = 13.99m },
//            new Book { BookID = 5, Title = "Man’s Search for Meaning", Genre = "Psychology", Price = 8.99m }
//        };

//            List<Author> authors = new List<Author>
//        {
//            new Author { AuthorID = 1, Name = "Joseph Murphy", Country = "USA" },
//            new Author { AuthorID = 2, Name = "Jay Shetty", Country = "UK" },
//            new Author { AuthorID = 3, Name = "James Clear", Country = "USA" },
//            new Author { AuthorID = 4, Name = "Cal Newport", Country = "USA" },
//            new Author { AuthorID = 5, Name = "Viktor E. Frankl", Country = "Austria" }
//        };

//            // Step 3 & 4: Serialize to JSON and XML and write to files
//            string booksJson = JsonSerializer.Serialize(books);
//            File.WriteAllText("Books.json", booksJson);

//            string authorsJson = JsonSerializer.Serialize(authors);
//            File.WriteAllText("Authors.json", authorsJson);

//            XmlSerializer bookXmlSerializer = new XmlSerializer(typeof(List<Book>));
//            using (TextWriter writer = new StreamWriter("Books.xml"))
//            {
//                bookXmlSerializer.Serialize(writer, books);
//            }

//            XmlSerializer authorXmlSerializer = new XmlSerializer(typeof(List<Author>));
//            using (TextWriter writer = new StreamWriter("Authors.xml"))
//            {
//                authorXmlSerializer.Serialize(writer, authors);
//            }

//            // Step 5: Read JSON and XML files and display data
//            string readBooksJson = File.ReadAllText("Books.json");
//            List<Book> booksFromJson = JsonSerializer.Deserialize<List<Book>>(readBooksJson);

//            string readAuthorsJson = File.ReadAllText("Authors.json");
//            List<Author> authorsFromJson = JsonSerializer.Deserialize<List<Author>>(readAuthorsJson);

//            Console.WriteLine("Books from JSON:");
//            foreach (var book in booksFromJson)
//            {
//                Console.WriteLine($"{book.Title} - {book.Genre} - ${book.Price}");
//            }

//            Console.WriteLine("\nAuthors from JSON:");
//            foreach (var author in authorsFromJson)
//            {
//                Console.WriteLine($"{author.Name} - {author.Country}");
//            }

//            using (FileStream fs = new FileStream("Books.xml", FileMode.Open))
//            {
//                List<Book> booksFromXml = (List<Book>)bookXmlSerializer.Deserialize(fs);
//                Console.WriteLine("\nBooks from XML:");
//                foreach (var book in booksFromXml)
//                {
//                    Console.WriteLine($"{book.Title} - {book.Genre} - ${book.Price}");
//                }
//            }

//            using (FileStream fs = new FileStream("Authors.xml", FileMode.Open))
//            {
//                List<Author> authorsFromXml = (List<Author>)authorXmlSerializer.Deserialize(fs);
//                Console.WriteLine("\nAuthors from XML:");
//                foreach (var author in authorsFromXml)
//                {
//                    Console.WriteLine($"{author.Name} - {author.Country}");
//                }
//            }
//        }
//    }

//}

