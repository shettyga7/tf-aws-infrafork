resource "aws_autoscaling_policy" "scale_up" {
  name                    = "scale-up-policy"
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                    = "scale-down-policy"
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"
}