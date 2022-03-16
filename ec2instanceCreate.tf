#Creating EC2-instance
resource "aws_instance" "instance" {
    ami  = "ami-0892d3c7ee96c0bf7"
    instance_type = "t3.medium"
    vpc_security_group_ids = ["sg-0f8389d98459212c1"]
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    key_name = "team"

    tags = {
        Name = "JumpBox"
    }
}
