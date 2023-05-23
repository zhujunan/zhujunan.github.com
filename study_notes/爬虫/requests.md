### requests基本请求

```
requests.get(url)         # GET请求
requests.post(url)        # POST请求
requests.put(url)         # PUT请求
requests.delete(url)      # DELETE请求
requests.head(url)        # HEAD请求
requests.options(url)     # OPTIONS请求
```

### response属性

```
r.status_code             # HTTP请求的返回状态，200表示连接成功，404表示失败
r.text                    # HTTP响应内容的字符串形式，即，url对应的页面内容
r.encoding                # 从HTTP header中猜测的响应内容编码方式
r.apparent_encoding       # 从内容中分析出的响应内容编码方式（备选编码方式）
r.content                 # HTTP响应内容的二进制形式
```

### 带附加信息的请求

爬虫常用的请求头：

```
Content-Type
Host                        (主机和端口号)
Connection                  (链接类型)
Upgrade-Insecure-Requests   (升级为HTTPS请求)
User-Agent                  (浏览器名称)
Referer                     (页面跳转处)
Cookie                      (Cookie)
Authorization               (用于表示HTTP协议中需要认证资源的认证信息，如前边web课程中用于jwt认证)
```

* 带 headers 的请求

```
headers = {"user-agent": ’Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit
/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36’}
response = requests.get(url, headers=headers)
```

* 带参数的请求

```
kw = {’wd’: ’python’}
response = requests.get(url, headers=headers, params=kw)
等价于访问 ’https://www.baidu.com/s?wd=python’
```

* 带代理的请求

```
proxies = {
  "http": "http://10.10.1.10:3128",
  "https": "http://10.10.1.10:1080",
}

requests.get("http://example.org", proxies=proxies)
```

### cookies

* 获取cookies

response.cookies

* 发送cookies

```
cookies = {"cookie_name": "cookie_value", }
response = requests.get("https://www.baidu.com", cookies=cookies)
```

更专业的方式是先实例化一个RequestCookieJar的类，然后把值set进去，最后在get,post方法里面指定cookies参数

```
import requests
from requests.cookies import RequestsCookieJar
cookie_jar = RequestsCookieJar()
cookie_jar.set("BAIDUID", "4EDT7A5263775F7E0A4B&F330724:FG=1", domain="baidu.com")
response = requests.get("https://fanyi.baidu.com/", cookies=cookie_jar)
```

### 反爬措施：

* 验证码
* 验证请求头: User-Agent是浏览器标识信息。伪装浏览器的方法是最简单的反反爬措施之一。
* JS渲染页面：模拟javascript或抓ajax本身
* 基于请求频率或总请求数量封ip

### Session会话

session对象能够帮我们跨请求保持某些参数，也会在同一个session实例发出的所有请求之间保持cookies。为了保持会话的连续，我们最好的办法是先创建一个session对象，用其打开一个url, 而不是直接使用requests.get方法打开一个url。每当我们使用这个session对象重新打开一个url时，请求头都会带上首次产生的cookie，实现了会话的延续。

```
import requests


headers = {
    "content-type": "application/x-www-form-urlencoded;charset=UTF-8",
    "User-Agent" : "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6) ",
}

#设置一个会话session对象s
s = requests.session()
resp = s.get('https://www.baidu.com/s?wd=python', headers=headers)
# 打印请求头和cookies
print(resp.request.headers)
print(resp.cookies)

# 利用s再访问一次
resp = s.get('https://www.baidu.com/s?wd=python', headers=headers)

# 请求头已保持首次请求后产生的cookie
print(resp.request.headers)
print(resp.cookies)
```

### 通用爬虫框架

```
import requests

url = "http://www.baidu.com"

try:
  r = requests.get(url)
  r.raise_for_status()
  r.enconding = r.apparent_encoding
  
  print(r.text)

except Exception as e:
  print("爬取失败")
  print(e)
```

