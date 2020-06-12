import os

from flask import Flask
from flask import (
    request, 
    jsonify,
    render_template,
)

app = Flask('simple_server')

@app.route("/")
@app.route('/hello')
@app.route('/hello/<user>')
def hello(user=None):
    context = {
        'username': user or 'world!',
    }
    return render_template('index.html', **context)

if __name__ == "__main__":
    app.run()