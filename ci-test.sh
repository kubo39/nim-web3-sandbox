#!/bin/sh

set -ex
nohup anvil --block-base-fee-per-gas=0 --gas-price=0 --balance=1000000 &
nimble run -y 
