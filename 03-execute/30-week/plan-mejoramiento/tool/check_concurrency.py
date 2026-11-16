"""Real HTTP race test: requires PostgreSQL, API and two authorized parallel requests."""
import os
import getpass
import argparse
from concurrent.futures import ThreadPoolExecutor
from api_client import ApiClient
from uuid import uuid4

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--url',default='http://localhost:8000/api/v1')
    parser.add_argument('--username',default=os.getenv('ADMIN_USERNAME','admin'))
    args=parser.parse_args()
    client=ApiClient(args.url)
    client.login(args.username,os.getenv('ADMIN_PASSWORD') or getpass.getpass('Contraseña: '))
    _,cats=client.call('GET','/categories')
    ref='RACE-'+str(uuid4())[:12].upper()
    _,costume=client.call('POST','/costumes',{'name':'Traje prueba de concurrencia','designer':'Taller de pruebas','reference':ref,'category_id':cats[0]['id'],'total_units':1})
    _,customer=client.call('POST','/customers',{'full_name':'Cliente prueba concurrencia','document_number':'CON-'+str(uuid4())[:12]})
    payload={'customer_id':customer['id'],'items':[{'costume_id':costume['id']}]}
    def rent(_):return client.call('POST','/rentals',payload)[0]
    with ThreadPoolExecutor(max_workers=2) as pool: statuses=list(pool.map(rent,range(2)))
    print('Códigos recibidos:',statuses)
    assert sorted(statuses)==[201,409],f'La prueba debe terminar con 201 y 409, recibidos {statuses}'
    _,after=client.call('GET','/costumes/'+costume['id'])
    assert after['available_units']==0
    print('Concurrencia correcta: una entrega, un conflicto, cero unidades restantes.')
if __name__=='__main__':main()
