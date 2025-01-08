# terraform-k8s-staticfile
Terraform module to spin up a web-server serving provided static content

## Usage example

See [variables.tf](variables.tf) for configuration options

example.tf:
```terraform
provider "kubernetes" {
  config_path = "/var/snap/microk8s/current/credentials/client.config" # Example for MicroK8s
}

module "staticfile" {
  source = "git::https://github.com/giner/terraform-k8s-staticfile"  # Make sure to use ref to a specific commit for production

  content = "Hello, World!"
}
```

How to run:
```shell
terraform apply
kubectl get --raw /api/v1/namespaces/default/services/staticfile/proxy
# OUTPUT: Hello, World!
```
