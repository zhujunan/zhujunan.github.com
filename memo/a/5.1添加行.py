import sys
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QTableWidget, QTableWidgetItem

class MyWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setGeometry(100, 100, 600, 400)
        self.setWindowTitle("PyQt5 Table Widget Demo")

        # 创建表格控件，并设置初始行数为2
        self.table = QTableWidget(self)
        self.table.setRowCount(2)
        self.table.setColumnCount(3)
        self.table.setHorizontalHeaderLabels(['Column1', 'Column2', 'Column3'])

        # 允许用户添加新行
        add_row_button = QPushButton('Add Row', self)
        add_row_button.clicked.connect(self.add_new_row)

        # 将表格控件和添加行按钮添加到窗口中
        self.setCentralWidget(self.table)
        self.statusBar().addWidget(add_row_button)

    def add_new_row(self):
        row_count = self.table.rowCount()
        self.table.setRowCount(row_count + 1)

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Return:
            current_row = self.table.currentRow()
            current_col = self.table.currentColumn()
            item = QTableWidgetItem("")
            self.table.setItem(current_row, current_col, item)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MyWindow()
    window.show()
    sys.exit(app.exec_())