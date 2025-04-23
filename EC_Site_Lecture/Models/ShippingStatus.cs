using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using EC_Site_Lecture.ScreenDTO;

namespace EC_Site_Lecture.Models
{
    public class ShippingStatus
    {
        private static readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        public List<ShippingStatusDTO> GetAll()
        {
            var list = new List<ShippingStatusDTO>();

            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = @"SELECT * FROM ShippingStatuses ORDER BY UpdatedAt DESC";

                using (var cmd = new SqlCommand(sql, conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new ShippingStatusDTO
                        {
                            ShippingStatusId = (int)reader["ShippingStatusId"],
                            OrderId = (int)reader["OrderId"],
                            Status = reader["Status"]?.ToString() ?? "",
                            TrackingNumber = reader["TrackingNumber"] != DBNull.Value ? reader["TrackingNumber"].ToString() : "",
                            ShippedDate = reader["ShippedDate"] != DBNull.Value ? (DateTime?)reader["ShippedDate"] : null,
                            DeliveredDate = reader["DeliveredDate"] != DBNull.Value ? (DateTime?)reader["DeliveredDate"] : null,
                            Note = reader["Note"] != DBNull.Value ? reader["Note"].ToString() : "",
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        });
                    }
                }
            }

            return list;
            Console.WriteLine("Shipping count = " + list.Count);

        }

        public ShippingStatusDTO GetById(int id)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = @"SELECT * FROM ShippingStatuses WHERE ShippingStatusId = @Id";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new ShippingStatusDTO
                            {
                                ShippingStatusId = (int)reader["ShippingStatusId"],
                                OrderId = (int)reader["OrderId"],
                                Status = reader["Status"]?.ToString() ?? "",
                                TrackingNumber = reader["TrackingNumber"] != DBNull.Value ? reader["TrackingNumber"].ToString() : "",
                                ShippedDate = reader["ShippedDate"] != DBNull.Value ? (DateTime?)reader["ShippedDate"] : null,
                                DeliveredDate = reader["DeliveredDate"] != DBNull.Value ? (DateTime?)reader["DeliveredDate"] : null,
                                Note = reader["Note"] != DBNull.Value ? reader["Note"].ToString() : "",
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };
                        }
                    }
                }
            }

            return null;
        }

        public bool Update(ShippingStatusDTO dto)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = @"
                    UPDATE ShippingStatuses SET
                        Status = @Status,
                        TrackingNumber = @TrackingNumber,
                        ShippedDate = @ShippedDate,
                        DeliveredDate = @DeliveredDate,
                        Note = @Note,
                        UpdatedAt = GETDATE()
                    WHERE ShippingStatusId = @Id";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", dto.ShippingStatusId);
                    cmd.Parameters.AddWithValue("@Status", dto.Status ?? "");
                    cmd.Parameters.AddWithValue("@TrackingNumber", dto.TrackingNumber ?? "");
                    cmd.Parameters.AddWithValue("@ShippedDate", dto.ShippedDate.HasValue ? (object)dto.ShippedDate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@DeliveredDate", dto.DeliveredDate.HasValue ? (object)dto.DeliveredDate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@Note", dto.Note ?? "");

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
    }
}
