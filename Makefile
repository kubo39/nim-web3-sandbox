
.PHONY: build-sol
build-sol:
	solc --abi --bin --pretty-json --optimize --overwrite -o contractsBuild/ contracts/*

.PHONY: run-anvil
run-anvil:
	anvil --block-base-fee-per-gas=0 --gas-price=0 &
