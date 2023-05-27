### 创建一个Scrapy项目

scrapy startproject xxx：新建一个新的爬虫项目

```
mySpider/
    scrapy.cfg              # 项目的配置文件
    mySpider/
        __init__.py
        items.py            # 项目的目标文件
        pipelines.py        # 项目的管道文件
        settings.py         # 项目的设置文件
        spiders/            # 存储爬虫代码目录
            __init__.py
            ...
```

### 定义提取的结构化数据(Item)

Item 定义结构化数据字段，用来保存爬取到的数据，有点像 Python 中的 dict，但是提供了一些额外的保护减少错误。

可以通过创建一个 scrapy.Item 类， 并且定义类型为 scrapy.Field 的类属性来定义一个 Item（可以理解成类似于 ORM 的映射关系）。

```
class ItcastItem(scrapy.Item):
   name = scrapy.Field()
   age = scrapy.Field()
   info = scrapy.Field()
 ```

### 编写爬取网站的 Spider 并提取出结构化数据(Item)

scrapy genspider itcast "itcast.cn"

```
mySpider/spider目录里的 itcast.py，默认增加了下列代码:

import scrapy

class ItcastSpider(scrapy.Spider):
    name = "itcast"                     # 爬虫的识别名称
    allowed_domains = ["itcast.cn"]     # 爬虫的约束区域
    start_urls = (
        'http://www.itcast.cn/',        # 爬取的URL元祖/列表
    )

    def parse(self, response):          # 处理response的方法
        pass
```

### 编写 Item Pipelines 来存储提取到的Item(即结构化数据)



### 保存数据

scrapy保存信息的最简单的方法主要有四种，-o 输出指定格式的文件，命令如下：

scrapy crawl itcast -o teachers.json

json lines格式，默认为Unicode编码

scrapy crawl itcast -o teachers.jsonl

csv 逗号表达式，可用Excel打开

scrapy crawl itcast -o teachers.csv

xml格式

scrapy crawl itcast -o teachers.xml


### 执行爬虫

scrapy crawl [name]

如果打印的日志出现 [scrapy] INFO: Spider closed (finished)，代表执行完成。


### 其它

```
import sys
reload(sys)
sys.setdefaultencoding("utf-8")
```
