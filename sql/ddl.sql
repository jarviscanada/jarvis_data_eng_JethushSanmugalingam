
CREATE TABLE IF NOT EXISTS public.host_info
(
    id               SERIAL NOT NULL,        
    hostname         VARCHAR NOT NULL,         
    cpu_number       INT2 NOT NULL,           
    cpu_architecture VARCHAR NOT NULL,        
    cpu_model        VARCHAR NOT NULL,        
    cpu_mhz          FLOAT8 NOT NULL,         
    l2_cache         INT4 NOT NULL,           
    total_mem        INT4 NULL,               
    "timestamp"      TIMESTAMP NULL,          
    CONSTRAINT host_info_pk PRIMARY KEY (id),
    CONSTRAINT host_info_un UNIQUE (hostname)
);

INSERT INTO host_info
(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, "timestamp")
VALUES
('jrvs-remote-desktop-centos7-6.us-central1-a.c.spry-framework-236416.internal',
 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324, '2019-05-29 17:49:53')
ON CONFLICT (hostname) DO NOTHING;

INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, "timestamp")
VALUES
('noe1', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324, '2019-05-29 17:49:53')
ON CONFLICT (hostname) DO NOTHING;

INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, "timestamp")
VALUES
('noe2', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324, '2019-05-29 17:49:53')
ON CONFLICT (hostname) DO NOTHING;

CREATE TABLE IF NOT EXISTS public.host_usage
(
    "timestamp"    TIMESTAMP NOT NULL,
    host_id        INT NOT NULL,           
    memory_free    INT4 NOT NULL,
    cpu_idle       INT2 NOT NULL,
    cpu_kernel     INT2 NOT NULL,
    disk_io        INT4 NOT NULL,
    disk_available INT4 NOT NULL,
    CONSTRAINT host_usage_host_info_fk FOREIGN KEY (host_id) REFERENCES host_info(id)
);

INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES
('2019-05-29 15:00:00', 1, 300000, 90, 4, 2, 3)
ON CONFLICT DO NOTHING;

INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES
('2019-05-29 15:01:00', 1, 200000, 90, 4, 2, 3)
ON CONFLICT DO NOTHING;
