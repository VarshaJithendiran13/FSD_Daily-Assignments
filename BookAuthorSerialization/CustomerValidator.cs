using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace BookAuthorSerialization
{
    public static class CustomerValidator
    {
        // Validate phone number (format: 10-digit number)
        public static bool ValidatePhoneNumber(string phoneNumber)
        {
            return Regex.IsMatch(phoneNumber, @"^\d{10}$");
        }

        // Validate email format
        public static bool ValidateEmail(string email)
        {
            return Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$");
        }

        // Validate DOB to check if the customer is at least 18 years old
        public static bool ValidateDateOfBirth(DateTime dateOfBirth)
        {
            int age = DateTime.Now.Year - dateOfBirth.Year;
            if (dateOfBirth > DateTime.Now.AddYears(-age)) age--;
            return age >= 18;
        }
    }

}
