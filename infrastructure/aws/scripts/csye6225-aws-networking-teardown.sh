STACK_NAME=$1
CIDRBlock_route=0.0.0.0/0

#Get a vpc-Id using the name provided
vpcId=`aws ec2 describe-vpcs --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'Vpcs[*].{id:VpcId}' --output text`

#Get a Internet Gateway Id using the name provided
gatewayId=`aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'InternetGateways[*].{id:InternetGatewayId}' --output text`

#Get a route table Id using the name provided
routeTableId=`aws ec2 describe-route-tables --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'RouteTables[*].{id:RouteTableId}' --output text`

#Get subnet123
subnet1=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${STACK_NAME}-1" --query 'Subnets[*].{id:SubnetId}' --output text`
echo $subnet1
subnet2=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${STACK_NAME}-2" --query 'Subnets[*].{id:SubnetId}' --output text`
echo $subnet2
subnet3=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${STACK_NAME}-3" --query 'Subnets[*].{id:SubnetId}' --output text`
echo $subnet3

#Get associates
associationid1=`aws ec2 describe-route-tables --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'RouteTables[*].Associations[0].RouteTableAssociationId' --output text`
associationid2=`aws ec2 describe-route-tables --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'RouteTables[*].Associations[1].RouteTableAssociationId' --output text`
associationid3=`aws ec2 describe-route-tables --filter "Name=tag:Name,Values=${STACK_NAME}" --query 'RouteTables[*].Associations[2].RouteTableAssociationId' --output text`

#Disassociate a route table
aws ec2 disassociate-route-table --association-id $associationid1
echo "subnet1 disassociate with route table"
aws ec2 disassociate-route-table --association-id $associationid2
echo "subnet2 disassociate with route table"
aws ec2 disassociate-route-table --association-id $associationid3
echo "subnet3 disassociate with route table"

#Delete the route
aws ec2 delete-route --route-table-id $routeTableId --destination-cidr-block $CIDRBlock_route
echo "Deleting the route..."

#Delete the route table
aws ec2 delete-route-table --route-table-id $routeTableId
echo "Deleting the route table-> route table id: "$routeTableId

#Detach Internet gateway and vpc
aws ec2 detach-internet-gateway --internet-gateway-id $gatewayId --vpc-id $vpcId
echo "Detaching the Internet gateway from vpc..."

#Delete the Internet gateway
aws ec2 delete-internet-gateway --internet-gateway-id $gatewayId
echo "Deleting the Internet gateway-> gateway id: "$gatewayId

#Delete subnets
aws ec2 delete-subnet --subnet-id $subnet1
aws ec2 delete-subnet --subnet-id $subnet2
aws ec2 delete-subnet --subnet-id $subnet3

#Delete the vpc
aws ec2 delete-vpc --vpc-id $vpcId
echo "Deleting the vpc-> vpc id: "$vpcId

echo "Task Completed!"
