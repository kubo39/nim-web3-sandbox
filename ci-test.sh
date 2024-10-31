#!/bin/sh

set -ex
nohup anvil --balance 1000000 --timestamp 0 &
nimble run -y 
