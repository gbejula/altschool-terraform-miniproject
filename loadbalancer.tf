resource "aws_lb" "tera-load-balancer" {
  name = "tera-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.tera-sg.id]
  subnets = [aws_subnet.tera-public-subnet1.id, aws_subnet.tera-public-subnet2.id]
  enable_deletion_protection = false
  depends_on = [ aws_instance.tera-1, aws_instance.tera-2, aws_instance.tera-3 ]
}

resource "aws_lb_target_group" "tera-target-group" {
  name = "tera-target-group"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.tera_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}


resource "aws_lb_listener" "tera-listener" {
  load_balancer_arn = aws_lb.tera-load-balancer.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tera-target-group.arn
  }
}

resource "aws_lb_listener_rule" "tera-listener-rule" {
    listener_arn = aws_lb_listener.tera-listener.arn
    priority = 1

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tera-target-group.arn
    }

    condition {
      path_pattern {
        values = ["/"]
      }
    }
}

resource "aws_lb_target_group_attachment" "tera-target-group-attachement1" {
  target_group_arn = aws_lb_target_group.tera-target-group.arn
  target_id = aws_instance.tera-1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "tera-target-group-attachement2" {
  target_group_arn = aws_lb_target_group.tera-target-group.arn
  target_id = aws_instance.tera-2.id
  port = 80
}

resource "aws_lb_target_group_attachment" "tera-target-group-attachement3" {
  target_group_arn = aws_lb_target_group.tera-target-group.arn
  target_id = aws_instance.tera-3.id
  port = 80
}