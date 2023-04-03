import sys
from PyQt5.QtWidgets import QApplication, QWidget, QTabWidget, QTextEdit, QCheckBox, QPushButton, QHBoxLayout, QVBoxLayout


class MyApp(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 创建tab widget
        tabs = QTabWidget(self)
        tabs.resize(1000, 700)

        # 设置标签的大小和字号，以及被选中的标签页颜色
        tabs.setStyleSheet("QTabBar::tab { width: 100px; height: 50px; font-size: 14pt; } "
                           "QTabBar::tab:selected { color: black; background-color: lightblue; }")

        # 创建6个标签页
        for i in range(1, 7):
            tab = QWidget()
            tabs.addTab(tab, f'Tab {i}')

            # 在每个标签页下方添加不同的部件
            if i == 1:
                text_edit = QTextEdit(tab)
                text_edit.setGeometry(10, 10, 980, 650)
            elif i == 2:
                check_box = QCheckBox('Checkbox', tab)
                check_box.move(int((1000-check_box.width())/2), 50)
            elif i == 3:
                button = QPushButton('Button', tab)
                button.move(1000-button.width()-50, 600-button.height()-50)
            elif i == 4:
                text_edit = QTextEdit(tab)
                text_edit.setGeometry(10, 10, 580, 750)
            elif i == 5:
                check_box = QCheckBox('Checkbox', tab)
                check_box.move(int((1000-check_box.width())/2), 50)
            else:
                button = QPushButton('Button', tab)
                button.move(1000-button.width()-50, 600-button.height()-50)

        self.setWindowTitle('MyApp')
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())