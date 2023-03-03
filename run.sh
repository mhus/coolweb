#!/bin/sh
cd $(dirname -- "$0")

docker compose build && docker compose up
