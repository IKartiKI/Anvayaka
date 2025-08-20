web: gunicorn --bind 0.0.0.0 --workers 3 AnvayakaBackend.wsgi
websocket: daphne --bind 0.0.0.0 --port $PORT AnvayakaBackend.asgi:application
