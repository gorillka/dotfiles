#!/bin/sh

export BW_SESSION=$(bw unlock --raw) && chezmoi apply
