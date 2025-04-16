#!/bin/bash


cli="$(dirname $(realpath $0))"


package="$1"
[ -z $package ] && { echo "Error: ./cli numpy"; exit 1;}


declare -a cmds=( $(find $(echo $PATH | tr ':' ' ') -maxdepth 1 -type f -executable -regex '.*/python3\.[0-9]+' 2>/dev/null) )
declare -a whl_names=( $(curl -sL https://termux-user-repository.github.io/pypi/${package} | grep -o 'https:.*whl"' | sed 's#https.*wheels.\(.*\)"#\1#') )
declare -a pipy_names=( $(curl -sL https://pypi.org/pypi/${package}/json | jq -r '.urls[] | select(.packagetype == "bdist_wheel").filename') )


# any pip modules can help to used with check.py
for cmd in "${cmds[@]}"; do
    PYTHONPATH="$PYTHONPATH:$($cmd -c "import site; print(':'.join(site.getsitepackages() + [site.getusersitepackages()]))")"
done
export PYTHONPATH


for cmd in "${cmds[@]}"; do
    echo "--------------"
    echo "$(basename $cmd): pipy:"
    echo
    for file in "${pipy_names[@]}";do
        "${cmd}" "${cli}/check.py" "$file"
    done
    
    echo "--------------"
    echo "$(basename $cmd): https://termux-user-repository.github.io:"
    echo
    for file in "${whl_names[@]}";do
        "${cmd}" "${cli}/check.py" "$file"
    done
done
