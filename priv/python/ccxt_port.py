# coding=utf-8

import ccxt

import time
import ccxt
import json

def exchanges():
    exchanges = {}

    for id in ccxt.exchanges:
        exchange = getattr(ccxt, id)
        exchanges[id] = exchange()
    return exchanges

def fetch_exchanges():
    exchanges_temp = {}
    for k, v in exchanges().items():
        exchanges_temp[k] = {'timeout': v.timeout, 'id': v.id, 'has': v.has}
    return json.dumps(exchanges_temp)


def fetch_markets_for_exchange(exchange_id):
    exchange = exchanges()[exchange_id.decode('utf-8')]
    res = exchange.load_markets()
    return json.dumps(res)

def fetch_ohlcv_no_since_limit(exchange_id, symbol, timeframe):
    exchange = exchanges()[exchange_id.decode('utf-8')]
    exchange.options["warnOnFetchOHLCVLimitArgument"] = False
    if exchange.has['CORS']:
        exchange.proxy = 'http://localhost:33000/'

    res = exchange.fetch_ohlcv(symbol.decode('utf-8'), timeframe.decode('utf-8'))
    return json.dumps(res)



def fetch_ohlcv(exchange_id, symbol, timeframe, since, limit):
    exchange = exchanges()[exchange_id.decode('utf-8')]
    timeframe_str =timeframe.decode('utf-8')
    exchange.options["warnOnFetchOHLCVLimitArgument"] = False
    if exchange.has['CORS']:
        exchange.proxy = 'http://localhost:33000/'

    if since == b'nil' and limit == b'nil':
        res = exchange.fetch_ohlcv(symbol.decode('utf-8'), timeframe_str)
    elif limit == b'nil':
        res = exchange.fetch_ohlcv(symbol.decode('utf-8'), timeframe_str, since)
    else:
        res = exchange.fetch_ohlcv(symbol.decode('utf-8'), timeframe_str, since, limit)

    return json.dumps(res)
