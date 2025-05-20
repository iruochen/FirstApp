from flask import Flask, request, jsonify
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import base64
import json
import time
import hashlib
import os

app = Flask(__name__)

# 文件路径
USER_DATA_FILE = "users.txt"
PRODUCTS_DATA_FILE = "products.txt"

# 生成sign
def generate_sign(params, timestamp):
    if 'sign' in params:
        del params['sign']
    sorted_params = sorted(params.items())
    concatenated = ''.join(f"{k}={v}" for k, v in sorted_params)
    concatenated += str(timestamp)
    print(concatenated)
    return hashlib.md5(concatenated.encode()).hexdigest()


# 用户注册re
@app.route('/register', methods=['POST'])
def register():
    timestamp = time.time()
    timestamp_params = request.json.get('timestamp')
    username = request.json.get('username')
    password = request.json.get('password')
    sign = request.json.get('sign')  # 从请求中获取加密的sign
    last_sign = generate_sign(request.json, timestamp_params)

    if last_sign != sign:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

    # 检查时间戳
    if abs(timestamp - float(timestamp_params)) > 5:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

    # 存储用户
    with open(USER_DATA_FILE, 'a') as f:
        f.write(f"{username},{password}\n")

    return jsonify({'code': '1', 'msg': '注册成功'})


# 用户登录
@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')

    # 验证用户
    with open(USER_DATA_FILE, 'r') as f:
        users = [line.strip().split(',') for line in f.readlines()]

    for user in users:
        if user[0] == username and user[1] == password:
            token = hashlib.md5((username+password+'x').encode()).hexdigest()
            response_data = {
                'code': '1',
                'msg': '登录成功',
                'data': {
                    'username': username,
                    'token': token,
                },
            }
            return jsonify(response_data)

    return jsonify({'code': '0', 'msg': '账号或密码错误'}), 401


# 获取商品列表
@app.route('/products', methods=['GET'])
def get_products():
    timestamp = time.time()
    timestamp_params = request.args.get('timestamp')
    sign =  request.args.get('sign')
    print(timestamp_params)
    print(sign)

    last_sign = generate_sign({'timestamp': timestamp_params}, timestamp_params)

    if last_sign != sign:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

    # 检查时间戳
    if abs(timestamp - float(timestamp_params)) > 5:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

   # 从文件中读取商品
    if os.path.exists(PRODUCTS_DATA_FILE):
        with open(PRODUCTS_DATA_FILE, 'r') as f:
            lines = f.readlines()
            
            # 如果文件为空，返回空数组
            if not lines:
                product_list = []
            else:
                products = [line.strip().split('|') for line in lines]
                product_list = [{'id': idx, 'name': item[0], 'price': item[1], 'cover': item[2],'desc': item[3]} for idx, item in enumerate(products)]
    else:
        product_list = []


    return jsonify({'data': product_list, 'code': '1', 'msg':'请求成功'})


# 提交商品信息
@app.route('/submit_product', methods=['POST'])
def submit_product():
    timestamp = time.time()
    timestamp_params = request.json.get('timestamp')

    name = request.json.get('name')
    price = request.json.get('price')
    cover = request.json.get('cover')
    desc = request.json.get('desc')
    sign = request.json.get('sign')  # 从请求中获取加密的sign
    last_sign = generate_sign(request.json, timestamp_params)

    if last_sign != sign:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

    # 检查时间戳
    if abs(timestamp - float(timestamp_params)) > 5:
        return jsonify({'code': '0', 'msg': '签名错误'}), 400

    # 存储商品
    with open(PRODUCTS_DATA_FILE, 'a') as f:
        f.write(f"{name}|{price}|{cover}|{desc}\n")

    return jsonify({'code': '1', 'msg': '提交成功'})


if __name__ == '__main__':
    if not os.path.exists(USER_DATA_FILE):
        open(USER_DATA_FILE, 'w').close()

    if not os.path.exists(PRODUCTS_DATA_FILE):
        open(PRODUCTS_DATA_FILE, 'w').close()

    app.run(host='0.0.0.0', port='6000')