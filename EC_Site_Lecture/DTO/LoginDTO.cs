using System.ComponentModel.DataAnnotations;

namespace EC_Site_Lecture.ScreenDTO
{
    public class LoginDTO
    {
        [Required]
        public string UsernameOrEmail { get; set; }

        [Required]
        public string Password { get; set; }

        public bool RememberMe { get; set; }
    }
}

