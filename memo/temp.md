
```

数据文件，第一列索引改掉，不要随机

pandas.DataFrame.tail(n)来获取DataFrame的最后n行

pandas.DataFrame.head(n)来获取DataFrame的最前n行

for i in df.itertuples():
    print(i)
    print(tuple(i))

import csv

with open("test.csv","w",newline='') as csvfile:
    writer = csv.writer(csvfile)
    write.writerow([0,1,2])

```
   
