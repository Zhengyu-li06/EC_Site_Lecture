using System;

namespace EC_Site_Lecture.Models
{
    public class OrderDTO
    {
        public int OrderId { get; set; }
        public decimal TotalAmount { get; set; }
        public string CustomerName { get; set; }
        public string CustomerAddress { get; set; }
        public string CustomerPhone { get; set; }
        public string CustomerEmail { get; set; }
        public DateTime OrderDate { get; set; }
        public string Status { get; set; }
    }
}