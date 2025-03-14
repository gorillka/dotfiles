#!/bin/bash

printf "\n"
info "===================="
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
info "===================="