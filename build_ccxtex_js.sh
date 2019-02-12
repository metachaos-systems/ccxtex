#! /bin/bash

webpack-cli ./js/source/main.js  -o ./priv/js/dist/main.js -p --output-library ccxtex --output-library-target commonjs --target node
