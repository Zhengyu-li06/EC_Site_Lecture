using System.ComponentModel.DataAnnotations;

namespace EC_Site_Lecture.DTO
{
    public class CartDto
    {
        public int ProductId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public double Price { get; set; }
        public int Quantity { get; set; }
    }
}


