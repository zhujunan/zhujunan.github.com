https://cloud.tencent.com/developer/article/1391308

https://blog.csdn.net/IT_LanTian/article/details/122986725

### 初始化

```
from selenium import webdriver
driver = webdriver.Chrome()     # 声明浏览器对象
```

### 保存页面源代码

```
file=open(path,'w',encoding='utf-8')
file.write(repr(driver.page_source))#repr() 函数将对象转化为供解释器读取的形式
file.close()
```

### 搜索元素

查找单个元素:

```
find_element_by_id
find_element_by_name
find_element_by_xpath
find_element_by_link_text
find_element_by_partial_link_text
find_element_by_tag_name
find_element_by_class_name
find_element_by_css_selector
```

查找多个元素

```
find_elements_by_name
find_elements_by_xpath
find_elements_by_link_text
find_elements_by_partial_link_text
find_elements_by_tag_name
find_elements_by_class_name
find_elements_by_css_selector
```

### 元素

|方法|说明|
|--|--|
|element.tag_name|标签名，如 'a'表示\<a\>元素|
|element.text|该元素内的文本，例如\<span\>hello\</span\>中的'hello'|
|element.get_attribute(x)|该元素x属性的值|

### 模拟浏览器操作

|方法|说明|
|--|--|
|element.click()|点击|
|element.send_keys()|输入|
|element.clear()|清除输入|
|ActionChains(driver).move_by_offset(xoffset,yoffset).perform()|移动鼠标，有些网页的弹窗需要我们做移开鼠标动作|
|ActionChains(driver).drag_and_drop_by_offset(source, xoffset, yoffset)|拖拽，多用于自动解验证码。拖滚动条用js语句更方便|
|driver.get()|地址栏跳转|
|driver.execute_script("window.scrollTo(0,document.body.scrollHeight)")|执行js语句，这句的意思是将滚动条拖至底部|

### 标签页管理

|driver.window_handles|列出所有标签页|
|driver.switch_to.window(driver.window_handles[-1])|切换至最新标签页|
|element.close()|闭当前标签页|
|element.quit()|关闭所有打开的标签页，假如所有标签页都被关闭，那么程序就会停止|

### 反爬

禁止selenium等自动控制软件访问，可通过设置以及js调整

```
options = webdriver.ChromeOptions()
#稳定运行
options.add_argument('-enable-webgl')#解决 GL is disabled的问题
options.add_argument('--no-sandbox')  # 解决DevToolsActivePort文件不存在的报错
options.add_argument('--disable-dev-shm-usage') 
options.add_argument('--ignore-gpu-blacklist') 
options.add_argument('--allow-file-access-from-files') 

#反爬
options.add_experimental_option("excludeSwitches", ["enable-automation"])# 模拟真正浏览器
options.add_experimental_option('useAutomationExtension', False)

driver = webdriver.Chrome(options=options)#声明浏览器
#模拟真正浏览器
driver.execute_cdp_cmd("Page.addScriptToEvaluateOnNewDocument", {
  "source": """
    Object.defineProperties(navigator,{webdriver:{get:() => false}});
  """
})
```

### 设置代理ip

```
options = webdriver.ChromeOptions()
options.add_argument("--proxy-server=http://110.73.2.248:8123")
driver_path = r"D:\ProgramApp\chromedriver\chromedriver.exe"
driver = webdriver.Chrome(executable_path=driver_path,chrome_options=options)
```

### 滚动条

```
from selenium import webdriver
import time
driver = webdriver.Chrome()#声明浏览器对象
try:
    driver.get("https://image.baidu.com")#相当于地址栏跳转
    box = driver.find_element_by_id('kw')#找到输入框
    box.click() 
    box.send_keys("传承换心")#先点一下，再输入内容
    button=driver.find_element_by_xpath("//input[@type='submit']")#找到按钮"百度一下"
    button.click - Domain Name For Sale | Dan.com()#按按钮
    
    js='window.scrollTo(0,document.body.scrollHeight)' #下滑到底部
    js2='return document.documentElement.scrollHeight' #检测当前滑动条位置

    #对于内嵌滚动条(不是网页边缘，而是网页里面可以拖动的东西)，需要用getElements把这个元素找出来，再和刚才做一样的操作
    #js='document.getElementsByClassName("unifycontainer-two-wrapper")[0].scrollTop=1000000' 
    #js2='return document.getElementsByClassName("unifycontainer-two-wrapper")[0].scrollHeight'
    
    height=-1
    now=driver.execute_script(js2)
    #当滑动条位置不再被“下滑到底部”这一行为影响，说明滑动条真的到了底部
    while height!=now:
        height=now
        driver.execute_script(js)
        time.sleep(1)
        now=driver.execute_script(js2)
    
    time.sleep(5)#对于想要看结果的程序，在最后设置一下暂停
    driver.close()
    #当然，也可以直接删掉close语句，让浏览器一直开着……

except Exception as e:
    print (e)
```
