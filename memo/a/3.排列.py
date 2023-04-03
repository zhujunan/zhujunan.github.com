import sys
from PyQt5.QtWidgets import QApplication, QWidget, QCheckBox, QLineEdit, QPushButton, QVBoxLayout, QHBoxLayout


class Example(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 创建6个复选框，2行3列
        cb1 = QCheckBox('复选框1', self)
        cb2 = QCheckBox('复选框2', self)
        cb3 = QCheckBox('复选框3', self)
        cb4 = QCheckBox('复选框4', self)
        cb5 = QCheckBox('复选框5', self)
        cb6 = QCheckBox('复选框6', self)

        # 创建一个指定大小的文本框
        txt = QLineEdit(self)
        txt.setFixedWidth(1000)
        txt.setFixedHeight(200)

        # 创建一个指定大小的按钮
        btn = QPushButton('按钮', self)
        btn.setFixedSize(80, 30)

        # 使用水平布局管理器排列第一行
        hbox1 = QHBoxLayout()
        hbox1.addWidget(cb1)
        hbox1.addWidget(cb2)
        hbox1.addWidget(cb3)

        # 使用水平布局管理器排列第二行
        hbox2 = QHBoxLayout()
        hbox2.addWidget(cb4)
        hbox2.addWidget(cb5)
        hbox2.addWidget(cb6)

        # 使用水平布局管理器排列文本框和按钮
        hbox3 = QHBoxLayout()
        hbox3.addWidget(txt)
        hbox3.addWidget(btn)

        # 使用垂直布局管理器排列所有行
        vbox = QVBoxLayout()
        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)

        self.setLayout(vbox)

        self.setGeometry(300, 300, 300, 200)
        self.setWindowTitle('复选框、文本框和按钮')
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())