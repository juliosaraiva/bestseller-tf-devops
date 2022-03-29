# Bestseller Terraform Module

This Terraform module will provision an environment with AutoScaling group provision a ec2 instance and will scale based on CPU Usage.
There are 4 networks, 2 privates and 2 public and it's possible to access the web page only from the load balancer endpoint.


## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.54.0 |


## Usage

Create a [Terraform Cloud](https://cloud.hashicorp.com/products/terraform) account.

After create your account, you should create an organization and then a workspace.

Login into your terraform cloud account, then copy the token and paster on the cli.

```
$ terraform login
```

Run terraform init to install dependencies from module.

```
$ terraform init
```

## Outputs
|Name|Description|
|----|-----------|
|load_balancer_endpoint|Show the URL to access nginx|
