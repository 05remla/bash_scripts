#!/usr/bin/bash
# 05remla@gmail.com
# modified: 01MAY2024
args=$@
wait=2
num=2

function helpz() {
	echo "[P]ing [S]weep"
	echo
	echo "[+] scan multiple IPs/Nets quickly and efficiently"
	echo "[+] uses bash's builtin feature brace expansion"
	echo
	echo "[+] Usage:"
	echo "    ping_sweep.sh --help"
	echo "    ping_sweep.sh 192.168.1.{1..254}"
	echo
	echo "[+] ARGS:"
	echo "    --help    | -h   : this help dialog"
	echo "    --count=? | -c=? : number of ICMP packets to send to a host"
	echo "    --wait=?  | -w=? : time to wait for response for each ICMP packet"
	echo
	echo "[+] Examples:"
	echo "    ping_sweep.sh -c=2 -w=1 192.168.68.{1..254}"
	echo "        pings all of the below with 2x ICMP packets and only wait 1 sec for a reply to packets"
	echo "        192.168.68.1..."
	echo "        192.168.68.2..."
	echo "        192.168.68.3..."
	echo "        ..............."
	echo "        ..............."
	echo "        192.168.68.254"
	echo
	echo "    ping_sweep.sh --count=5 192.168.{1,8,68}.{100..103}"
	echo "        pings all of the below with 5x ICMP packets"
	echo "        192.168.1.100..."
	echo "        192.168.1.101..."
	echo "        192.168.1.102..."
	echo "        192.168.1.103..."
	echo "        192.168.8.100..."
	echo "        192.168.8.101..."
	echo "        192.168.8.102..."
	echo "        192.168.8.103..."
	echo "        192.168.68.100..."
	echo "        192.168.68.101..."
	echo "        192.168.68.102..."
	echo "        192.168.68.103..."
	exit
}

function check() {
    num=$1
    wait=$2
    ip=$3
    ret=$(ping -c ${num} -w ${wait} ${ip})
    test=$(echo ${ret} | grep "bytes from ${ip}" | wc -l)
    if [[ ${test} -gt 0 ]]; then
        echo "${ip} is up..."
    fi
}

export -f helpz
export -f check

if [[ $(echo ${args} | wc -w) == 0 ]]; then
    helpz
fi

for arg in ${args}
do
    case ${arg} in
        '-h'|'--help')
            helpz
            exit
        ;;
        '-c='*|'--count='*)
		    num=$(echo ${arg} | cut -d= -f2)
        ;;
        '-w='*|'--wait='*)
            wait=$(echo ${arg} | cut -d= -f2)
        ;;
    esac
done

echo ""
for arg in ${args}
do
    check ${num} ${wait} ${arg} 2>/dev/null & disown
done
