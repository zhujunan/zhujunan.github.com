### 初始化

from bs4 import BeautifulSoup

### 解析器

Beautiful Soup选择最合适的解析器来解析文档,如果手动指定解析器那么Beautiful Soup会选择指定的解析器来解析文档

|解析器|使用方法|
|--|--|
|bs4 HTML 解析器|BeautifulSoup(markup, "html.parser")|	
|lxml HTML 解析器|BeautifulSoup(markup, "lxml")|
|lxml XML 解析器|BeautifulSoup(markup, "xml")|
|html5lib 解析器|BeautifulSoup(markup, "html5lib")|

### 创建文档对象

```
soup = BeautifulSoup(open("index.html"))

soup = BeautifulSoup("<html>data</html>")
```

### Tag

当有多个相同标签时，soup.<tag>只能返回第一个

<名称 属性=“title”>...</名称>

tag.name

tag.attrs 属性的字典

tag.string 标签内非属性字符串，NavigableString，子标签中的内容也会显示

tag.comment 如果为html注释，<!--注释-->, 则tag.string返回类型不为string而是comment，bs4.element.comment

### 多级关系

tag.parent 父标签，即上一级标签

### html遍历方法

* 标签树的下行遍历

  .contents       子节点的列表
  .children       子节点的迭代类型，与.contents类似，用于循环遍历儿子节点
  .descendants    子孙节点的迭代类型，包含所有子孙节点，用于循环遍历

* 标签树的上行遍历
  
  .parent         节点的父亲标签
  .parents        节点先辈标签的迭代类型，用于循环遍历先辈节点
  
* 标签树的平行遍历
  
  .next_sibling       返回按照HTML文本顺序的下一个平行节点标签
  .previous_sibling   返回按照HTML文本顺序的上一个平行节点标签
  .next_siblings      迭代类型，返回按照HTML文本顺序的后续所有平行节点标签
  .previous_siblings  迭代类型，返回按照HTML文本顺序的前续所有平行节点标签
  
  
  
