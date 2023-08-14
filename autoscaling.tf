resource "aws_launch_configuration" "ec2_launch_config" {
  name_prefix   = "ec2_launch_config"
  image_id      = "ami-xxxxxxxxxxxxxxxxx"  # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              service nginx start
              aws s3 cp s3://${aws_s3_bucket.website_bucket.bucket}/ /usr/share/nginx/html/ --recursive
              EOF
}

resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "ec2_asg"
  launch_configuration = aws_launch_configuration.ec2_launch_config.name
  min_size             = 3
  max_size             = 6
  desired_capacity     = 3
  
  vpc_zone_identifier = [aws_subnet.public_subnet.id]
  
  target_group_arns = [aws_lb_target_group.ec2_target_group.arn]
}
