resource "aws_eks_cluster" "fastapi_cluster" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = [
            for subnet in aws_subnet.private_subnet : subnet.id
        ]
    }

    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy ]
}

resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.cluster_name}-eks-cluster-role"

    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Principal" : {
                    "Service" : "eks.amazonaws.com"
                },
                "Action" : "sts:AssumeRole"
            }
        ]

    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_node_group" "fastapi_node_group" {
    cluster_name = aws_eks_cluster.fastapi_cluster.name
    node_group_name = "${var.cluster_name}-eks-node-group-role"
    node_role_arn = aws_iam_role.eks_node_group_role.arn
    subnet_ids = [
        for subnet in aws_subnet.private_subnet : subnet.id
    ]
    scaling_config {
        desired_size = 1
        max_size = 3
        min_size = 1
    }
    depends_on = [ aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy ]
}

resource "aws_iam_role" "eks_node_group_role" {
    name = "${var.cluster_name}-eks-node-group-role"

    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Principal" : {
                    "Service" : "ec2.amazonaws.com"
                },
                "Action" : "sts:AssumeRole"
            }
        ]

    })
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_node_group_role.name
}

output "cluster_endpoint" {
    value = aws_eks_cluster.fastapi_cluster.endpoint
}

output "cluster_name" {
    value = aws_eks_cluster.fastapi_cluster.name
}