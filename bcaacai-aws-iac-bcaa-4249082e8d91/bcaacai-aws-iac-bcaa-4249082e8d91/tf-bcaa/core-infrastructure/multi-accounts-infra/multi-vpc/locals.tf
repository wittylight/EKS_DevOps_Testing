locals {

  account = {
    default = {
      profile       = "default"
      region        = "us-west-2"
      account_id    = "337558554106"
    }

    automation  = {
      profile       = "automation"
      region        = "us-west-2"
      account_id    = "337558554106"
    }

    connect_prod  = {
      profile       = "connect_prod"
      region        = "us-west-2"
      account_id    = "252222442117"
    }

    connect_preprod  = {
      profile       = "connect_preprod"
      region        = "us-west-2"
      account_id    = "396736509064"
    }

 }
  workspace = merge(local.account["default"], local.account[terraform.workspace])
}

