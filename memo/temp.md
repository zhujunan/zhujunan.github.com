```

有10台linux电脑，写一个python脚本实现以下操作：，并获取其余9台电脑的CPU与GPU占用情况。将这些改动发送到前5台占用最少的机器上，并发送指令分别在每台机器上执行这些文件


使用以下命令可以获取所有的改动文件：
git diff --name-only



您可以使用以下命令来查询Linux机器上所有GPU卡的使用情况，并按照GPU卡占用排序：
nvidia-smi | grep "^| [0-9]" | awk '{print $13,$9}' | sort -nr
该命令中，nvidia-smi 是 NVIDIA 的闭源驱动所带的命令，可显示 GPU 卡当前状态信息。grep "^| [0-9]" 取出有效的 GPU 信息；awk '{print $13,$9}' 取出该GPU卡的占用情况， $13 是 GPU 占用，$9 是 GPU 序号；最后通过 sort -nr 根据 GPU 占用从大到小排序。若您想要按照GPU卡占用从小到大排序，可以将 sort -nr 改为 sort -n



使用python脚本同时远程控制多台linux机器执行命令，并实时更新结果
您可以使用 Python 的 Paramiko 库实现远程控制多台 Linux 机器并执行命令。同时，您也可以使用 threading 库实现多线程控制同时运行多个命令的操作。以下是一个范例脚本供您参考：

import paramiko
import threading

class Worker(threading.Thread):
    def __init__(self, hostname, username, password, command):
        threading.Thread.__init__(self)
        self.hostname = hostname
        self.username = username
        self.password = password
        self.command = command

    def run(self):
        print("Connecting to %s\n" % self.hostname)

        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(self.hostname, username=self.username, password=self.password)

        print("Connected to %s\n" % self.hostname)

        print("Executing command %s\n" % self.command)

        stdin, stdout, stderr = ssh.exec_command(self.command)

        for line in stdout:
            print('Stdout: ', line.strip('\n'))

        for line in stderr:
            print('Stderr: ', line.strip('\n'))

threads = []
command = "ls -la" # 要执行的命令
hostnames = ["hostname1", "hostname2", "hostname3"] # 要远程访问的主机名列表
username = "username" # 远程访问的用户名
password = "password" # 远程访问的密码

# 创建多个线程，每个线程远程访问一个主机并执行指定命令
for hostname in hostnames:
    worker = Worker(hostname, username, password, command)
    worker.start()
    threads.append(worker)

# 等待所有线程执行完毕
for thread in threads:
    thread.join()
这个脚本会创建多个线程，每个线程负责连接一个主机并执行指定命令。线程会实时输出命令执行的结果，您可以根据自身需要修改命令和主机名列表。



=====================


您可以使用 Python 的 Paramiko 库实现远程控制多台 Linux 机器并执行命令。同时，您也可以使用 threading 库实现多线程控制同时运行多个命令的操作。以下是一个范例脚本供您参考：

import paramiko
import threading

class Worker(threading.Thread):
    def __init__(self, hostname, username, password, command):
        threading.Thread.__init__(self)
        self.hostname = hostname
        self.username = username
        self.password = password
        self.command = command

    def run(self):
        print("Connecting to %s\n" % self.hostname)

        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(self.hostname, username=self.username, password=self.password)

        print("Connected to %s\n" % self.hostname)

        print("Executing command %s\n" % self.command)

        stdin, stdout, stderr = ssh.exec_command(self.command)

        while not stdout.channel.exit_status_ready():
            # 记得要用 strip() 将末尾的换行符去掉
            stdout_line = stdout.readline().strip()
            if stdout_line:
                print('Host %s - stdout: %s' % (self.hostname, stdout_line))

        for err_line in stderr:
            print('Host %s - stderr: %s' % (self.hostname, err_line.strip()))

threads = []
command = "ls -la" # 要执行的命令
hostnames = ["hostname1", "hostname2", "hostname3"] # 要远程访问的主机名列表
username = "username" # 远程访问的用户名
password = "password" # 远程访问的密码

# 创建多个线程，每个线程远程访问一个主机并执行指定命令
for hostname in hostnames:
    worker = Worker(hostname, username, password, command)
    worker.start()
    threads.append(worker)

# 等待所有线程执行完毕
for thread in threads:
    thread.join()
这个脚本会创建多个线程，每个线程负责连接一个主机并执行指定命令。线程会实时输出命令执行的结果，您可以根据自身需要修改命令和主机名列表。注意请根据您的操作系统版本，确认您所使用的 Python 是否捆绑了 Paramiko 库，如果没有，您可以通过 pip 安装。


====================


可以使用Python的paramiko库来实现远程控制Linux机器执行ping命令并实时更新结果。具体步骤如下：

安装paramiko库
使用pip install paramiko 命令进行安装。

连接远程Linux机器
使用paramiko库的SSHClient对象连接到远程Linux机器，示例如下：

import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='remote_hostname', username='username', password='password')
执行ping命令 使用SSHClient对象的exec_command方法执行ping命令，并通过stdout读取输出结果。为了实现实时更新结果，可以将输出结果存储到文件中，然后使用tail命令实时读取文件内容。示例如下：
stdin, stdout, stderr = ssh.exec_command('ping -c 5 google.com > ping_output.txt & tail -f ping_output.txt')

for line in stdout:
    print(line.strip())
关闭SSH连接 使用SSHClient对象的close方法关闭SSH连接。示例如下：
ssh.close()
完整代码示例：

import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='remote_hostname', username='username', password='password')

stdin, stdout, stderr = ssh.exec_command('ping -c 5 google.com > ping_output.txt & tail -f ping_output.txt')

for line in stdout:
    print(line.strip())

ssh.close()


=====================

可以使用Python的subprocess模块来实现远程控制Linux机器执行ping命令，并使用watch命令实现实时更新结果。

代码示例如下：

import subprocess

# 远程机器的IP地址
remote_ip = '10.0.0.1'

# 执行ping命令并输出结果
cmd = ['ssh', 'username@{}'.format(remote_ip), 'ping', '-c', '10', 'www.baidu.com']
process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# 实时更新结果
watch_cmd = ['watch', '-n', '1', 'tail', '-n', '5']
watch_process = subprocess.Popen(watch_cmd, stdin=process.stdout)
watch_process.communicate()python
import subprocess

# 远程机器的IP地址
remote_ip = '10.0.0.1'

# 执行ping命令并输出结果
cmd = ['ssh', 'username@{}'.format(remote_ip), 'ping', '-c', '10', 'www.baidu.com']
process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# 实时更新结果
watch_cmd = ['watch', '-n', '1', 'tail', '-n', '5']
watch_process = subprocess.Popen(watch_cmd, stdin=process.stdout)
watch_process.communicate()
上述代码中，subprocess.Popen函数可以执行远程的ssh命令，并在远程机器上执行ping命令。参数stdout=subprocess.PIPE表示将输出结果通过管道传递到下一步，参数stderr=subprocess.PIPE表示将错误信息通过管道传递到下一步。

接下来，通过watch命令来实时更新结果。watch命令可以定时执行某个命令，并将结果输出到终端。参数'-n', '1'表示每隔1秒执行一次，'tail', '-n', '5'表示显示最后5行输出结果。

最后，通过watch_process.communicate()函数来获取watch命令的输出结果。

======================

import subprocess
import time

# 定义ping命令和IP地址
ping_cmd = ['ping', '-c', '4', 'google.com']

while True:
    # 执行ping命令，捕获输出
    ping_output = subprocess.Popen(ping_cmd, stdout=subprocess.PIPE).communicate()[0]
    
    # 将输出转换成字符串并打印
    ping_output_str = ping_output.decode('utf-8')
    print(ping_output_str)
    
    # 等待5秒钟后再次执行ping命令
    time.sleep(5)



```
