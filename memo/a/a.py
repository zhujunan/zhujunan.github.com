import subprocess
import tkinter as tk


class Window:
    def __init__(self, master):
        self.master = master
        self.master.title('窗口程序')

        # 左侧部分
        self.frame_left = tk.Frame(self.master)
        self.frame_left.pack(side=tk.LEFT, padx=10, pady=10)

        # 三个按钮
        self.button_settings = tk.Button(self.frame_left, text='设置', command=self.show_settings)
        self.button_settings.pack(pady=10)

        self.button_init = tk.Button(self.frame_left, text='初始化', command=self.init_remote)
        self.button_init.pack(pady=10)

        self.button_execute = tk.Button(self.frame_left, text='执行', command=self.execute_commands)
        self.button_execute.pack(pady=10)

        # 六个复选框
        self.checkbox_vars = [tk.BooleanVar() for i in range(6)]
        for i, var in enumerate(self.checkbox_vars):
            var.set(True)  # 默认勾选
            checkbox = tk.Checkbutton(self.frame_left, text=f'命令{i + 1}', variable=var)
            checkbox.pack(pady=5)

        # 右侧部分
        self.frame_right = tk.Frame(self.master)
        self.frame_right.pack(side=tk.RIGHT, padx=10, pady=10)

        # 三个窗口
        self.textbox_settings = tk.Text(self.frame_right, height=10, width=30, state=tk.DISABLED)
        self.textbox_settings.pack()

        self.textbox_init = tk.Text(self.frame_right, height=10, width=30, state=tk.DISABLED)
        self.textbox_init.pack()

        self.textbox_execute = tk.Text(self.frame_right, height=20, width=40, state=tk.DISABLED)
        self.textbox_execute.pack()

        self.windows = [self.textbox_settings, self.textbox_init, self.textbox_execute]
        self.current_window = 0
        self.show_window()

    # 根据当前窗口索引显示窗口
    def show_window(self):
        for i, window in enumerate(self.windows):
            if i == self.current_window:
                window.config(state=tk.NORMAL)
            else:
                window.config(state=tk.DISABLED)
        self.master.after(100, self.show_window)

    # 显示 settings.txt 中的值
    def show_settings(self):
        try:
            with open('settings.txt') as f:
                settings = f.read()
        except IOError:
            settings = '读取失败'
        self.textbox_settings.delete('1.0', tk.END)
        self.textbox_settings.insert(tk.END, settings)
        self.current_window = 0

    # 执行远程命令，并显示返回结果和设置中的值
    def init_remote(self):
        command = self.textbox_settings.get('1.0', tk.END).strip()
        try:
            result = subprocess.check_output(command.split(), stderr=subprocess.STDOUT, universal_newlines=True)
        except Exception as e:
            result = str(e)
        self.textbox_init.delete('1.0', tk.END)
        self.textbox_init.insert(tk.END, result)
        self.textbox_init.insert(tk.END, '\n\n' + command)
        self.current_window = 1

    # 在新进程中执行选择的命令，并实时显示返回值
    def execute_commands(self):
        commands = [f'命令{i + 1}' for i in range(6) if self.checkbox_vars[i].get()]
        if not commands:
            return
        self.current_window = 2

        # 开始执行命令
        processes = []
        for command in commands:
            process = subprocess.Popen(command.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                       universal_newlines=True)
            processes.append(process)

        # 实时显示返回值
        while any([process.poll() is None for process in processes]):
            for i, process in enumerate(processes):
                if process.poll() is None:
                    output = process.stdout.readline()
                    if output:
                        self.textbox_execute.insert(tk.END, f'{commands[i]}:\n{output}\n')
                    else:
                        process.wait()
                        self.textbox_execute.insert(tk.END, f'{commands[i]}: 已完成\n\n')
        self.textbox_execute.insert(tk.END, '所有命令已执行完毕\n')


root = tk.Tk()
app = Window(root)
root.mainloop()


# 说明：
#
# 使用 tk.Frame 构建左右两个部分，分别放置各种控件。
#
# 每个窗口都使用 tk.Text 构建，高度和宽度可以自由调整，并且默认为不可编辑状态。
#
# 在点击按钮后，回调函数会修改窗口内容并将当前窗口索引设为对应值。由于在程序中使用了类似“实时显示”的功能，需要使用 after 函数定时调用方法。
#
# 执行远程命令时，使用 subprocess.check_output 函数执行命令并获取返回结果。
#
# 在新进程中执行命令时，需要使用 subprocess.Popen 函数创建新进程，并实时获取输出。注意，每个进程都要使用单独的 Popen 对象来管理、获取输出，否则会导致进程阻塞。
#
# 程序可能存在一些小问题或不足，可以根据具体情况进行修改。