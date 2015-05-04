#!/bin/bash
# Powered by zhenglingyun for auto ssh

# TODO: Auto add entry to hosts if entry is not in hosts;
#       Check dup of alias name and hostname;



hosts=(
        #"HOST;USER;PASSWORD;ALIAS(Optional, not dup with HOST)"
        "172.16.2.197;root;111111;197"
        "172.16.2.201;root;111111;201"
        "172.16.2.205;root;111111;205"
        "172.16.2.207;root;111111;207"
        "172.16.2.208;root;111111;208"
        "172.16.2.246;root;111111;246"
        "172.16.2.249;root;111111;249"
        "10.10.56.15;zhenglingyun;zhenglingyun;15"
        "10.10.56.41;zhenglingyun;zhenglingyun;41"
        "10.10.56.47;zhenglingyun;zhenglingyun;47"
        "10.10.56.118;zhenglingyun;zhenglingyun;118"
        "10.10.56.160;zhenglingyun;zhenglingyun;160"
        "10.10.56.163;zhenglingyun;zhenglingyun;163"
)



function expect_ssh {
    expect -c "set HOST $1" -c "set USER $2" -c "set PW $3" -c '
        set timeout 10

        spawn ssh $USER@$HOST
        expect {
            "*yes/no" { send "yes\r"; exp_continue }
            "*password:" { send "$PW\r" }
        }
        interact
    '
}

function explain {
    parts=(${1//;/ })
    echo ${parts[0]} ${parts[1]} ${parts[2]}
}

function host_alias {
    parts=(${1//;/ })
    echo ${parts[3]}
}



if [ $# -eq 0 ]; then
    for i in ${!hosts[@]}; do
        echo -e $i"\t"${hosts[$i]}
    done
    read -p "Select a connection: " conn
    echo `explain ${hosts[conn]}`
    expect_ssh `explain ${hosts[conn]}`
elif [ $# -eq 1 ]; then
    exists=0
    for host in ${hosts[@]}; do
        parts=(`explain $host`)
        if [ ${parts[0]} == $1 ] || [ `host_alias $host` == $1 ]; then
            expect_ssh ${parts[*]}
            exists=1
        fi
    done
    if [ $exists -eq 0 ]; then
        echo "$1 not exists in $0, add it into $0 manually"
    fi
fi
