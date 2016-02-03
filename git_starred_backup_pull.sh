#!/bin/bash
GIT_DIR="/home/user/work/git/"

for d in $GIT_DIR/*/ ; do
    git -C $d pull
done
