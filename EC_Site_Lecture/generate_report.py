import pandas as pd
import sys
import json

def create_excel(json_file, output_file):
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not data:
        print("⚠️ データが空です")
        return

    df = pd.DataFrame(data)
    df.columns = ['注文ID', '合計金額', '氏名', '住所', '電話番号', 'メール', '注文日', 'ステータス']

    df.to_excel(output_file, index=False)
    print(f"✅ Excel 出力完了: {output_file}")

if __name__ == "__main__":
    print("📥 Python script started")
    if len(sys.argv) != 3:
        print("❌ 引数エラー: JSONファイルパスと出力パスが必要です")
    else:
        json_path = sys.argv[1]
        output_path = sys.argv[2]
        create_excel(json_path, output_path)
