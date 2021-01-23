# `terraform-aws-network`

This is the configuration for a basic network. The default install creates 3 tiers: public, private, and data. It spreads these tiers across (at least) 3 availability zones. It leaves a little bit of space between subnets to accomodate scaling up to 6 availability zones. Each of the availability zones has its own NAT gateway for durability from zone failure and to save cash on cross-AZ traffic. All subnets are statically defined as /21s (~2000 IPs.) Additionally, the VPC is a /16, yet the defined subnets only consume about a quarter of the available IP space; this allows one to define more subnets as needed.

The data tier has no outbound access to the public internet or inbound access from the public subnets; all updates must be accomplished through managed service administration (ie Elasticache/Elasticsearch/RDS console), swapping out AMIs (keep stateful data on separate EBS volumes), or through communication with the private subnets (ie, host your own package repositories.) If you need to communicate with AWS or other services from the data subnets, consider creating [VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) or [PrivateLinks](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/aws-privatelink.html). You can additionally use the `data_network_acl_id` output to create your own network ACL rules (though without a NAT these subnets still won't be able to access the public internet without more custom configuration.)

## Variables

### Required Variables

The following variables are required:

#### environment

Description: The environment the service is deployed to or in. Used for tagging resources; this can help identify costs.

Type:
`string`

#### vpc\_cidr

Description: The CIDR of the VPC, in slash notation.

Type:
`string`

#### zone\_ids

Description: The AWS Zone IDs of Availability Zones (datacenters) to deploy the network into. Specify 3 or more. More info [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe)

Type:
`list(string)`

### Optional Variables

The following variables are optional (have default values):

#### name

Description: The name of the deployed service. Used for tagging resources; this can help identify costs.

Type:
`string`

Default:
`"network"`

#### service

Description: The service this deployment supports. Used for tagging resources; this can help identify costs.

Type:
`string`

Default:
`"network"`

## Outputs

The following outputs are exported:

#### data\_network\_acl\_id

Description: The ID of the network ACL applied to the data subnets. Useful for defining custom network ACL rules

#### data\_subnet\_ids

Description: A list of the data subnet IDs

#### private\_subnet\_ids

Description: A list of the private subnet IDs

#### public\_subnet\_ids

Description: A list of the public subnet IDs

#### vpc\_cidr\_block

Description: The CIDR block of the created VPC

#### vpc\_id

Description: The ID of the created VPC

