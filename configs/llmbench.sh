#!/bin/bash

readonly cur_dir="$(readlink -f "$(dirname "$0")")"

set -x
mkdir results

pushd ~/work/AI-benchmarking-guide

# Update git and rebuild engines to support larger context
git fetch --all
#git reset --hard c62a174a65a94a697985ff8018f26838629c22df
git reset --hard fc667f35c147ad203225bda2813081954c9ebb84 # smaller models w/o --use_paged_context_fmha enable
git log --oneline -5

git status
sudo  rm -rf engines/*

mv results results-old.$(date +%s)
mkdir results

. load_env.sh

cp $cur_dir/config-base.json config.json
timeout 2h ./run_llmbench.sh

cp $cur_dir/config-tp1-lat.json config.json
timeout 1h ./run_llmbench.sh

cp $cur_dir/config-tp2-lat.json config.json
timeout 1h ./run_llmbench.sh

cp $cur_dir/config-tp4-lat.json config.json
timeout 1h ./run_llmbench.sh

cp $cur_dir/config-tp8-lat.json config.json
timeout 2h ./run_llmbench.sh

popd

cp -rv  /opt/dlami/nvme/ubuntu-work/AI-benchmarking-guide/results/* results/ 
