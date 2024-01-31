#architecture
arch=$(uname -a)

#physical cpu
cpuph=$(grep "physical id" /proc/cpuinfo | wc -l)

#virtual cpu
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

#RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

#mem
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

#cpul
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_oper=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_oper)

#boot
lboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#lvm
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

#tcp
tcpc=$(ss -ta | grep ESTAB | wc -l)

#ulogs
ulog=$(users | wc -w)

#net
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

#sudo
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


#print
wall "	#Architecture: $arch
	#CPU physical: $cpuph
	#vCPU: $cpuv
	#Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
	#Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	#CPU load: $cpu_fin%
	#Last boot: $lboot
	#LVM use: $lvm
	#TCP Connections: $tcpc ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmnd cmd"
