using System.Web;

namespace EC_Site_Lecture.ScreenDTO
{
    public class AdminProductDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public double Price { get; set; }
        public double Quantity { get; set; }

        public bool IsDiscontinued { get; set; }  // 販売中止
        public bool IsNewArrival { get; set; }    // 新入荷
        public byte[] ImageData { get; set; }
        public HttpPostedFileBase UploadedImage { get; set; }  

    }
}

