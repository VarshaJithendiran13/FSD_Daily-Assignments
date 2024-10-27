using BookAuthorSerialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BookAuthorSerialization
{
    public class Program
    {
        public static void Main()
        {
            // Sample customer
            Customer customer = new Customer
            {
                Name = "Varsha JK",
                Email = "varshajithendiran@gmail.com",
                PhoneNumber = "1234567890",
                DateOfBirth = new DateTime(2003, 5, 13)
            };

            // Validate customer information
            bool isPhoneNumberValid = CustomerValidator.ValidatePhoneNumber(customer.PhoneNumber);
            bool isEmailValid = CustomerValidator.ValidateEmail(customer.Email);
            bool isDOBValid = CustomerValidator.ValidateDateOfBirth(customer.DateOfBirth);

            Console.WriteLine($"Phone Number Valid: {isPhoneNumberValid}");
            Console.WriteLine($"Email Valid: {isEmailValid}");
            Console.WriteLine($"Date of Birth Valid: {isDOBValid}");
        }
    }
}

    