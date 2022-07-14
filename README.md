# Dev Ops Test 

## Requirement 
1) You will need dotnet version >= 6.0.200 [dotnet versions](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
   
## Run project 

1) open terminal
2) cd into ../devopstest dir 
3) run dotnet build 
4) run dotnet run 
5) navigate to local host output normally http://localhost:5247 but it might be different on your machine


--------------------------------------------------

#### Health Check 
##### GET: {API_URL}/
###### Response: 
```json
🧑🏽‍⚕️🐣🐣🐤🐥🐔 Hello chicks!👩🏽‍⚕️
```
#### Weather Forecast  
##### GET: {API_URL}/WeatherForecast

###### Response: 
```json
[
  {
    "date": "2022-07-06T17:40:41.1484511-07:00",
    "temperatureC": -4,
    "temperatureF": 25,
    "summary": "Chilly"
  },
  {
    "date": "2022-07-07T17:40:41.1486092-07:00",
    "temperatureC": 23,
    "temperatureF": 73,
    "summary": "Cool"
  },
  {
    "date": "2022-07-08T17:40:41.1486251-07:00",
    "temperatureC": -20,
    "temperatureF": -3,
    "summary": "Bracing"
  },
  {
    "date": "2022-07-09T17:40:41.1486254-07:00",
    "temperatureC": -2,
    "temperatureF": 29,
    "summary": "Bracing"
  },
  {
    "date": "2022-07-10T17:40:41.1486256-07:00",
    "temperatureC": 31,
    "temperatureF": 87,
    "summary": "Balmy"
  }
]
```
# Pipeline

## Prerequisites:
  - Variables pipeline
  - Script to update docker (update/update_docker.sh)

```
#!/bin/bash

/usr/local/bin/aws configure set aws_access_key_id __AWS_AK__
/usr/local/bin/aws configure set aws_secret_access_key __AWS_SK__
/usr/local/bin/aws ssm send-command --document-name "AWS-RunShellScript" --document-version "1" --targets '[{"Key":"tag:Project","Values":["Devopsjump"]}]' --parameters '{"commands":["ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ec2-user/ssh-key.pem ec2-user@__PRIVATE_IP_1__ \"aws ecr get-login-password --region sa-east-1 | docker login --username AWS --password-stdin 961106375848.dkr.ecr.sa-east-1.amazonaws.com; docker pull 961106375848.dkr.ecr.sa-east-1.amazonaws.com/__DOCKER_REPOSITORY_NAME__:__BRANCH_NAME__-__TAG__; docker stop __DOCKER_REPOSITORY_NAME__ || true && docker rm __DOCKER_REPOSITORY_NAME__ || true; docker run -e PORT=__PORT__ -p 80:__PORT__ --name __DOCKER_REPOSITORY_NAME__ -d 961106375848.dkr.ecr.sa-east-1.amazonaws.com/__DOCKER_REPOSITORY_NAME__:__BRANCH_NAME__-__TAG__\""],"workingDirectory":[""],"executionTimeout":["3600"]}' --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region sa-east-1
/usr/local/bin/aws ssm send-command --document-name "AWS-RunShellScript" --document-version "1" --targets '[{"Key":"tag:Project","Values":["Devopsjump"]}]' --parameters '{"commands":["ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ec2-user/ssh-key.pem ec2-user@__PRIVATE_IP_2__ \"aws ecr get-login-password --region sa-east-1 | docker login --username AWS --password-stdin 961106375848.dkr.ecr.sa-east-1.amazonaws.com; docker pull 961106375848.dkr.ecr.sa-east-1.amazonaws.com/__DOCKER_REPOSITORY_NAME__:__BRANCH_NAME__-__TAG__; docker stop __DOCKER_REPOSITORY_NAME__ || true && docker rm __DOCKER_REPOSITORY_NAME__ || true; docker run -e PORT=__PORT__ -p 80:__PORT__ --name __DOCKER_REPOSITORY_NAME__ -d 961106375848.dkr.ecr.sa-east-1.amazonaws.com/__DOCKER_REPOSITORY_NAME__:__BRANCH_NAME__-__TAG__\""],"workingDirectory":[""],"executionTimeout":["3600"]}' --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region sa-east-1

/usr/local/bin/aws elbv2 deregister-targets --target-group-arn __TARGET_GROUP_ARN__ --targets Id=__INSTANCE_ID_1A__ --region sa-east-1
/usr/local/bin/aws elbv2 deregister-targets --target-group-arn __TARGET_GROUP_ARN__ --targets Id=__INSTANCE_ID_2C__ --region sa-east-1

/usr/local/bin/aws elbv2 register-targets --target-group-arn __TARGET_GROUP_ARN__ --targets Id=__INSTANCE_ID_1A__,Port=__PORT__ Id=__INSTANCE_ID_2C__,Port=__PORT__ --region sa-east-1
```

## Pipeline

Variables to use in variables pipeline of Azure Devops, almost all this variable its founded on the output code of pipeline of terraform pipeline

- AWS_AK (Access Key)
- AWS_SK (Access Secret Key)
- DOCKER_REPOSITORY_NAME (Docker repository Variable)
- INSTANCE_ID_1A (Instance Id of Created EC2 in AWS)
- INSTANCE_ID_2C (Instance Id of Created EC2 in AWS)
- PORT (Port of compilation docker image, let in 80)
- PRIVATE_IP_1 (Private Ip of Created Ec2 in AWS)
- PRIVATE_IP_2 (Private Ip of Created Ec2 in AWS)
- TARGET_GROUP_ARN (Target group of Load Balancer to update Docker in that instances)
