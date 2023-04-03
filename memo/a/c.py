# 三行2列

#首先导入必要的Tkinter库和subprocess库，代码如下：
import tkinter as tk
import subprocess
#然后创建一个主窗口，并设置窗口大小和标题。代码如下：
root = tk.Tk()
root.geometry("500x300")
root.title("My Window App")
#接着我们创建左右两个Frame来分别放置左侧和右侧的部件。代码如下：
left_frame = tk.Frame(root)
left_frame.pack(side="left", fill="y")

right_frame = tk.Frame(root)
right_frame.pack(side="left", fill="both", expand=True)
#现在我们可以开始创建左侧的部件了。首先是三个按钮，分别为“设置”，“初始化”和“执行”。代码如下：
button1 = tk.Button(left_frame, text="设置")
button1.pack(side="top", padx=10, pady=10)

button2 = tk.Button(left_frame, text="初始化")
button2.pack(side="top", padx=10, pady=10)

button3 = tk.Button(left_frame, text="执行")
button3.pack(side="top", padx=10, pady=10)
#接下来是3行2列的6个复选框，默认勾选。代码如下：
var1 = tk.BooleanVar(value=True)
checkbutton1 = tk.Checkbutton(left_frame, text="复选框1", variable=var1)
checkbutton1.pack(side="top", padx=10, pady=5)

var2 = tk.BooleanVar(value=True)
checkbutton2 = tk.Checkbutton(left_frame, text="复选框2", variable=var2)
checkbutton2.pack(side="top", padx=10, pady=5)

var3 = tk.BooleanVar(value=True)
checkbutton3 = tk.Checkbutton(left_frame, text="复选框3", variable=var3)
checkbutton3.pack(side="top", padx=10, pady=5)

var4 = tk.BooleanVar(value=True)
checkbutton4 = tk.Checkbutton(left_frame, text="复选框4", variable=var4)
checkbutton4.pack(side="top", padx=10, pady=5)

var5 = tk.BooleanVar(value=True)
checkbutton5 = tk.Checkbutton(left_frame, text="复选框5", variable=var5)
checkbutton5.pack(side="top", padx=10, pady=5)

var6 = tk.BooleanVar(value=True)
checkbutton6 = tk.Checkbutton(left_frame, text="复选框6", variable=var6)
checkbutton6.pack(side="top", padx=10, pady=5)
# 现在我们来创建右侧的部件。根据上述要求，我们需要创建三个窗口，并根据点击按钮进行切换。我们可以使用Tkinter的Toplevel部件来创建多个窗口。代码如下：

window1 = tk.Toplevel(right_frame)
window1.title("窗口1")
window1.geometry("400x200")

window2 = tk.Toplevel(right_frame)
window2.title("窗口2")
window2.geometry("400x200")

window3 = tk.Toplevel(right_frame)
window3.title("窗口3")
window3.geometry("400x200")
#接下来我们需要定义当按钮被点击时执行的函数。代码如下：

def on_button1_click():
    with open("settings.txt", "r") as f:
        text = f.read()

    print(text)
    window1.lift()
    window1.focus_set()
    window1.attributes("-topmost", True)

def on_button2_click():
    command = window1.winfo_children()[0].get("1.0", "end-1c")
    output = subprocess.check_output(command.split(), shell=True).decode()

    text = window1.winfo_children()[0].get("1.0", "end-1c")
    window2_text.set(f"返回结果：\n{output}\n\n命令参数：\n{command}")

    window2.lift()
    window2.focus_set()
    window2.attributes("-topmost", True)

def on_button3_click():
    commands = []

    if var1.get():
        commands.append("command1")

    if var2.get():
        commands.append("command2")

    if var3.get():
        commands.append("command3")

    if var4.get():
        commands.append("command4")

    if var5.get():
        commands.append("command5")

    if var6.get():
        commands.append("command6")

    outputs = []
    for command in commands:
        output = subprocess.check_output(command.split(), shell=True).decode()
        outputs.append(f"命令：{command}\n{output}\n")

    window3_text.set("".join(outputs))
    window3.lift()
    window3.focus_set()
    window3.attributes("-topmost", True)

#我们在函数中使用了一些Tkinter的方法，比如`winfo_children()`用于获取窗口的子部件，`get()`用于获取文本框的内容，`set()`用于设置字符串变量的值。我们还定义了两个StringVar变量，用于存储窗口2和窗口3需要展示的文本信息：

    window2_text = tk.StringVar()
    window3_text = tk.StringVar()
#接下来我们将之前创建的所有部件进行布局，并绑定按钮点击事件和回车键响应事件。代码如下：

button1.config(command=on_button1_click)
button2.config(command=on_button2_click)
button3.config(command=on_button3_click)

text = tk.Text(window1)
text.pack(fill="both", expand=True)
text.insert("end", "这里是窗口1")

label2 = tk.Label(window2, textvariable=window2_text, justify="left")
label2.pack(fill="both", expand=True)

label3 = tk.Label(window3, textvariable=window3_text, justify="left")
label3.pack(fill="both", expand=True)

root.bind("<Return>", lambda event: on_button2_click())

root.mainloop()
#最后我们使用mainloop()方法来运行程序。现在您可以将上述代码复制到Python文件中并执行，即可看到一个具有所需功能的窗口程序。

