#!/usr/bin/env bash

echo "Destroy changes to AWS Account."
echo "Enter the number of the account you want to destroy:"

options=("automation" "connect_preprod" "connect_prod")

destroy()
{
    ## SWITCH TERRAFOR WORKSPACE
    echo "Swith Terraform Workspace to $ACCOUNT..."
    terraform workspace select $ACCOUNT

    ## DELETE TERRAFORM STACK
    echo "Destroy the Terraform stack..."
    terraform destroy -var-file=env/$ACCOUNT.tfvars
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
          destroy       
          ;;
  esac
done

## RESET TO DEFAULT WORKSPACE
echo "Reset to default Terrform workspace..."
terraform workspace select default
