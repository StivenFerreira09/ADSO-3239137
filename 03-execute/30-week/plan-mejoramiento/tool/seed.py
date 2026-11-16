"""Seed demo data only through the public authenticated API (no SQL)."""
import argparse
import getpass
import os
from api_client import ApiClient

NAMES = [
    'Vestido de gala', 'Traje clásico', 'Chaqueta de ceremonia', 'Vestido de época',
    'Sombrero de teatro', 'Disfraz de pirata', 'Disfraz de astronauta', 'Vestuario folclórico',
    'Traje de danza', 'Capa de mago', 'Traje de hada', 'Vestido de princesa',
    'Traje de explorador', 'Disfraz de animal', 'Traje navideño', 'Traje de carnaval',
    'Disfraz de detective', 'Vestuario de payaso', 'Traje medieval', 'Vestido de baile',
]

def require(client, method, path, payload, expected=201):
    status, data = client.call(method, path, payload)
    if status != expected:
        raise RuntimeError(f'{method} {path}: se esperaba {expected}, llegó {status}: {data}')
    return data

def main():
    parser = argparse.ArgumentParser(description='Cargar 40 trajes, 10 clientes y 15 alquileres por API.')
    parser.add_argument('--url', default=os.getenv('API_URL', 'http://localhost:8000/api/v1'))
    parser.add_argument('--username', default=os.getenv('ADMIN_USERNAME', 'admin'))
    args = parser.parse_args()
    password = os.getenv('ADMIN_PASSWORD') or getpass.getpass('Contraseña del administrador: ')
    client = ApiClient(args.url)
    client.login(args.username, password)
    categories = require(client, 'GET', '/categories', None, expected=200)
    if len(categories) != 5:
        raise RuntimeError('La API debe contener exactamente 5 categorías.')
    costumes=[]
    for n in range(40):
        costume = require(client, 'POST', '/costumes', {
            'name': f'{NAMES[n % len(NAMES)]} {n+1:02d}',
            'designer': 'Taller Costumes',
            'reference': f'COST-{n+1:05d}',
            'category_id': categories[n % 5]['id'],
            'total_units': 2 + n % 3,
        })
        costumes.append(costume['id'])
    customers=[]
    for n in range(10):
        customer=require(client, 'POST', '/customers', {
            'full_name': f'Cliente demostración {n+1:02d}',
            'document_number': f'DEMO-{n+1:04d}',
        })
        customers.append(customer['id'])
    for n in range(15):
        require(client,'POST','/rentals',{'customer_id':customers[n%10], 'items':[{'costume_id':costumes[n]}]})
    print('Carga completada vía API: 40 trajes, 10 clientes, 15 alquileres.')
    print('Las 3 líneas vencidas no pueden crearse inmediatamente por el contrato público:')
    print('vencen a los 4 días. Para testear vencidos sin esperar, usar un reloj controlado en pruebas.')

if __name__ == '__main__':
    main()
