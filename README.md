#**Introduction**
This project has a strong focus on Linux, bash scripts, and SQL, with a bit of Docker. As Jarvis has a Linux Cluster Administration (LCA) team that manages a Linux cluster of 10 nodes/servers running Rocky Linux, and these servers are internally connected through a switch, and are able to communicate through internal IPv4 addresses. The technologies I used for this project are: Bash to develop scripts for automated data collection, PostgreSQL: used for storing usage metrics, Git: version control for managing and tracking changes to scripts and files. Linux: Target platform for running the monitoring scripts and collecting metrics. 

#**Quick Start**
## Start a psql instance using psql_docker.sh 
```Bash
    ./psql_docker.sh

#**Create tables using ddl.sql**
psql -h <host> -p <port> -U <username> -d <database> -f ddl.sql

**Insert hardware specs data into the DB using host_info.sh**
./host_info.sh <psql_host> <psql_port> <db_name> <psql_user> <psql_password>

**Insert hardware usage data into the DB using host_usage.sh**
./host_usage.sh <psql_host> <psql_port> <db_name> <psql_user> <psql_password>

**crontab setup**
crontab -l
# Example: run every minute
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
 
#**Implementation**
Built a monitoring system for servers that collects two types of data:
**`host_info.sh`** collects the host hardware info and inserts it into the database
**`host_usage.sh`** collects the current host usage (CPU and Memory) and inserts into the database

The postgreSQL database is managed through Docker using 'psql_docker.sh'. The table structures are defined in `ddl.sql', which creates the schema.

**Key takeaways in the implementation**
- Collect hardware and usage data via Bash scripts.
- Store the data in PostgreSQL for querying and analysis.
- Automate usage collection using crontab
- Maintain scripts under Git 

**Architecture**
![Cluster Diagram](./assets/cluster_diagram.png) 

**Scripts**
### 1. `psql_docker.sh`
Starts a PostgreSQL database in a Docker container - Provides a consistent database environment to store all collected monitoring data 
```bash
# Run the script to start PostgreSQL
./psql_docker.sh

### 2. `host_info.sh`
Run the script to collect hardware specs - Automates the collection of hardware specifications, eliminating manual tracking of server configurations 
./host_info.sh

### 3. `host_usage.sh
Run the script to collect usage metrics - helps detect bottlenecks and optimize server operations 
./host_usage.sh

### 4. `crontab`
Automates the periodic execution of monitoring scripts - ensures regular collection of usage metrics without manual effort.
crontab -l

**Database Modelling**
### host_info
Stores static hardware information for each Linux host.

| Column Name    | Data Type | Description                             |
|----------------|-----------|-----------------------------------------|
| host_id        | INT       | Unique identifier for each host         |
| hostname       | TEXT      | Name of the Linux host                  |
| cpu            | TEXT      | CPU model/type                           |
| ram            | INT       | Total RAM in MB                           |
| disk           | INT       | Total disk space in GB                   |
| os             | TEXT      | Operating system version                 |
| created_at     | TIMESTAMP | Time the record was inserted             |

### host_usage
Stores dynamic usage metrics collected periodically.

| Column Name    | Data Type | Description                             |
|----------------|-----------|-----------------------------------------|
| usage_id       | INT       | Unique identifier for each usage record |
| host_id        | INT       | References the host in `host_info`      |
| cpu_usage      | FLOAT     | CPU usage percentage                     |
| memory_usage   | FLOAT     | Memory usage percentage                  |
| disk_usage     | FLOAT     | Disk usage percentage                    |
| timestamp      | TIMESTAMP | Time when metrics were collected         |

**Test**
### 1. `psql_docker.sh`
Ran the script to start a PostgreSQL Docker

### 2. `ddl.sql`
Executed the SQL script to create the `host_info` and `host_usage` tables

### 3. `host_info.sh`
Ran the script on a linux host to collect hardware information

**Deployment**
**GitHub**
   - The project code, including all Bash scripts, DDL, and documentation, is stored in a GitHub repository for version control and collaboration.

**Improvements**
This module for me was very challenging, but it taught me a lot of lessons. Certain areas, I want to improve on are:
1. **Attention to Detail**  
   I realized that missing small instructions or steps slowed down my workflow. Improving attention to detail will help me implement solutions more efficiently and reduce errors.

2. **Debugging Skills**  
   I encountered issues with file paths, script execution, and database connections. These challenges reinforced the importance of careful debugging, error investigation, and verifying assumptions before making changes. I plan to improve by using more systematic debugging methods and logging.

3. **Script Automation & Testing**  
   While the Bash scripts worked as intended, I want to enhance testing practices, including better logging and error handling to make the monitoring system more robust.
