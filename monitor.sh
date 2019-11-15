#!/bin/sh
#This script get information about system monitoring
#First line of output show after "DIAGNOSTIC INFORMATION FROM"
#show the name of the host from which diagnostic message sent
#Next row show time system is up
#After that show running tasks number,CPU, RAM, SWAP MEMORY
#	us, user    : time running un-niced user processes
#           sy, system  : time running kernel processes
#           ni, nice    : time running niced user processes
#           id, idle    : time spent in the kernel idle handler
#           wa, IO-wait : time waiting for I/O completion
#           hi : time spent servicing hardware interrupts
#           si : time spent servicing software interrupts
#           st : time stolen from this vm by the hypervisor
# 	----------------------------------------------------
# Second part of the script show CPU temperature.
# SD card usage and capacity
# The last one show size of folder, which user can change by his choice  

echo | awk 'BEGIN {
        for (i = 0; i < 60; i++)
                arr [i] = "-"
        for (i in arr)
                printf("%s", arr[i])
        "date" | getline date
        split (date, d , " ")
                printf("\n%45s  %2s %2s\n", d [2], d [3], d [6])
        printf("DIAGNOSTIC INFORMATION FROM %s", userInfo())
}
function userInfo()

{
        "hostname" | getline host

        return  sprintf("%s\n",host)
}'

top -b -n 1 | awk '
NR < 6{

arr[3] = "CPU usage: "
arr[4] = "Memory usage(MiB): "
arr[5] = "Swap Memory usage(MiB): "
mb[4] = 1024
mb[5] = 1024

#	print($0)

	if ( NR <= 3)
	printf("%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n",arr[NR], $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
	if (NR == 4)
#	 print(arr[NR], $2, $3 / mb[NR], $4, $5 / mb[NR] ,$6 , $7 / mb[NR], $8, $9 / mb[NR], $10, $11 / mb[NR])
	 printf("%s %s %s %dMB %s %dMB %s %dMB %s %dMB\n",arr[NR], $2, $3, $4 / mb[NR], $5, $6 / mb[NR], $7, $8 / mb[NR], $9, $10 / mb[NR], $11)
	if (NR == 5)
	printf("%s %s %dMB %s %dMB %s %dMB %s %dMB %s\n",arr[NR], $2, $3 / mb[NR] , $4, $5 / mb[NR], $6, $7 / mb[NR], $8 , $9 / mb[NR], $10, $11 / mb[NR])
}
END {
        for (i = 0; i < 60; i++)
                arr [i] = "-"
        for (i in arr)
                printf("%s", arr[i])
        print("\n")}'
vcgencmd measure_temp | awk ' {$0 = substr($0, 6, 8); printf ("CPU Temperature:%2s\n", $0)}'
#This block show CPU usage
#physical memory usage(RAM)
#swap memory usage
#number of running tasks
echo

df -Bm | awk 'BEGIN {print "Filesystem 1M-blocks Available Used%"} $1 ~ /root/ {printf ("%4s %7s %10s %5s\n",$1,$2,$4, $5)}'
