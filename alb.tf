resource "aws_lb" "gold-lb" {
name = "gold-alb"
internal = false
load_balancer_type = "application"
subnets = "${aws_subnet.public.*.id}"
security_groups = [
    aws_security_group.red_sg.id
  ]
}

resource "aws_lb_target_group" "gold-tg" {
name = "gold-alb-tg"
target_type = "instance"
port = 80
protocol = "HTTP"
vpc_id = aws_vpc.red.id
health_check {
	healthy_threshold = 5
	unhealthy_threshold = 10
	timeout = 5
	interval = 30
	path = "/"
  	}
}

resource "aws_lb_listener" "gold-listener" {
load_balancer_arn = aws_lb.gold-lb.arn
port = 80
protocol = "HTTP"
#ssl_policy        = "ELBSecurityPolicy-2016-08" 
#certificate_arn = 
default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gold-tg.arn
  }
}

