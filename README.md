# Read_grd

无论是几维数据，grd数据读出来都是一列数据.
grd数据的存储方式为：
先由西向东，再由南向北依次存储！！
因此，与实际网格经纬度匹配应先转置后上下翻转！！