### requests基本请求

```
requests.get(url)         # GET请求
requests.post(url)        # POST请求
requests.put(url)         # PUT请求
requests.delete(url)      # DELETE请求
requests.head(url)        # HEAD请求
requests.options(url)     # OPTIONS请求
```

### 带附加信息的请求

* 带 headers 的请求

```
headers = {"user-agent": ’Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit
/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36’}
response = requests.get(url, headers=headers)
```

User-Agent是浏览器标识信息。伪装浏览器的方法是最简单的反反爬措施之一。

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

其它反爬措施：

验证码

JS渲染页面：模拟javascript或抓ajax本身

基于请求频率或总请求数量封ip

* 带参数的请求

```
kw = {’wd’: ’python’}
response = requests.get(url, headers=headers, params=kw)
```

等价于访问 ’https://www.baidu.com/s?wd=python’












