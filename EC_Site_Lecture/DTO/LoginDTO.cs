using System.ComponentModel.DataAnnotations;

namespace YourNamespace.ScreenDTO
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

