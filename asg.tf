resource "aws_autoscaling_group" "red-asg" {
  name                      = "red-asg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  #health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.red-lc.name
  vpc_zone_identifier       = "${aws_subnet.public.*.id}"
}

resource "aws_launch_configuration" "red-lc" {
  name                 = "web-server"
  image_id             = data.aws_ami.ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.red_iam_instance_profile.name
  security_groups      = [aws_security_group.red_sg.id]
  user_data            = data.template_file.userdata.rendered
}

# IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "red_iam_instance_profile" {
  name = "red-iam_instance_profile"
  role = aws_iam_role.red-iam-role.name
  }

  resource "aws_iam_role" "red-iam-role" {
  name               = "red_iam_role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}