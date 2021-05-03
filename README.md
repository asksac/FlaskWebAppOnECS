# Overview

This project provides a simple example of deploying a stateful webapp on [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/ecs/) and enabling sticky session based load-balancing. AWS deployment is handled through Terraform. The webapp is developed on [Python Flask](https://palletsprojects.com/p/flask/), and uses _local session_ to store stateful information. Session management is based on [Flask-Session](https://flask-session.readthedocs.io/en/latest/) extension, with `SESSION_TYPE` set to `filesystem`. ECS tasks use [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html) as the compute engine. The ECS cluster deployed in this example will create multiple tasks (default is 2), and enables auto-scalling based on average CPU utilization of tasks. An Application Load Balancer (ALB) is deployed in front of ECS cluster to evenly distribute traffic. To enable session stickiness, ALB is configured with stickiness setting (`Application-based` cookie). 

# Installation 

In order to deploy this project in your environment, you will need the following: 

- A workstation with Linux like terminal support (e.g. MacOS or Linux)
- AWS Account
- Docker 
- Terraform CLI

# License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2021 &copy; Sachin Hamirwasia
