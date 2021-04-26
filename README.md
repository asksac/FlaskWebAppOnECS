# Overview

This project provides an example of deploying a simple [Python Flask](https://palletsprojects.com/p/flask/) based webapp on [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/ecs/) using `AWS Fargate` compute engine. Additionally, the Flask webapp makes use of _session_ to store stateful information (it uses [Flask-Session](https://flask-session.readthedocs.io/en/latest/) extension, with `SESSION_TYPE` as `filesystem`). 

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
