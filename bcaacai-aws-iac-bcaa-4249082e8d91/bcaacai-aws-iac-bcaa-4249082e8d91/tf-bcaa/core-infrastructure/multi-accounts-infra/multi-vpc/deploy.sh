#!/usr/bin/env bash

echo "Apply changes to AWS account."
echo "Enter the number of the AWS account you want to deploy:"

options=("automation" "connect_preprod" "connect_prod")

apply()
{
    ## SWITCH TERRAFOR WORKSPACE
    echo "Switch Terraform Workspace to $ACCOUNT..."
    terraform workspace select $ACCOUNT

    # DEPLOY TERRAFORM TO MULTI ACCOUNTS/ENVIRONMENT
    echo "Deploy Terraform $ACCOUNT..."
    #terraform apply -var-file=env/$STAGE.tfvars -auto-approve
    terraform apply -var-file=env/$ACCOUNT.tfvars
}

PS3="Please enter your choice: "

select ACCOUNT in "${options[@]}" "QUIT";
do
  case $ACCOUNT in
        "QUIT")
          echo "Exiting."
          break
          ;;
        *)
          echo "You picked $ACCOUNT ($REPLY)"
          apply       
          ;;
  esac
done

## RESET TO DEFAULT WORKSPACE
echo "Reset to default Terrform workspace..."
terraform workspace select default
