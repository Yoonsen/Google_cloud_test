from dash import Dash, html
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Dash(__name__, url_base_pathname="/dashtest/")  # Back to simplest form

server = app.server

@server.before_request
def log_request_info():
    from flask import request
    logger.info(f'Received request for path: {request.path}')
    logger.info(f'Full URL: {request.url}')

app.layout = html.Div([
    html.H1('Hello World'),
    html.Div('This is a test Dash app running on Google Cloud')
])

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    logger.info(f'Starting server on port {port}')
    app.run(host='0.0.0.0', port=port, debug=False)