resource "aws_eks_fargate_profile" "fargate_profile" {
    cluster_name = var.cluster_name
    fargate_profile_name = var.fargate_profile_name
    pod_execution_role_arn = aws_iam_role.pod_execution_role.arn
    
    selector {
        namespace = "default"
    }
}

resource "aws_iam_role" "pod_execution_role" {
    name = "${var.cluster_name}-eks-fargate-role"

    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Principal" : {
                    "Service" : "eks-fargate-pods.amazonaws.com"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "fargate_policy_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
    role = aws_iam_role.pod_execution_role.name
}