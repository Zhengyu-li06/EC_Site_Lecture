using System.ComponentModel.DataAnnotations;


namespace EC_Site_Lecture.ScreenDTO
{
    public class ProductDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public double Price { get; set; }
        public double Quantity { get; set; }
        public bool IsInWishlist { get; set; }
        public int CartQuantity { get; set; } 
    }
}