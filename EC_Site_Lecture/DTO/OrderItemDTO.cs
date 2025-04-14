using System;

namespace EC_Site_Lecture.Models
{
    public class OrderItemDTO
    {
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public double ProductPrice { get; set; }
        public int Quantity { get; set; }
    }
}