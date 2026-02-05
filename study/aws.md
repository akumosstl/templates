### VPC

virtual private cloud

* internet gateway

  * public subnet
  * private subnet

* security groups

  * control traffic for individual resouces

* network acls (nacols)

  * control traffic for entire sections of your network (subnets)

### cloud front

content delivery network

### elastic load balancer (elb)

auto scaling elb

### s3

buckets
-- previows version of files

### WAF

web application firewall

### route 53

dns service

### api gateway

### serveless

virtualization

### RDS

relational database service
dynamo db

### nat gateway

### cloud watch





services:

&nbsp; localstack:

&nbsp;   image: localstack/localstack:latest

&nbsp;   ports:

&nbsp;     - "4566:4566" # Default port for the LocalStack gateway

&nbsp;     - "4510-4559:4510-4559" # Optional: for individual service ports (less common in recent versions)

&nbsp;   environment:

&nbsp;     # SERVICES=s3,sqs # Optional: specify only required services for faster startup

&nbsp;     - DEBUG=1

&nbsp;     - AWS\_ACCESS\_KEY\_ID=test

&nbsp;     - AWS\_SECRET\_ACCESS\_KEY=test

&nbsp;     - AWS\_DEFAULT\_REGION=us-east-1

&nbsp;     #volumes:

&nbsp;     # Optional: mount an init script to set up resources on startup

&nbsp;     #- ./localstack-setup.sh:/etc/localstack/init/ready.d/localstack-setup.sh



