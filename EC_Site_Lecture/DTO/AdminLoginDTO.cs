using System.ComponentModel.DataAnnotations;

namespace EC_Site_Lecture.ScreenDTO
{
    public class AdminLoginDTO
    {
        [Required(ErrorMessage = "ユーザー名またはメールは必須です")]
        public string UsernameOrEmail { get; set; }

        [Required(ErrorMessage = "パスワードは必須です")]
        public string Password { get; set; }

        public bool RememberMe { get; set; }
    }
}


