resource "aws_autoscaling_group" "web_asg" {
  name                      = "csye6225-asg"
  max_size                  = 5
  min_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  health_check_type         = "EC2"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "WebApp-ASG"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}