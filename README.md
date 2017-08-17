# mp exercise

## Requirements
You have a distributed system comprised of multiple server hosts (e.g. 10-15 AWS instances). The hosts run a common task and need to have a long-running (multi-hour) maintenance-type operation run against them. The requirements are:

- The operation cannot run on more than one host at any given time
- The operation cannot run more than one instance at a time on any host
- It must log its activity for tracking purposes (to syslog and local file)
- It must report 5 metrics about its work to a DogStatsD agent running on the host, as defined in DataDog’s documentation (https://docs.datadoghq.com/guides/dogstatsd/)
- It must offer a way to abort the task gracefully (not killing the task via kill command)
- It must be self-documenting, well commented, for clarity and flow for anyone not familiar with the original specs.

## Prerequisites / Assumptions
- datadog agent running on each instance
- S3 bucket for lockfile checking
- management instance/machine with ansible installed, ssh access to all instances, and access to s3 for lockfile tracking (easily and more properly moved to instances instead via instance role)

## Usage
Invocation is like any ansible playbook.
```shell
ansible-playbook -i hosts maintenance.yml -K
```
