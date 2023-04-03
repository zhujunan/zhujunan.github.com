'''使用python写一个窗口程序，窗口左边有4个标签，右边是标签页

左侧第一个标签是设置，点击后在右侧上面显示一个窗口，右侧下面显示两个按钮
同时，获取本地txt数据作为全局变量，txt内容为a=1等，打印在窗口中。如果本地没有txt，获取代码中的字符串作为代替
可以在窗口中直接修改显示的值
右侧下面第一个按钮是放弃修改，重新读取txt。第二个按钮是保存修改，读取窗口中修改作为全局变量，并保存到txt中

左侧第二个标签是初始化，点击后在右侧上面显示一个窗口，中间也有一个窗口，右侧下面显示两个按钮
同时，获取全局变量中的指令，例如“os.listdir()”打印在上面的窗口中, 可以在窗口中直接修改显示的值
右侧下面第一个按钮是放弃修改，重新读取全局变量中的指令。右侧下面第二个按钮是执行，读取窗口中的执行，执行后将结果显示到下面的窗口中。执行中无法进行其他操作。

左侧第三个标签是同步修改，点击后在右侧上面显示一个窗口，右侧下面显示两个按钮
右侧下面第一个按钮是开始同步，重新读取全局变量中的指令，执行后将结果保存入全局变量，之后在结果前面添加字符串：“结果为”，显示到下面的窗口中。执行中无法进行其他操作。

第四个标签是执行命令，点击后在右侧上面显示一个窗口，窗口下放是三排两列的6个复选框，复选框默认被选中。再往下还有一个窗口，右侧下面显示两个按钮
同时，获取全局变量中同步修改按钮的结果打印在右侧上面的窗口中, 可以在窗口中直接修改显示的值
右侧下面第一个按钮是放弃修改，重新读取全局变量中的指令。右侧下面第二个按钮是执行，读取窗口中的指令，和复选框中的数据。复选框有几个被选中，就开启多少个线程同时执行指令，执行中是实时将结果显示到下面的窗口中。执行中无法进行其他操作。
'''

import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, QTabWidget

class SettingsTab(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 创建布局管理器
        main_layout = QVBoxLayout()
        bottom_layout = QHBoxLayout()

        # 创建两个编辑框和一个“保存”按钮
        self.edit1 = QLineEdit()
        self.edit2 = QLineEdit()
        save_btn = QPushButton("保存")

        # 将两个编辑框和“保存”按钮添加到主布局中
        main_layout.addWidget(self.edit1)
        main_layout.addWidget(self.edit2)
        main_layout.addLayout(bottom_layout)

        # 将“保存”按钮添加到底部布局中
        bottom_layout.addWidget(save_btn)

        # 绑定事件处理程序
        save_btn.clicked.connect(self.save_values)

        self.setLayout(main_layout)

    def save_values(self):
        # 保存编辑框的值到本地文件
        with open("settings.txt", "w") as f:
            f.write(f"{self.edit1.text()},{self.edit2.text()}")


class InitTab(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 创建布局管理器
        main_layout = QVBoxLayout()
        bottom_layout = QHBoxLayout()

        # 创建一个编辑框和两个按钮
        self.edit = QLineEdit()
        reset_btn = QPushButton("重置")
        init_btn = QPushButton("初始化")

        # 将编辑框和两个按钮添加到主布局中
        main_layout.addWidget(self.edit)
        main_layout.addLayout(bottom_layout)

        # 将两个按钮添加到底部布局中
        bottom_layout.addWidget(reset_btn)
        bottom_layout.addWidget(init_btn)

        # 绑定事件处理程序
        reset_btn.clicked.connect(self.reset_value)
        init_btn.clicked.connect(self.init_value)

        self.setLayout(main_layout)

    def reset_value(self):
        # 重置编辑框的值为本地文件中保存的值
        with open("value.txt", "r") as f:
            value = f.read()
        self.edit.setText(value)

    def init_value(self):
        # 初始化编辑框的值为默认值
        self.edit.setText("Hello world")


class SyncTab(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        # 创建布局管理器
        main_layout = QVBoxLayout()
        bottom_layout = QHBoxLayout()

        # 创建两个编辑框
        self.edit1 = QLineEdit()
        self.edit2 = QLineEdit()

        # 将两个编辑框加入主布局中
        main_layout.addWidget(self.edit1)
        main_layout.addWidget(self.edit2)

        # 创建重置按钮
        reset_btn = QPushButton("重置")
        bottom_layout.addWidget(reset_btn)

        # 绑定事件处理程序
        self.edit1.textChanged.connect(self.sync_edits)
        self.edit2.textChanged.connect(self.sync_edits)
        reset_btn.clicked.connect(self.reset_values)

        main_layout.addLayout(bottom_layout)
        self.setLayout(main_layout)

    def sync_edits(self):
        # 同步编辑框的值
        if self.sender() == self.edit1:
            self.edit2.setText(self.edit1.text())
        else:
            self.edit1.setText(self.edit2.text())

    def reset_values(self):
        # 重置编辑框的值
        self.edit1.setText("")
        self.edit2.setText("")


class CommandTab(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        # 创建布局管理器
        main_layout = QVBoxLayout()
        bottom_layout = QHBoxLayout()

        # 创建输入框和按钮
        self.edit = QLineEdit()
        run_btn = QPushButton("执行")

        # 将输入框和按钮添加到主布局中
        main_layout.addWidget(self.edit)
        main_layout.addLayout(bottom_layout)

        # 将“执行”按钮添加到底部布局中
        bottom_layout.addWidget(run_btn)

        # 绑定事件处理程序
        run_btn.clicked.connect(self.run_code)

        self.setLayout(main_layout)

    def run_code(self):
        # 执行用户输入的Python代码
        code = self.edit.text()
        exec(code)


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 初始化窗口
        self.setWindowTitle("MainWindow")
        self.setGeometry(100, 100, 800, 600)

        # 左侧标签栏布局
        tab_layout = QHBoxLayout()

        # 创建四个标签并将其添加到布局中
        settings_tab = QLabel("设置")
        init_tab = QLabel("初始化")
        sync_tab = QLabel("同步修改")
        command_tab = QLabel("执行命令")
        tab_layout.addWidget(settings_tab)
        tab_layout.addWidget(init_tab)
        tab_layout.addWidget(sync_tab)
        tab_layout.addWidget(command_tab)

        # 右侧标签页控件
        tab_widget = QTabWidget()

        # 创建四个标签页，并将它们添加到标签页控件中
        settings_tab_widget = SettingsTab()
        init_tab_widget = InitTab()
        sync_tab_widget = SyncTab()
        command_tab_widget = CommandTab()
        tab_widget.addTab(settings_tab_widget, "设置")
        tab_widget.addTab(init_tab_widget, "初始化")
        tab_widget.addTab(sync_tab_widget, "同步修改")
        tab_widget.addTab(command_tab_widget, "执行命令")

        # 将左侧标签栏和右侧标签页控件添加到主布局中
        main_layout = QHBoxLayout()
        main_layout.addLayout(tab_layout)
        main_layout.addWidget(tab_widget)

        self.setLayout(main_layout)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())