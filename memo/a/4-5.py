# from PyQt5.QtCore import Qt
# from PyQt5.QtWidgets import QApplication, QWidget, QLabel
#
# app = QApplication([])
# window = QWidget()
#
# label = QLabel("这是一个标签", window)
# label.setAlignment(Qt.AlignCenter | Qt.AlignRight)
#
# window.show()
# app.exec_()

from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QWidget, QLabel

app = QApplication([])
window = QWidget()

label = QLabel("这是一个标签", window)
label.setAlignment(Qt.AlignLeft)
#AlignTop

window.show()
app.exec_()


# 设置标签的文字排列方式需要使用Qt的AlignFlag枚举类型中的相关属性，具体如下：
#
# 从上到下：使用Qt.AlignTop设置文字在垂直方向上靠上对齐。
# 从左到右：使用Qt.AlignLeft或Qt.AlignRight设置文字在水平方向上对齐。
# 在PyQt5中，可以使用以下代码来设置标签的文字排列方式：
#
# python
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QWidget, QLabel

app = QApplication([])
window = QWidget()

label = QLabel("这是一个标签", window)
label.setAlignment(Qt.AlignTop | Qt.AlignLeft)

window.show()
app.exec_()
# =======================================================
# pyqt窗口，表格中有复选框，并通过按钮获取表格和复选框的值

from PyQt5.QtWidgets import QApplication, QWidget, QTableWidget, QGridLayout, QPushButton
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QWidget, QTableWidget, QTableWidgetItem, QGridLayout, QPushButton

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('表格和按钮')
        self.setGeometry(200, 200, 600, 400)

        # 创建表格控件并设置列数为2
        self.table = QTableWidget(self)
        self.table.setColumnCount(2)

        # 设置表格头
        self.table.setHorizontalHeaderLabels(['值', '复选框'])

        # 填充表格的数据
        self.table.setRowCount(5)
        for i in range(5):
            item_value = str(i+1)  # 设置第一列的值为1-5
            item_checkbox = QTableWidgetItem()  # 创建一个复选框
            item_checkbox.setCheckState(Qt.Unchecked)  # 默认为未选中状态
            self.table.setItem(i, 0, QTableWidgetItem(item_value))
            self.table.setItem(i, 1, item_checkbox)

        # 创建按钮控件并设置点击事件
        self.button = QPushButton('获取选中行的值', self)
        self.button.clicked.connect(self.get_checked_rows)

        # 创建布局，并把表格和按钮添加到布局中
        layout = QGridLayout(self)
        layout.addWidget(self.table, 0, 0, 1, 1)
        layout.addWidget(self.button, 1, 0, 1, 1)

    def get_checked_rows(self):
        checked_rows = []
        for row in range(self.table.rowCount()):
            checkbox_item = self.table.item(row, 1)  # 获取第二列的复选框
            if checkbox_item.checkState() == Qt.Checked:
                item_value = self.table.item(row, 0).text()  # 获取第一列的值
                checked_rows.append(item_value)
        print('选中行的值为：{}'.format(','.join(checked_rows)))


if __name__ == '__main__':
    app = QApplication([])
    window = MainWindow()
    window.show()
    app.exec_()

# =======================================================
# 3. pyqt窗口，表格的删除

from PyQt5.QtWidgets import QApplication, QWidget, QTableWidget, QTableWidgetItem, QGridLayout, QPushButton


class TableWidget(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('表格窗口')
        self.setGeometry(200, 200, 600, 400)

        # 创建表格控件并设置列数为3
        self.table = QTableWidget(self)
        self.table.setColumnCount(3)

        # 设置表格头
        self.table.setHorizontalHeaderLabels(['姓名', '年龄', '性别'])

        # 填充表格的数据
        self.table.setRowCount(5)
        for i in range(5):
            item_name = QTableWidgetItem('张三' + str(i+1))
            item_age = QTableWidgetItem(str(20+i))
            item_sex = QTableWidgetItem('男')
            self.table.setItem(i, 0, item_name)
            self.table.setItem(i, 1, item_age)
            self.table.setItem(i, 2, item_sex)

        # 创建删除按钮控件并设置点击事件
        self.button_delete = QPushButton('删除选中行', self)
        self.button_delete.clicked.connect(self.delete_selected_rows)

        # 创建布局，并把表格和按钮添加到布局中
        layout = QGridLayout(self)
        layout.addWidget(self.table, 0, 0, 1, 1)
        layout.addWidget(self.button_delete, 1, 0, 1, 1)

    def delete_selected_rows(self):
        selected_indexes = self.table.selectedIndexes()
        selected_rows = set()  # 记录所有选中的行号
        for index in selected_indexes:
            selected_rows.add(index.row())

        # 遍历所有选中的行号，调用 removeRow() 方法逐行删除
        for row in sorted(selected_rows, reverse=True):
            self.table.removeRow(row)


if __name__ == '__main__':
    app = QApplication([])
    window = TableWidget()
    window.show()
    app.exec_()


# =======================================================
#  PyQt  设置文本框的大小、位置，并把文本框背景设置为透明，边框设置为无。在文本框中打印本地文件的地址，点击打开文件

import os
from PyQt5.QtWidgets import QApplication, QWidget, QTextEdit, QPushButton, QFileDialog, QVBoxLayout
from PyQt5.QtCore import Qt


class TextWidget(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('文本框窗口')

        # 设置窗口大小和位置
        self.setGeometry(200, 200, 600, 400)

        # 创建文本框控件并设置透明背景和无边框
        self.text_edit = QTextEdit(self)
        self.text_edit.setGeometry(50, 50, 500, 300)
        self.text_edit.setStyleSheet("background-color: transparent; border: none")

        # 创建按钮控件并设置点击事件
        self.button_open = QPushButton('打开文件', self)
        self.button_open.clicked.connect(self.open_file_dialog)

        # 创建布局，并把文本框和按钮添加到布局中
        layout = QVBoxLayout(self)
        layout.addWidget(self.text_edit)
        layout.addWidget(self.button_open)

    def open_file_dialog(self):
        # 打开文件选择对话框，获取用户选择的文件路径
        file_path, _ = QFileDialog.getOpenFileName(self, '打开文件', os.path.expanduser('~'), 'All Files (*)')

        if file_path:
            # 路径存在则在文本框中显示路径
            self.text_edit.setText(file_path)


if __name__ == '__main__':
    app = QApplication([])
    window = TextWidget()
    window.show()
    app.exec_()


import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLineEdit, QTextBrowser
from PyQt5.QtGui import QPalette, QColor, QTextCursor
from PyQt5.QtCore import Qt, QUrl

class Example(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 创建一个文本框
        self.textbox = QTextBrowser(self)
        # 设置文本框的位置和大小
        self.textbox.setGeometry(20, 20, 300, 80)
        # 设置文本框的背景为透明
        self.textbox.setStyleSheet("background-color: rgba(0, 0, 0, 0)")
        # 设置文本框的边框为无
        # self.textbox.setFrameStyle(QLineEdit.NoFrame)

        # 打印本地文件地址，并超链接到该文件
        file_path = "C:/Users/xxx/Desktop/example.txt"
        self.textbox.insertHtml("<a href='file:///" + file_path + "'>" + file_path + "</a>")

        self.show()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())