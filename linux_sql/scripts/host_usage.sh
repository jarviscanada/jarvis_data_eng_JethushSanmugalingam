
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

vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

memory_free=$(echo "$vmstat_mb" --unit M | tail -1 | awk '{print $4}')
cpu_idle=$(echo "$vmstat_mb" 1 2 | tail -1 | awk '{print $15}')
cpu_kernel=$( echo "$vmstat_mb" 1 2 | tail -1 | awk '{print $14}')
disk_io=$(echo "$vmstat_mb" --unit M -d | tail -1 | awk '{print $10}')
disk_available=$(df --output=avail -BM / | tail -1 | sed 's/M//')

timestamp=$(vmstat -t | awk '{print $18, $19}' | tail -n1 | xargs)

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_kernel, disk_io, disk_available)
SELECT 
	'$timestamp', $host_id, $memory_free, $cpu_kernel, $disk_io, $disk_available 
FROM host_info
WHERE hostname = '$hostname';
"

export PGPASSWORD=$psql_password 
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
