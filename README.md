# Terraform gcp vm Nginx with logs on gcs 

Create an Nginx with http and https(self signed) enabled in default page

All logs of nginx will be stored in an created google cloud storage

It will healthcheck in the end with `check.tf`

# Requirements

- gcp account with follow permissions
  - editor and ilm update or proprietary
- gcp project
- terraform (supports tfenv)
- bash (used by local-exec tests)

# Apis needed to be enabled in GCP
  If your account haven't enabled some services you will get an error with the link to follow and enable it.
 - compute engine (https://cloud.google.com/compute)
 - iam policy (https://console.developers.google.com/apis/api/iam.googleapis.com/overview)

# Credentials
  https://console.cloud.google.com/apis/credentials/serviceaccountkey
  
  Create an service account key, it could be Project -> Owner to terraform use without problems

  Create and download key as json file associated to the created account key

  Use the path in `terraform.tfvars` file

# Vars
  Start from example with `cp terraform.tfvars.example terraform.tfvars`

### Project
Project id used by automation

### Credentials File
Path of gcp credentials json file used by terraform

### SSH Pub Key File
Path of your public ssh key file to add access to vm

# Run
After setup `terraform.tfvars`, you can run it with
```
terraform apply
```

In the end of creation it will test nginx response in `check.tf`

# SSH
Access the machine by ssh with
```
ssh main@$pub_ip
```



