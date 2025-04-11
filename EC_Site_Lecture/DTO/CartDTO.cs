using System.ComponentModel.DataAnnotations;

namespace YourNamespace.DTO
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


