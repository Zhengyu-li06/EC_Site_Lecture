using System;

namespace EC_Site_Lecture.ScreenDTO
{
    public class ShippingStatusDTO
    {
        public int ShippingStatusId { get; set; }       // 発送ステータスID（PK）
        public int OrderId { get; set; }                // 注文ID（FK）
        public string Status { get; set; }              // 状態（例：準備中・発送済み・配達完了など）
        public string TrackingNumber { get; set; }      // 追跡番号
        public DateTime? ShippedDate { get; set; }      // 発送日
        public DateTime? DeliveredDate { get; set; }    // 配達完了日
        public string Note { get; set; }                // 備考
        public DateTime CreatedAt { get; set; }         // 登録日
        public DateTime UpdatedAt { get; set; }         // 更新日
    }
}
