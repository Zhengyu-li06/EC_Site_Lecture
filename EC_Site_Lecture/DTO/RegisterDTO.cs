using System;
using System.ComponentModel.DataAnnotations;



namespace EC_Site_Lecture.Models
{
    public class RegisterDTO
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }

        public DateTime DateCreated { get; set; }

        public string CouponLabel { get; set; }     // 例: "40% OFF"、"20% OFF"、"対象外"
        public string CouponColor { get; set; }     // 例: "red"、"green"、"gray"

        public string CouponStatus { get; set; }
    }
}

