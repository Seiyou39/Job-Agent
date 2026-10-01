class Analysis < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list, optional: true

  serialize :strengths, coder: JSON, type: Array
  serialize :skill_gaps, coder: JSON, type: Array
  serialize :interview_questions, coder: JSON, type: Array


  LOCATION_JA = {
    "Chiyoda" => "千代田区", "Chuo" => "中央区", "Minato" => "港区",
    "Shinjuku" => "新宿区", "Bunkyo" => "文京区", "Taito" => "台東区",
    "Sumida" => "墨田区", "Koto" => "江東区", "Shinagawa" => "品川区",
    "Meguro" => "目黒区", "Ota" => "大田区", "Setagaya" => "世田谷区",
    "Shibuya" => "渋谷区", "Nakano" => "中野区", "Suginami" => "杉並区",
    "Toshima" => "豊島区", "Kita" => "北区", "Arakawa" => "荒川区",
    "Itabashi" => "板橋区", "Nerima" => "練馬区", "Adachi" => "足立区",
    "Katsushika" => "葛飾区", "Edogawa" => "江戸川区", "Akishima" => "昭島市",
    "Chofu" => "調布市", "Fuchu" => "府中市", "Hachioji" => "八王子市",
    "Higashimurayama" => "東村山市", "Hino" => "日野市", "Inagi" => "稲城市",
    "Kodaira" => "小平市", "Koganei" => "小金井市", "Kokubunji" => "国分寺市",
    "Kunitachi" => "国立市", "Machida" => "町田市", "Mitaka" => "三鷹市",
    "Musashino" => "武蔵野市", "Nishitokyo" => "西東京市", "Ome" => "青梅市",
    "Tachikawa" => "立川市", "Tama" => "多摩市"
  }.freeze

  def location_ja
    LOCATION_JA[location]
  end

  def location_valid?
    location.present? && LOCATION_JA.key?(location)
  end

end
