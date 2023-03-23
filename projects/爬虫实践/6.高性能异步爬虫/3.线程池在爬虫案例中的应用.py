import requests
from lxml import etree
import re
from multiprocessing.dummy import Pool
#需求：爬取梨视频的视频数据
headers = {
    'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'
}
#原则：线程池处理的是阻塞且较为耗时的操作

#对下述url发起请求解析出视频详情页的url和视频的名称
url = 'https://www.pearvideo.com/category_5'
page_text = requests.get(url=url,headers=headers).text

tree = etree.HTML(page_text)
li_list = tree.xpath('//ul[@id="listvideoListUl"]/li')
urls = [] #存储所有视频的链接and名字
for li in li_list:
    detail_url = 'https://www.pearvideo.com/'+li.xpath('./div/a/@href')[0]
    name = li.xpath('./div/a/div[2]/text()')[0]+'.mp4'
    #对详情页的url发起请求
    detail_page_text = requests.get(url=detail_url,headers=headers).text
    #从详情页中解析出视频的地址（url）
    ex = 'srcUrl="(.*?)",vdoUrl'
    video_url = re.findall(ex,detail_page_text)[0]
    dic = {
        'name':name,
        'url':video_url
    }
    urls.append(dic)
#对视频链接发起请求获取视频的二进制数据，然后将视频数据进行返回
def get_video_data(dic):
    url = dic['url']
    print(dic['name'],'正在下载......')
    data = requests.get(url=url,headers=headers).content
    #持久化存储操作
    with open(dic['name'],'wb') as fp:
        fp.write(data)
        print(dic['name'],'下载成功！')
#使用线程池对视频数据进行请求（较为耗时的阻塞操作）
pool = Pool(4)
pool.map(get_video_data,urls)

pool.close()
pool.join()


