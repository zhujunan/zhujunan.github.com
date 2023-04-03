import sys
from PyQt5 import QtWidgets, QtGui


class Window(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("标签页面")
        self.setGeometry(100, 100, 500, 400)

        # 创建标签控件
        self.tabControl = QtWidgets.QTabWidget(self)

        # 设置标签为竖直方向
        self.tabControl.setTabPosition(QtWidgets.QTabWidget.West)

        # 设置标签字体大小和旋转角度
        font = QtGui.QFont()
        font.setPointSize(15)
        font.setCapitalization(QtGui.QFont.AllUppercase)
        for i in range(self.tabControl.count()):
            self.tabControl.tabBar().setTabButton(i, QtWidgets.QTabBar.RightSide, None)
            self.tabControl.tabBar().setTabButton(i, QtWidgets.QTabBar.LeftSide, None)
            self.tabControl.tabBar().setTabText(i, "  " + self.tabControl.tabText(i) + " ")
            self.tabControl.tabBar().tabButton(i, QtWidgets.QTabBar.RightSide).hide()
            self.tabControl.tabBar().tabButton(i, QtWidgets.QTabBar.LeftSide).hide()
        self.tabControl.tabBar().setFont(font)
        self.tabControl.tabBar().setExpanding(False)

        # 创建第一个标签页并添加到标签控件中
        self.tab1 = QtWidgets.QWidget()
        self.tabControl.addTab(self.tab1, "")

        # 设置第一个标签页的标题和图标
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap("tab1.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.tabControl.setTabIcon(0, icon1)
        self.tabControl.setTabText(0, "第一个标签页")

        # 给第一页添加两个输出框和一个复选框
        output_box1 = QtWidgets.QTextEdit(self.tab1)
        output_box1.setGeometry(10, 10, 380, 180)

        output_box2 = QtWidgets.QTextEdit(self.tab1)
        output_box2.setGeometry(10, 200, 380, 180)

        checkbox1 = QtWidgets.QCheckBox("勾选以继续", self.tab1)
        checkbox1.setGeometry(400, 120, 100, 20)

        # 创建第二个标签页并添加到标签控件中
        self.tab2 = QtWidgets.QWidget()
        self.tabControl.addTab(self.tab2, "")

        # 设置第二个标签页的标题和图标
        icon2 = QtGui.QIcon()
        icon2.addPixmap(QtGui.QPixmap("tab2.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.tabControl.setTabIcon(1, icon2)
        self.tabControl.setTabText(1, "第二个标签页")

        # 给第二页添加三个输出框和两个复选框
        output_box3 = QtWidgets.QTextEdit(self.tab2)
        output_box3.setGeometry(10, 10, 380, 120)

        output_box4 = QtWidgets.QTextEdit(self.tab2)
        output_box4.setGeometry(10, 140, 380, 120)

        output_box5 = QtWidgets.QTextEdit(self.tab2)
        output_box5.setGeometry(10, 270, 380, 110)

        checkbox2 = QtWidgets.QCheckBox("勾选以继续", self.tab2)
        checkbox2.setGeometry(400, 70, 100, 20)

        checkbox3 = QtWidgets.QCheckBox("勾选以完成", self.tab2)
        checkbox3.setGeometry(400, 170, 100, 20)

        # 设置标签控件为主窗口的中心组件
        self.setCentralWidget(self.tabControl)


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())