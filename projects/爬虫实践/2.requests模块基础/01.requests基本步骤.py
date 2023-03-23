# 初步掌握爬取步骤

import requests

#指定url
url = "https://www.baidu.com/"

#发起请求,返回响应对象
reponse = requests.get(url = url)

#获取相应数据
page_text = reponse.txt

#持久化存储
with open("./baidu.html","w",encodeing="utf-8") as file1:
    file1.write(page_text)
