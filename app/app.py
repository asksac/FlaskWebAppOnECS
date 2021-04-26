#!/usr/bin/env pythonimport logging

import logging, json
from flask import Flask, session
from flask_session import Session

app = Flask(__name__)
app.config['SESSION_PERMANENT'] = False
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)

@app.route('/')
def hello():
  logging.debug('hello() called')
  return 'Hello, World!'

@app.route('/counter', methods = ['GET', 'POST'])
def counter():
  logging.debug('counter() called')
  new_count = 1
  if 'count' in session: 
    new_count = int(session['count']) + 1
  
  session['count'] = new_count 
  return json.dumps(dict(counter=new_count))

if __name__ == "__main__":
  # configure logger
  logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level = logging.DEBUG)

  app.run(host='0.0.0.0', port=5000)
