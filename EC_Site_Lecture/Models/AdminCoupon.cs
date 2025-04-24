using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;


namespace EC_Site_Lecture.Models
{
    public class AdminCoupon : CommonModel
    {
        public List<RegisterDTO> GetEligibleUsers()
        {
            var users = new List<RegisterDTO>();

            using (var conn = new SqlConnection(CommonModel.GetConnectionString()))
            {
                conn.Open();

                string sql = "SELECT UserId, Username, Email, DateCreated FROM Users ORDER BY DateCreated DESC";

                using (var cmd = new SqlCommand(sql, conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var user = new RegisterDTO
                        {
                            UserId = (int)reader["UserId"],
                            Username = reader["Username"].ToString(),
                            Email = reader["Email"].ToString(),
                            DateCreated = (DateTime)reader["DateCreated"]
                        };

                        int days = (DateTime.Now - user.DateCreated).Days;

                        if (days <= 7)
                        {
                            user.CouponLabel = "🎉 40% OFF";
                            user.CouponColor = "red";
                            user.CouponStatus = "40%OFF";
                        }
                        else if (days <= 30)
                        {
                            user.CouponLabel = "🔔 20% OFF";
                            user.CouponColor = "orange";
                            user.CouponStatus = "20%OFF";
                        }
                        else
                        {
                            user.CouponLabel = "対象外";
                            user.CouponColor = "gray";
                            user.CouponStatus = "対象外";
                        }

                        users.Add(user);
                    }
                }

                foreach (var user in users)
                {
                    string updateSql = "UPDATE Users SET CouponStatus = @CouponStatus WHERE UserId = @UserId";
                    using (var updateCmd = new SqlCommand(updateSql, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@CouponStatus", user.CouponStatus);
                        updateCmd.Parameters.AddWithValue("@UserId", user.UserId);
                        updateCmd.ExecuteNonQuery();
                    }
                }
            }

            return users;
        }
    }
}


