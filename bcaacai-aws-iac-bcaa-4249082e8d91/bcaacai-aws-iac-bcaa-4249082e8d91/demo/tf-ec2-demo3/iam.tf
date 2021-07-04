resource "aws_iam_role" "demo" {
  name = "demo3-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "demo" {
  name = "demo3-profile"
  role = aws_iam_role.demo.name
}

resource "aws_iam_role_policy_attachment" "ssm_instance_role_policy_attach" {
  role       = aws_iam_role.demo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ssm_automation_role_policy_attach" {
  role       = aws_iam_role.demo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

resource "aws_iam_policy" "s3_policy" {
  name        = "demo3-s3-read-policy"
  description = "Read artifact from S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
         "s3:ListObjects",
         "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
         "arn:aws:s3:::bcaa-demo-s3bucket/*",
         "arn:aws:s3:::bcaa-demo-s3bucket"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attach" {
  role       = aws_iam_role.demo.name
  policy_arn = aws_iam_policy.s3_policy.arn
}