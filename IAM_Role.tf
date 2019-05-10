resource "aws_iam_role" "run_inspector_role" {
  name = "cloudwatch-events-run-inspector-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
    ]
}
POLICY
}

resource "aws_iam_policy" "run_inspector_policy" {
  name        = "Cloudwatch-events-run-inspector-policy"
  description = "Cloudwatch even to run inspector"

  policy = <<POLICY
{
    "Version": "2012-10-17",
  "Statement": 
    {
    "Action": 
      "inspector:StartAssessmentRun",
    "Effect": "Allow",
    "Resource": "*"
        }
       
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "run_inspector_role" {
  role       = "${aws_iam_role.run_inspector_role.name}"
  policy_arn = "${aws_iam_policy.run_inspector_policy.arn}"
}
