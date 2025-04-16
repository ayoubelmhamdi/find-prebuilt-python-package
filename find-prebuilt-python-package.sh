#!/bin/bash


cli="$(dirname $(realpath $0))"

log(){
    echo "$@" >&2
}


error(){
    echo "Eror: $@" >&2
    exit 1
}


package="$1"
[ -z $package ] && error "./cli numpy"


declare -a cmds=( $(find $(echo $PATH | tr ':' ' ') -maxdepth 1 -type f -executable -regex '.*/python3\.[0-9]+' 2>/dev/null) )
declare -a whl_names=( $(curl -sL https://termux-user-repository.github.io/pypi/${package} | grep -o 'https:.*whl"' | sed 's#https.*wheels.\(.*\)"#\1#') )
declare -a pipy_names=( $(curl -sL https://pypi.org/pypi/${package}/json | jq -r '.urls[] | select(.packagetype == "bdist_wheel").filename') )


# any pip modules can help to used with check.py
for cmd in "${cmds[@]}"; do
    PYTHONPATH="$PYTHONPATH:$($cmd -c "import site; print(':'.join(site.getsitepackages() + [site.getusersitepackages()]))")"
done
export PYTHONPATH


for cmd in "${cmds[@]}"; do
    log "--------------"
    log "$(basename $cmd): pipy:"
    log
    for file in "${pipy_names[@]}";do
        "${cmd}" "${cli}/check.py" "$file"
    done
    
    log "--------------"
    log "$(basename $cmd): https://termux-user-repository.github.io:"
    log
    for file in "${whl_names[@]}";do
        "${cmd}" "${cli}/check.py" "$file"
    done
done
