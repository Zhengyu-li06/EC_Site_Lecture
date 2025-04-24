using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace EC_Site_Lecture.Models
{
    public class SalesSummaryItem
    {
        public string ProductName { get; set; }
        public int TotalQuantity { get; set; }
        public decimal TotalSales { get; set; }
    }

    public class SalesSummaryModel : CommonModel 
    {
        public List<SalesSummaryItem> GetSalesSummary()
        {
            var result = new List<SalesSummaryItem>();

            using (var conn = new SqlConnection(_connectionString)) 
            {
                conn.Open();
                string sql = @"
                    SELECT ProductName,
                           SUM(Quantity) AS TotalQuantity,
                           SUM(ProductPrice * Quantity) AS TotalSales
                    FROM OrderItems
                    GROUP BY ProductName
                    ORDER BY TotalSales DESC
                ";

                using (var cmd = new SqlCommand(sql, conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new SalesSummaryItem
                        {
                            ProductName = reader["ProductName"].ToString(),
                            TotalQuantity = (int)reader["TotalQuantity"],
                            TotalSales = (decimal)reader["TotalSales"]
                        });
                    }
                }
            }

            return result;
        }

        public string ToJson()
        {
            var data = GetSalesSummary();
            return new JavaScriptSerializer().Serialize(data);
        }
    }
}
