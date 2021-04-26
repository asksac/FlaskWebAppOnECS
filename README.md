# Overview

This project provides an example of deploying a simple [Python Flask](https://palletsprojects.com/p/flask/) based webapp on [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/ecs/) using [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html) compute engine. Additionally, the Flask webapp makes use of _local session_ to store stateful information (session management is based on [Flask-Session](https://flask-session.readthedocs.io/en/latest/) extension, with `SESSION_TYPE` set to `filesystem`). 

The ECS Cluster deployed supports multiple tasks (compute nodes), and uses an Application Load Balancer (ALB) in front to evenly distribute traffic. To enable session stickiness, ALB is configured with stickiness setting (`Application-based` cookie). 

# Installation 

In order to deploy this project in your environment, you will need the following: 

- A workstation with Linux like terminal support (e.g. MacOS or Linux)
- Docker 
- Terraform CLI
- AWS Account


&nbsp;
# License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2021 &copy; Sachin Hamirwasia
