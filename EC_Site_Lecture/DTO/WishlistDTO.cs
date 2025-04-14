using System.ComponentModel.DataAnnotations;

namespace EC_Site_Lecture.DTO
{
    public class WishlistDTO
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public double Price { get; set; }
        public string ImageUrl { get; set; }
    }


}


