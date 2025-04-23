using System.Configuration;

namespace EC_Site_Lecture.Models
{
    public class CommonModel
    {
        protected readonly string _connectionString;

        public CommonModel()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
        }

        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
        }
    }
}
