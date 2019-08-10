aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE||CREATE_IN_PROGRESS||REVIEW_IN_PROGRESS||DELETE_IN_PROGRESS||DELETE_FAILED||UPDATE_IN_PROGRESS||DELETE_COMPLETE

echo "Enter name of stack you want to create"
read Stack_Name

echo "Enter Bucket Name for Code Deploy"
read codedeploybucket

echo "Enter Bucket Name for sotring Images"
read ImageBucket

echo "Displaying all keys!"
aws ec2 describe-key-pairs
echo -e "\n"
echo "Choose 1 Key which you want to use!"
read KEY_CHOSEN

echo "Displaying AMI!"
aws ec2 describe-images --owners self --query 'Images[*].{ID:ImageId}'
echo -e "\n"
echo "Enter AMI ID"
read amiId

echo "Displaying names of stacks already exist:"
aws cloudformation describe-stacks --query 'Stacks[*].StackName'
echo -e "\n"
echo "Which stack you want to base your app on, input its name"
read pStackName

vpcId=$(aws cloudformation describe-stack-resources --stack-name $pStackName --query 'StackResources[?ResourceType==`AWS::EC2::VPC`].[PhysicalResourceId]' --output text)
echo "Your app is based on: Stack" $pStackName " and VPC " $vpcId

vpcname=$(aws ec2 describe-vpcs --vpc-ids ${vpcId} --query 'Vpcs[*].Tags[?Key==`Name`].[Value]' --output text)


subnet1=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${vpcname}-public-az1" --query 'Subnets[*].{id:SubnetId}' --output text`
echo "Subnet1:"
echo $subnet1
subnet2=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${vpcname}-public-az2" --query 'Subnets[*].{id:SubnetId}' --output text`
echo "Subnet2:"
echo $subnet2
subnet3=`aws ec2 describe-subnets --filter "Name=tag:Name,Values=${vpcname}-public-az3" --query 'Subnets[*].{id:SubnetId}' --output text`
echo "Subnet3:"
echo $subnet3



getStackStatus() {
	aws cloudformation describe-stacks \
		--stack-name $Stack_Name \
		--query Stacks[].StackStatus \
		--output text
}

waitForState() {
	local status

	status=$(getStackStatus $1)

	while [[ "$status" != "$2" ]]; do

		echo "Waiting for stack $1 to obtain status $2 - Current status: $status"
		
		if [[ "$status" != *"_IN_PROGRESS"* ]]; then
			exitWithErrorMessage "Unexpected status '$status'"
		fi

		status=$(getStackStatus $1)
		sleep 30

	done

	echo "Stack $1 obtained $2 status"

}


exitWithErrorMessage() {
	echo "ERROR: $1"
	exit 1
}


dir_var=$(pwd)
# echo "Current Directory is '$dir_var'"
file_dir_var="file://$dir_var/csye6225-cf-application.json"


aws cloudformation create-stack \
	--stack-name $Stack_Name  \
	--template-body $file_dir_var \
        --capabilities CAPABILITY_NAMED_IAM \
	--parameters ParameterKey="keyname",ParameterValue=$KEY_CHOSEN ParameterKey="AmiId",ParameterValue=$amiId 		ParameterKey="subnet1",ParameterValue=$subnet1 ParameterKey="subnet2",ParameterValue=$subnet2 ParameterKey="subnet3",ParameterValue=$subnet3 ParameterKey="vpcId",ParameterValue=$vpcId ParameterKey="vpcname",ParameterValue=$vpcname ParameterKey="NameTag",ParameterValue=$Stack_Name ParameterKey="webappbucket",ParameterValue=$ImageBucket ParameterKey="codedeploybucket",ParameterValue=$codedeploybucket \
	--disable-rollback


if ! [ "$?" = "0" ]; then

	exitWithErrorMessage "Cannot create stack ${Stack_Name}!"

fi

#Wait for completion
waitForState ${Stack_Name} "CREATE_COMPLETE"
