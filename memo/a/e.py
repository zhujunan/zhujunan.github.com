import tkinter as tk
import threading
import os

global_data = 'a=1'

# 读取本地txt数据作为全局变量
try:
    with open('data.txt', 'r') as f:
        global_data = f.read()
except FileNotFoundError:
    global_data = 'a=1'

# 初始化窗口
root = tk.Tk()
root.title("Button Control")

# 左侧按钮容器
left_frame = tk.Frame(root)
left_frame.pack(side=tk.LEFT, padx=10, pady=10)

# 右侧容器
right_frame = tk.Frame(root)
right_frame.pack(side=tk.RIGHT, padx=10, pady=10)

# 显示框
text_area1 = tk.Text(right_frame, width=60, height=10)
text_area2 = tk.Text(right_frame, width=60, height=10)
text_area3 = tk.Text(right_frame, width=60, height=10)


# 设置
def set_window():
    # 清空文本框
    text_area1.delete(1.0, tk.END)
    text_area2.delete(1.0, tk.END)

    # 添加本地数据
    text_area1.insert(tk.END, global_data)

    # 显示修改和保存按钮
    button_discard.grid(row=2, column=0, padx=5, pady=5)
    button_save.grid(row=2, column=1, padx=5, pady=5)


# 初始化
def init_window():
    # 清空文本框
    text_area1.delete(1.0, tk.END)
    text_area2.delete(1.0, tk.END)
    text_area3.delete(1.0, tk.END)

    # 显示修改和保存按钮
    button_discard_i.grid(row=2, column=0, padx=5, pady=5)
    button_exec.grid(row=2, column=1, padx=5, pady=5)

    # 获取全局变量中的指令
    command = global_data.split('=')[1]
    result = eval(command)
    text_area2.insert(tk.END, str(result))


# 同步修改
def sync_window():
    # 清空文本框
    text_area1.delete(1.0, tk.END)
    text_area2.delete(1.0, tk.END)
    text_area3.delete(1.0, tk.END)

    # 显示开始同步按钮
    button_sync.grid(row=2, column=0, padx=5, pady=5)


# 执行命令
def exec_window():
    # 清空文本框
    text_area1.delete(1.0, tk.END)
    text_area2.delete(1.0, tk.END)
    text_area3.delete(1.0, tk.END)

    # 显示复选框
    check_var1.set(1)
    check_var2.set(1)
    check_var3.set(1)
    check_var4.set(1)
    check_var5.set(1)
    check_var6.set(1)
    check1.grid(row=1, column=0)
    check2.grid(row=1, column=1)
    check3.grid(row=1, column=2)
    check4.grid(row=1, column=3)
    check5.grid(row=1, column=4)
    check6.grid(row=1, column=5)

    # 显示执行和放弃按钮
    button_discard_e.grid(row=2, column=0, padx=5, pady=5)
    button_exec_e.grid(row=2, column=1, padx=5, pady=5)


# 放弃修改
def discard():
    # 清空文本框
    text_area1.delete(1.0, tk.END)
    text_area2.delete(1.0, tk.END)
    text_area3.delete(1.0, tk.END)

    # 隐藏按钮和复选框
    button_discard.grid_forget()
    button_save.grid_forget()
    button_discard_i.grid_forget()
    button_exec.grid_forget()
    button_sync.grid_forget()
    button_discard_e.grid_forget()
    button_exec_e.grid_forget()
    check1.grid_forget()
    check2.grid_forget()
    check3.grid_forget()
    check4.grid_forget()
    check5.grid_forget()
    check6.grid_forget()


# 保存修改
def save():
    global global_data
    new_data = text_area1.get(1.0, tk.END)
    with open('data.txt', 'w') as f:
        f.write(new_data)
    global_data = new_data
    discard()


# 同步
def sync_thread():
    # 获取全局变量中的指令
    command = global_data.split('=')[1]
    result = eval(command)
    # 将结果前面添加字符串：“结果为”
    result_str = '结果为' + str(result)
    # 保存到全局变量中
    global_data = 'a=' + str(result)
    # 显示结果
    text_area3.insert(tk.END, result_str)


# 执行
def exec_thread():
    # 获取执行框中的指令
    command = text_area2.get(1.0, tk.END).strip()

    # 获取复选框的状态
    status1 = check_var1.get()
    status2 = check_var2.get()
    status3 = check_var3.get()
    status4 = check_var4.get()
    status5 = check_var5.get()
    status6 = check_var6.get()

    # 开启线程并执行指令
    if status1:
        t1 = threading.Thread(target=exec_command, args=(command,))
        t1.start()
    if status2:
        t2 = threading.Thread(target=exec_command, args=(command,))
        t2.start()
    if status3:
        t3 = threading.Thread(target=exec_command, args=(command,))
        t3.start()
    if status4:
        t4 = threading.Thread(target=exec_command, args=(command,))
        t4.start()
    if status5:
        t5 = threading.Thread(target=exec_command, args=(command,))
        t5.start()
    if status6:
        t6 = threading.Thread(target=exec_command, args=(command,))
        t6.start()


# 执行指令
def exec_command(command):
    result = os.popen(command).read()
    text_area3.insert(tk.END, result)


# 设置按钮
button_set = tk.Button(left_frame, text="设置", width=10, height=2, command=set_window)
button_set.pack(pady=5)

# 初始化按钮
button_init = tk.Button(left_frame, text="初始化", width=10, height=2, command=init_window)
button_init.pack(pady=5)

# 同步修改按钮
button_sync_data = tk.Button(left_frame, text="同步修改", width=10, height=2, command=sync_window)
button_sync_data.pack(pady=5)

# 执行命令按钮
button_exec_command = tk.Button(left_frame, text="执行命令", width=10, height=2, command=exec_window)
button_exec_command.pack(pady=5)

# 放弃修改按钮
button_discard = tk.Button(right_frame, text="放弃修改", width=10, command=discard)

button_discard_i = tk.Button(right_frame, text="放弃修改", width=10, command=discard)

button_discard_e = tk.Button(right_frame, text="放弃修改", width=10, command=discard)

# 保存修改按钮
button_save = tk.Button(right_frame, text="保存修改", width=10, command=save)

# 开始同步按钮
button_sync = tk.Button(right_frame, text="开始同步", width=10,
                        command=lambda: threading.Thread(target=sync_thread).start())

# 执行按钮
button_exec_e = tk.Button(right_frame, text="执行", width=10, command=exec_thread)

# 复选框
check_var1 = tk.IntVar()
check_var2 = tk.IntVar()
check_var3 = tk.IntVar()
check_var4 = tk.IntVar()
check_var5 = tk.IntVar()
check_var6 = tk.IntVar()
check1 = tk.Checkbutton(right_frame, text="复选框1", variable=check_var1)
check2 = tk.Checkbutton(right_frame, text="复选框2", variable=check_var2)
check3 = tk.Checkbutton(right_frame, text="复选框3", variable=check_var3)
check4 = tk.Checkbutton(right_frame, text="复选框4", variable=check_var4)
check5 = tk.Checkbutton(right_frame, text="复选框5", variable=check_var5)
check6 = tk.Checkbutton(right_frame, text="复选框6", variable=check_var6)

# 将显示框放入右侧容器中
text_area1.pack(pady=10)
text_area2.pack(pady=10)
text_area3.pack(pady=10)

# 运行界面
root.mainloop()
