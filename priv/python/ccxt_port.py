import time
import ccxt  
import json

def exchanges(): 
    exchanges = {}  

    for id in ccxt.exchanges:
        exchange = getattr(ccxt, id)
        exchanges[id] = exchange()
    return exchanges


def fetch_markets_for_exchange(exchange_id):
    res = exchanges()[exchange_id].load_markets()
    return json.dumps(res)
