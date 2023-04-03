from PyQt5 import QtCore, QtGui, QtWidgets
import sys

class MyWindow(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        self.setWindowTitle("Table Example")

        # 创建表格
        self.tableWidget = QtWidgets.QTableWidget()
        self.tableWidget.setRowCount(0)
        self.tableWidget.setColumnCount(2)
        self.tableWidget.setHorizontalHeaderLabels(["Variable Name", "Value"])
        self.tableWidget.itemChanged.connect(self.on_item_changed)

        # 创建文本框和按钮
        self.text = QtWidgets.QLineEdit(self)
        self.btn = QtWidgets.QPushButton("Get New Value", self)
        self.btn.clicked.connect(self.get_new_value)

        # 设置垂直布局
        vbox = QtWidgets.QVBoxLayout(self)
        vbox.addWidget(self.tableWidget)
        vbox.addWidget(self.text)
        hbox = QtWidgets.QHBoxLayout()
        hbox.addStretch(1)
        hbox.addWidget(self.btn)
        vbox.addLayout(hbox)

        # 设置窗口大小和位置
        self.setGeometry(300, 300, 250, 150)

        # 初始化变量列表
        self.variables = {}

    def add_variable(self, variable_name, value):
        # 将变量名和值添加到字典中
        self.variables[variable_name] = value

        # 在表格中添加一行
        row_count = self.tableWidget.rowCount()
        self.tableWidget.insertRow(row_count)
        self.tableWidget.setItem(row_count, 0, QtWidgets.QTableWidgetItem(variable_name))
        self.tableWidget.setItem(row_count, 1, QtWidgets.QTableWidgetItem(value))

    def on_item_changed(self, item):
        # 获取修改后的值
        new_value = item.text()

        # 获取变量名
        variable_name = self.tableWidget.item(item.row(), 0).text()

        # 输出旧值和新值到文本框
        old_value = self.variables.get(variable_name, "")
        if old_value != new_value:
            message = f"{variable_name}: Old Value: {old_value}, New Value: {new_value}"
            self.text.setText(message)

        # 更新字典中的值
        self.variables[variable_name] = new_value

    def get_new_value(self):
        # 获取变量名和旧值
        variable_name = self.tableWidget.item(0, 0).text()
        old_value = self.variables.get(variable_name, "")

        # 模拟获取新值，并更新表格和文本框
        new_value = "10"
        self.tableWidget.setItem(0, 1, QtWidgets.QTableWidgetItem(new_value))
        message = f"{variable_name}: Old Value: {old_value}, New Value: {new_value}"
        self.text.setText(message)

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MyWindow()

    # 添加变量到列表中
    window.add_variable("a", "5")
    window.add_variable("b", "3")

    window.show()
    sys.exit(app.exec_())