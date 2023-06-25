locals {
  # from https://access.redhat.com/articles/6695491, RHUI endpoints
  # by region for use in an egress security group
  rhui_cidr = {
    af-south-1     = "13.245.200.53/32"
    ap-east-1      = "16.163.10.93/32"
    ap-northeast-1 = "3.115.250.18/32"
    ap-northeast-2 = "15.165.134.198/32"
    ap-northeast-3 = "13.208.54.119/32"
    ap-south-1     = "3.108.120.235/32"
    ap-south-2     = "18.60.20.70/32"
    ap-southeast-1 = "18.142.30.62/32"
    ap-southeast-2 = "13.55.7.164/32"
    ap-southeast-3 = "108.136.130.8/32"
    ap-southeast-4 = "16.50.31.50/32"
    ca-central-1   = "52.60.156.187/32"
    eu-central-1   = "18.192.84.171/32"
    eu-central-2   = "16.62.16.141/32"
    eu-north-1     = "13.53.252.138/32"
    eu-south-1     = "15.160.41.163/32"
    eu-south-2     = "18.100.10.176/32"
    eu-west-1      = "52.212.206.51/32"
    eu-west-2      = "18.134.171.211/32"
    eu-west-3      = "13.37.67.206/32"
    me-central-1   = "3.28.0.199/32"
    me-south-1     = "15.184.88.24/32"
    sa-east-1      = "18.230.132.218/32"
    us-east-1      = "44.197.135.178/32"
    us-east-2      = "18.190.44.10/32"
    us-west-1      = "50.18.148.224/32"
    us-west-2      = "35.81.227.163/32"
  }
}
