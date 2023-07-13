resource "aws_lb" "controllers" {
  count = var.controller_count > 1 ? 1 : 0

  name               = "aap-${random_id.aap_id.hex}"
  internal           = "false"
  load_balancer_type = "network"
  subnets            = aws_subnet.controller.*.id
}

resource "aws_lb_target_group" "controllers" {
  count = var.controller_count > 1 ? 1 : 0

  name        = "controller-target-group-${random_id.aap_id.hex}"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.aap_vpc.id
  depends_on  = [aws_lb.controllers]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "controllers" {
  count = var.controller_count > 1 ? 1 : 0

  load_balancer_arn = aws_lb.controllers[0].arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers[0].arn
  }
}

resource "aws_lb_target_group_attachment" "controllers" {
  count = var.controller_count > 1 ? var.controller_count : 0

  target_group_arn = aws_lb_target_group.controllers[0].arn
  target_id        = aws_instance.controller[count.index].id
}
