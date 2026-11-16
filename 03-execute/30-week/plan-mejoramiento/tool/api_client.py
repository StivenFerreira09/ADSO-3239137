"""Small HTTP JSON client, using only Python's standard library."""
import json
from urllib.request import Request, urlopen
from urllib.error import HTTPError

class ApiClient:
    def __init__(self, base_url, token=None):
        self.base_url = base_url.rstrip('/')
        self.token = token

    def call(self, method, path, payload=None):
        headers = {'Accept': 'application/json'}
        if self.token:
            headers['Authorization'] = f'Bearer {self.token}'
        if payload is not None:
            headers['Content-Type'] = 'application/json'
        data = json.dumps(payload).encode('utf-8') if payload is not None else None
        request = Request(
            f'{self.base_url}{path}',
            data=data,
            headers=headers,
            method=method
        )
        try:
            with urlopen(request, timeout=30) as response:
                raw = response.read()
                return response.status, json.loads(raw) if raw else {}
        except HTTPError as error:
            raw = error.read()
            try:
                body = json.loads(raw)
            except ValueError:
                body = {'message': 'Error sin cuerpo JSON.'}
            return error.code, body

    def login(self, username, password):
        status, body = self.call(
            'POST',
            '/auth/login',
            {'username': username, 'password': password}
        )
        if status != 200:
            raise RuntimeError(
                f'No se pudo iniciar sesión: {status} {body.get("message")}'
            )
        self.token = body['access_token']
