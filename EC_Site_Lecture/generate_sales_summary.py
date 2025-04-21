import openpyxl
from openpyxl import Workbook
from openpyxl.chart import BarChart, Reference
from openpyxl.chart.shapes import GraphicalProperties
import sys
import json
import pandas as pd

def create_bar_chart_only(json_path, output_path):
    # JSONファイルからデータを読み込む
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    df = pd.DataFrame(data)
    df.columns = ['商品名', '販売数（合計）', '売上金額（合計）']

    wb = Workbook()

    # チャート用のワークシートを作成
    ws = wb.active
    ws.title = "チャート"

    # データの見出しと内容をワークシートに書き込む
    ws.append(["商品名", "販売数（合計）"])
    for i in range(len(df)):
        ws.append([df.iloc[i]['商品名'], df.iloc[i]['販売数（合計）']])

    # 棒グラフを作成
    bar_chart = BarChart()
    bar_chart.y_axis.title = "販売数"
    bar_chart.x_axis.title = "商品名"
    bar_chart.width = 18  # グラフの幅を調整（左右に余白を確保）
    bar_chart.height = 10

    # グラフの横線（Y軸の主目盛線）を淡いグレーに設定
    bar_chart.y_axis.majorGridlines.spPr = GraphicalProperties(solidFill="D9D9D9")

    # データの範囲をグラフに設定
    max_row = ws.max_row
    data_ref = Reference(ws, min_col=2, min_row=1, max_row=max_row)
    cat_ref = Reference(ws, min_col=1, min_row=2, max_row=max_row)
    bar_chart.add_data(data_ref, titles_from_data=True)
    bar_chart.set_categories(cat_ref)

    # グラフをシートの右寄りに挿入
    ws.add_chart(bar_chart, "D15")

    # グラフ上部にタイトル（テキスト）を追加
    ws["D13"] = "【商品別販売数 棒グラフ】"

    # Excelファイルとして保存
    wb.save(output_path)
    print("Excelファイルの出力が完了しました（棒グラフ＋やわらかい横線）。")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("引数エラー：jsonファイルパスと出力先ファイルパスを指定してください。")
    else:
        create_bar_chart_only(sys.argv[1], sys.argv[2])
