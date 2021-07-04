## secret_message

Collection of [packer](https://www.packer.io) templates for image management.

var-file paths can be passed on the command line e.g.

    packer build -var-file=var/us-west-2.json ubuntu_bionic_docker.json

files in `var` folder can be gitignored. Example content of var/us-west-2.json:

{
  "aws_region": "us-west-2",
  "profile": "automation",
  "subnet_id": "subnet-XXXXXXXXX",
  "vpc_id": "vpc-XXXXXXXXXXXXX"
}

You can use an AWS credentials file to specify your credentials. The default location is $HOME/.aws/credentials on Linux and OS X, or %USERPROFILE%.aws\credentials for Windows users.

"variables": {
  "AWS_SHARED_CREDENTIALS_FILE": "%USERPROFILE%.aws\credentials" 
},