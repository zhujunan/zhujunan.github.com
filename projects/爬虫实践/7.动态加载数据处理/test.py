from flask import Flask,render_template
import users

app = Flask(__name__)

@app.route('/index')
def index():
    return 'hello'

#注册蓝图
app.register_blueprint(users.user)
if __name__ == '__main__':
    app.run()