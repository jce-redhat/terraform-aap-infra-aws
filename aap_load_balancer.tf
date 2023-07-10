# network load balancer for SSL pass-through
resource "aws_lb" "aap_frontend" {
  name               = "aap-${random_id.aap_id.hex}"
  internal           = "false"
  load_balancer_type = "network"
  subnets            = aws_subnet.controller.*.id
}

# use TCP for SSL pass-through
resource "aws_lb_target_group" "controllers" {
  name        = "controller-target-group-${random_id.aap_id.hex}"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.aap_vpc.id
  depends_on  = [aws_lb.aap_frontend]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "controllers" {
  load_balancer_arn = aws_lb.aap_frontend.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers.arn
  }
}

resource "aws_lb_target_group_attachment" "controllers" {
  count = var.controller_count

  target_group_arn = aws_lb_target_group.controllers.arn
  target_id        = aws_instance.controller[count.index].id
}
