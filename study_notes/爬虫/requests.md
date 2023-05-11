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

* 带参数的请求

```
kw = {’wd’: ’python’}
response = requests.get(url, headers=headers, params=kw)
```

等价于访问 ’https://www.baidu.com/s?wd=python’












