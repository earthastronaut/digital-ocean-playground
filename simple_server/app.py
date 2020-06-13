import os

from flask import Flask
from flask import (
    render_template,
    request,
    make_response,
)

app = Flask('simple_server')


@app.route('/')
@app.route('/hello')
@app.route('/hello/<user>')
def index(user=None):
    print(request.headers)
    context = {
        'username': user or 'World!',
    }
    response = make_response(render_template('index.html', **context))
    response.headers.set(
        'X-Verify-Proxy', request.headers.get('X-Verify-Proxy', 'proxy_off'))
    return response


if __name__ == "__main__":
    app.run()
