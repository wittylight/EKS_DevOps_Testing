## Packer Templates

Collection of [packer](https://www.packer.io) templates for image management.

var-file paths can be passed on the command line e.g.

    packer build -var-file=keys/live.json -var-file=var/us-west-2.json  xenial.json

files in keys folder are gitignored. Example content of keys/yourusername.json:

    {
      "aws_region": "us-west-2",
      "profile": "automation"
    }
