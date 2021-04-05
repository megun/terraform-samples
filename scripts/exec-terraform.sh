#!/bin/bash -eu

action=$1
root_dir=$2
option=""

case ${action} in
"plan")
  dirs=$(ls -d ${root_dir}/[0-9]*/);;
"apply")
  option="-auto-approve"
  dirs=$(ls -d ${root_dir}/[0-9]*/);;
"destroy")
  option="-auto-approve"
  dirs=$(ls -dr ${root_dir}/[0-9]*/);;
esac

for dir in ${dirs}; do
  pushd ${dir}
  eval "$(direnv export bash)"

  terraform init
  terraform ${action} ${option}
  popd
done
