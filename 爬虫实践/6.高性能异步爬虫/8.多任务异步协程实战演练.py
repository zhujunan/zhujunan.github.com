import requests
from lxml import etree
import time
import os
start = time.time()
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36'
}
if not os.path.exists('./libs'):
    os.mkdir('./libs')
url = 'http://pic.netbian.com/4kmeinv/index_%d.html'
a = []
for page in range(2,50):
    new_url = format(url%page)
    page_text = requests.get(url=new_url,headers=headers).text
    tree = etree.HTML(page_text)
    li_list = tree.xpath('//div[@class="slist"]/ul/li')
    for li in li_list:
        img_src = 'http://pic.netbian.com' + li.xpath('./a/img/@src')[0]
        name = img_src.split('/')[-1]
        # data = requests.get(url=img_src).content
        # path = './libs/'+name
        # with open(path,'wb') as fp:
        #     fp.write(data)
        #     print(name,'下载成功')
        a.append(name)
print(len(a))
print('总耗时：',time.time()-start)
