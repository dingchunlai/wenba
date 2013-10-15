# encoding: utf-8
# 这名字起得天才啊
class IpAddresse < Hejia::Db::Hejia
  # 取得城市拼音信息
  # 根据现有的ＩＰ写出比较措的方法
  def pinyin 
    hash = { 0 => "shanghai", 1 => "shanghai", 2 => "suzhou", 3 => "nanjing", 4 => "ningbo", 5 => "hangzhou", 6 => "wuxi"}
    hash[is_shanghai]
  end
  
  # 取得城市 简称
  # 根据现有的ＩＰ写出比较措的方法
  def code
    hash = { 0 => "sh", 1 => "sh", 2 => "sh", 3 => "nj", 4 => "nb", 5 => "hz", 6 => "wx"}
    hash[is_shanghai]
  end

end
