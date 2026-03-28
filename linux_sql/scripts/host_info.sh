
#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi 


hostname=$(hostname -f)
lscpu_out=$(lscpu)
vmstat_mb=$(vmstat --unit M)

cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "Model\sname:" | awk -F: '{print $2}' | xargs)
l2_cache=$(echo "$lscpu_out" | egrep "^L2\scache" | awk -F: '{print $2}' | awk '{print $1}' | xargs)
total_mem=$(echo "$vmstat_mb" | tail -n1 | awk '{print $4}' | xargs)

cpu_ghz=$(echo "$lscpu_out" | grep "Model\sname" | awk -F '@' '{print $2}' | awk '{print $1}' | tr -d 'GHz')
cpu_mhz=$(echo "$cpu_ghz" | awk '{print $1 * 1000}')


timestamp=$(vmstat -t | awk '{print $18, $19}' | tail -n1 | xargs)


insert_stmt="INSERT INTO host_info(id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES(DEFAULT, '$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, '$timestamp', $total_mem);"


export PGPASSWORD=$psql_password 
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
