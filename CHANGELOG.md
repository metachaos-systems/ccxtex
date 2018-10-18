# Changelog

## [0.3.0] - 2018-10-18

### Added
- `fetch_tickers` function to (perhaps, unsuprisingly) fetch all tickers from an exchange (if supported by exchange)
- `Ccxtex.OHLCVS.Opts` struct options for fetch_ohlcvs function
- `Ccxtex.Market` struct and response parsing/casting for fetch_markets results
- `Ccxtex.OHLCV` struct and response parsing/casting for fetch_ohlcvs results
- `Ccxtex.Ticker` struct and response parsing/casting for fetch_ticker and fetch_tickers results
- improved specs for all Ccxtex fns
- package published on hex.pm
- MIT license
- JS bundle

### Changed
- Switched to JavaScript Ccxt port instead of Python port
- Updated docs to match latest updates
- `fetch_exchanges()` function renamed to `exchanges()`
