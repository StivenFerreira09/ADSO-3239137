"""Measure real catalogue search latency; populate 5,000 costumes first."""
import argparse
import getpass
import os
import statistics
import time
from api_client import ApiClient

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--url',default='http://localhost:8000/api/v1')
    parser.add_argument('--username',default=os.getenv('ADMIN_USERNAME','admin'))
    args=parser.parse_args()
    c=ApiClient(args.url)
    c.login(args.username,os.getenv('ADMIN_PASSWORD') or getpass.getpass('Contraseña: '))
    samples=[]
    for i in range(30):
        t=time.perf_counter()
        status,_=c.call('GET',f'/costumes?q=Traje&page=1&size=20')
        assert status==200
        samples.append((time.perf_counter()-t)*1000)
    print(f'Mediana: {statistics.median(samples):.1f} ms; máximo: {max(samples):.1f} ms (30 consultas)')
    print('RNF-1 solo se puede afirmar si se mide con 5.000 trajes reales y <300ms.')
if __name__=='__main__': main()
