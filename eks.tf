resource "aws_iam_role" "team-role" {
  name = "eks-cluster-team"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Creating EKS Cluster

resource "aws_iam_role_policy_attachment" "team-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.team-role.name
}

resource "aws_iam_role_policy_attachment" "team-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.team-role.name
}

resource "aws_iam_role_policy_attachment" "team-AmazonECR_FullaccessPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.team-role.name
}

resource "aws_eks_cluster" "team" {
  name     = "team-cluster"
  role_arn = aws_iam_role.team-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public-subnet-1.id,aws_subnet.public-subnet-2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.team-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.team-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.team-AmazonECR_FullaccessPolicy,
  ]
}


# Creating the Node Group

resource "aws_eks_node_group" "node-team" {
  cluster_name    = aws_eks_cluster.team.name
  node_group_name = "Team-group"
  node_role_arn   = aws_iam_role.team.arn
  subnet_ids      = [aws_subnet.public-subnet-1.id]
  instance_types  = ["t3.medium"]
  capacity_type   = "SPOT"
  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.team-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.team-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.team-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "team" {
  name = "eks-node-group-team"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "team-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.team.name
}

resource "aws_iam_role_policy_attachment" "team-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.team.name
}

resource "aws_iam_role_policy_attachment" "team-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.team.name
}
