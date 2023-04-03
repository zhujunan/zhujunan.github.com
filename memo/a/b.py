import tkinter as tk
import subprocess


class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('Remote Command Execution')
        self.geometry('800x400')

        # Create left frame with buttons and checkboxes
        self.left_frame = tk.Frame(self, width=200)
        self.left_frame.pack(side=tk.LEFT, fill=tk.BOTH)

        # Create three buttons
        self.btn_settings = tk.Button(self.left_frame, text='Settings', command=self.show_settings)
        self.btn_settings.pack(pady=10)

        self.btn_init = tk.Button(self.left_frame, text='Initialize', command=self.initialize)
        self.btn_init.pack(pady=10)

        self.btn_exec = tk.Button(self.left_frame, text='Execute', command=self.execute)
        self.btn_exec.pack(pady=10)

        # Create six checkboxes
        self.var1 = tk.BooleanVar(value=True)
        self.var2 = tk.BooleanVar(value=True)
        self.var3 = tk.BooleanVar(value=True)
        self.var4 = tk.BooleanVar(value=True)
        self.var5 = tk.BooleanVar(value=True)
        self.var6 = tk.BooleanVar(value=True)

        self.chkbox1 = tk.Checkbutton(self.left_frame, text='Command 1', variable=self.var1)
        self.chkbox1.pack()
        self.chkbox2 = tk.Checkbutton(self.left_frame, text='Command 2', variable=self.var2)
        self.chkbox2.pack()
        self.chkbox3 = tk.Checkbutton(self.left_frame, text='Command 3', variable=self.var3)
        self.chkbox3.pack()
        self.chkbox4 = tk.Checkbutton(self.left_frame, text='Command 4', variable=self.var4)
        self.chkbox4.pack()
        self.chkbox5 = tk.Checkbutton(self.left_frame, text='Command 5', variable=self.var5)
        self.chkbox5.pack()
        self.chkbox6 = tk.Checkbutton(self.left_frame, text='Command 6', variable=self.var6)
        self.chkbox6.pack()

        # Create right frames with windows
        self.right_frame1 = tk.Frame(self, width=600, height=400)
        self.right_frame1.pack(side=tk.LEFT, fill=tk.BOTH)

        self.right_frame2 = tk.Frame(self, width=600, height=400)
        self.right_frame2.pack_forget()

        self.right_frame3 = tk.Frame(self, width=600, height=400)
        self.right_frame3.pack_forget()

        # Set up labels for the three windows
        self.label1 = tk.Label(self.right_frame1, text='Window 1')
        self.label1.pack(pady=10)

        self.label2_upper = tk.Label(self.right_frame2, text='Results from initialization command:')
        self.label2_upper.pack(pady=10)

        self.label2_lower = tk.Label(self.right_frame2, text='')
        self.label2_lower.pack(pady=10)

        self.label3 = tk.Label(self.right_frame3, text='Executing Commands:')
        self.label3.pack(pady=10)

    def show_settings(self):
        # Read settings.txt and display its contents in window 1
        with open('settings.txt', 'r') as f:
            settings_value = f.read()

        self.label1.config(text=settings_value)

        # Show the first window and hide the other two
        self.right_frame1.pack()
        self.right_frame2.pack_forget()
        self.right_frame3.pack_forget()

    def initialize(self):
        # Get the value from the first window label and use it as a command to execute
        cmd = self.label1.cget('text')
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        # Display the output in the upper part of window 2
        self.label2_upper.config(text=result.stdout)

        # Display the value from the first window label in the lower part of window 2
        self.label2_lower.config(text=self.label1.cget('text'))

        # Show the second window and hide the other two
        self.right_frame1.pack_forget()
        self.right_frame2.pack()
        self.right_frame3.pack_forget()

    def execute(self):
        # Create a list of commands based on which checkboxes are checked
        commands = []
        if self.var1.get():
            commands.append('command1')
        if self.var2.get():
            commands.append('command2')
        if self.var3.get():
            commands.append('command3')
        if self.var4.get():
            commands.append('command4')
        if self.var5.get():
            commands.append('command5')
        if self.var6.get():
            commands.append('command6')

        # Create a subprocess for each command and display the output in window 3
        for cmd in commands:
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            self.label3.config(text=self.label3.cget('text') + '\n' + result.stdout)

        # Show the third window and hide the other two
        self.right_frame1.pack_forget()
        self.right_frame2.pack_forget()
        self.right_frame3.pack()


# if __name__ == 'main':
app = MainWindow()
app.mainloop()


# 使用python制作一个窗口程序，分为左右两个部分。左边是竖着排列的三个按钮和3x2的6个复选框，复选框默认勾选。右边有三个窗口且位置重叠在一起，根据点击右侧按钮进行切换。
#
# 第一个按钮，名称为设置。读取settings.txt ,取其中的值，显示第一个窗口并打印settings.txt中的值。第一个窗口中的值能够打印
# 第二个按钮，名称为初始化。读取第一个窗口中的值，作为命令在远程linux机器上执行。并把显示第二个窗口，上半部分打印返回结果，下半部分打印第一个窗口中的值
# 第三个按钮，名称为执行。3x2的6个复选框，每有一个勾选就新建一个进程，将命令在远程linux机器上执行。并显示第三个窗口，整理所有的输出，实时显示返回值

# 这个程序会创建一个名为MainWindow的类，继承自Tkinter的Tk类。在构造函数中，创建了一个左侧带有三个按钮和六个复选框的帧，右侧有三个带有标签的重叠窗口帧。当用户单击不同的按钮时，显示相应的窗口。
#
# show_settings方法从settings.txt文件中读取内容，并将其显示在第一个窗口中。initialize方法执行第一个窗口中的命令，并将结果显示在第二个窗口的上半部分，同时显示第一个窗口中的值作为下半部分。execute方法根据选择的复选框创建命令列表，并逐个执行每个命令，将结果显示在第三个窗口中。
#
# 请注意，此示例代码仅供参考，您可能需要根据自己的需求进行修改和调整。