conda笔记
***

## conda基本操作

* 查看conda版本

```
conda --version
```

## conda环境管理

* 列出当前所有环境

```
conda info –envs
conda env list
```

* 创建环境

```
conda create --name python=3.5 numpy
conda create --name XXX --clone XXXX
```

* 进出 / 退出环境

```
activate / deactivate
```

* 删除环境

```
conda remove --name XXX --all
```

## conda包管理

* 安装

```
conda install
```

* 查看包列表, -n 指定conda

```
conda list -n base
```

* 删除包, -n 指定conda

```
conda remove -n base numpy
```
