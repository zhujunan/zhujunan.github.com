#!/usr/bin/env python 
# -*- coding:utf-8 -*-
from flask import Blueprint

#user为蓝图的唯一标识
user = Blueprint('user', __name__)

@user.route('/user',methods=['POST','GET'])
def func():
    return 'this BluePrint of user func'
