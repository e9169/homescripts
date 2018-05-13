#!/bin/bash

# To run as a cron job on main Kodi

curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://localhost:80/jsonrpc
