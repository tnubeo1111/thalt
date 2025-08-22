# AWS EC2 (Elastic Compute Cloud)

Amazon Elastic Compute Cloud (EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers.

## Core Concepts

*   **Instances**: Virtual servers in the AWS cloud.
*   **Amazon Machine Image (AMI)**: A template that contains the software configuration (operating system, application server, and applications) required to launch your instance.
*   **Instance Types**: Various configurations of CPU, memory, storage, and networking capacity for your instances.
*   **Regions and Availability Zones (AZs)**: AWS has data centers in various physical locations worldwide (Regions). Each Region has multiple, isolated locations known as Availability Zones.

## Key Components

### Storage

*   **Elastic Block Store (EBS)**: Provides persistent block storage volumes for use with EC2 instances.
*   **Instance Store**: Provides temporary block-level storage for an instance. Data is lost when the instance is stopped or terminated.
*   **Elastic File System (EFS)**: Provides scalable file storage for use with EC2 instances.
*   **Amazon S3**: Object storage service often used with EC2 for backups and static assets.

### Networking and Security

*   **Security Groups**: A virtual firewall for your EC2 instances to control inbound and outbound traffic.
*   **Key Pairs**: Used to secure login information for instances. AWS stores the public key, and you store the private key.
*   **Elastic IP Addresses (EIPs)**: Static IPv4 addresses for dynamic cloud computing.

### Scalability and High Availability

*   **Elastic Load Balancing (ELB)**: Distributes incoming application traffic across multiple EC2 instances.
*   **Auto Scaling**: Automatically scales your EC2 capacity up or down according to conditions you define.

## Sample AWS Certified Solutions Architect - Associate (SAA) Questions for EC2

1.  A company runs a public-facing, three-tier web application in a VPC across multiple Availability Zones. The Amazon EC2 instances for the application tier, which run in private subnets, need to download software patches from the internet. However, these instances should not be directly accessible from the internet. What is the most secure and scalable solution?
    *   A) Assign Elastic IP addresses to the EC2 instances.
    *   B) Configure a NAT gateway in a public subnet.
    *   C) Configure a NAT instance in a private subnet.
    *   D) Define a custom route table with a route to an internet gateway and associate it with the private subnets.
    *(Answer: B)*

2.  An organization is using an application deployed on an Amazon EC2 instance. The application generates temporary files that are frequently accessed for the first two days after creation. After that, they are rarely used. To prevent the instance's file system from filling up, what is the most appropriate short-term workaround?
    *   A) Back up the files to Amazon S3 Standard.
    *   B) Move the files to an EC2 Instance Store.
    *   C) Back up the files to Amazon Glacier.
    *   D) Increase the size of the EBS volume.
    *(Answer: A)*

3.  A company has a high-availability architecture with an Elastic Load Balancer and multiple Amazon EC2 instances in an Auto Scaling group across three Availability Zones. They need to monitor a specific metric not available in Amazon CloudWatch by default. What kind of metric is this, and what does it require?
    *   A) A standard CloudWatch metric that needs to be enabled.
    *   B) A custom metric that requires manual setup.
    *   C) A detailed monitoring metric that is enabled on the Auto Scaling group.
    *   D) A third-party metric that requires a different monitoring service.
    *(Answer: B)*

4.  You are designing a solution for a high-performance computing (HPC) application that requires low network latency and high throughput between nodes. The application will be deployed in a single Availability Zone. How should you deploy the EC2 instances for the best internode performance?
    *   A) In a partition placement group.
    *   B) In a spread placement group.
    *   C) In a cluster placement group.
    *   D) In a load balancer placement group.
    *(Answer: C)*

5.  A customer relationship management (CRM) application runs on Amazon EC2 instances in multiple Availability Zones behind an Application Load Balancer. If one of these instances fails a health check, what will happen?
    *   A) The load balancer will stop sending requests to the failed instance.
    *   B) The load balancer will terminate the failed instance.
    *   C) The load balancer will automatically replace the failed instance.
    *   D) The load balancer will return 504 Gateway Timeout errors until the instance is replaced.
    *(Answer: A)*

6.  A company wants to run a critical application on a single EC2 instance and wants to ensure that the instance is automatically recovered if it becomes impaired due to an underlying hardware failure. What is the most cost-effective way to achieve this?
    *   A) Use an Auto Scaling group with a minimum and maximum of 1.
    *   B) Use a CloudWatch alarm to automatically reboot the instance.
    *   C) Use a dedicated host.
    *   D) Use EC2 Auto-recovery.
    *(Answer: D)*

7.  You need to launch a new EC2 instance and you want to run a script that installs security updates upon first boot. What is the best way to achieve this?
    *   A) Manually SSH into the instance after it launches and run the script.
    *   B) Use the user data field to pass the script to the instance.
    *   C) Create a custom AMI with the script pre-installed.
    *   D) Use AWS Systems Manager Run Command.
    *(Answer: B)*

8.  A company has a workload that runs on EC2 instances and requires a large amount of high-throughput, sequential I/O to a single, dedicated volume. Which EBS volume type would be the most cost-effective choice?
    *   A) General Purpose SSD (gp2)
    *   B) Provisioned IOPS SSD (io1)
    *   C) Throughput Optimized HDD (st1)
    *   D) Cold HDD (sc1)
    *(Answer: C)*

9.  You are designing an application that requires a shared file system that can be mounted by hundreds of EC2 instances simultaneously. The file system needs to be highly available and scalable. Which AWS service should you use?
    *   A) Amazon S3
    *   B) Amazon EBS
    *   C) Amazon EFS
    *   D) Amazon Storage Gateway
    *(Answer: C)*

10. A company wants to ensure that all data on their EBS volumes is encrypted at rest. What is the easiest way to achieve this for all new EBS volumes created in their account?
    *   A) Manually encrypt each new volume during creation.
    *   B) Enable EBS encryption by default for the AWS region.
    *   C) Use a third-party encryption tool.
    *   D) Store the data on S3 with server-side encryption and copy it to EBS when needed.
    *(Answer: B)*
