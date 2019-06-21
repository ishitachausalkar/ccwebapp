# CSYE 6225 - Summer 2019

## Team Information

| Name | NEU ID | Email Address |
| --- | --- | --- |
| Prathamesh Tambe  | 001494644 | tambe.p@husky.neu.edu |
| Jiawei Zhao | 001495711 | zhao.jiawe@husky.neu.edu  |
| Ishita Chausalkar | 001448216 | chausalkar.i@husky.neu.edu  |


## Technology Stack

To run this you need to have postman,nodejs,mysql and npm installed on your machine.


## Build Instructions

Git clone this repo on your local machine.

Run following query commands in mysql

create 'books' database in mysql and create following table in it

```
	CREATE TABLE `user` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`username` VARCHAR(255) NOT NULL,
	`password` VARCHAR(255) NOT NULL,
	`cdate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
	) ENGINE=InnoDB;
```

```
	CREATE TABLE `books`.`book` (
  	`id` VARCHAR(255) NOT NULL,
  	`title` VARCHAR(255) NOT NULL,
  	`author` VARCHAR(100) NULL,
  	`isbn` VARCHAR(255) NULL,
  	`quantity` INT NULL,
  	PRIMARY KEY (`id`));
```

To add image field in Book table run following query

```

ALTER TABLE book ADD COLUMN image VARCHAR(255) AFTER quantity;
```

To create image table with id and url run following query

```

CREATE TABLE `image` (`id` VARCHAR(255) NOT NULL,`url` VARCHAR(255) NULL);
```


and run following commands 

```
-	cd ccwebapp/webapp
-	npm install
-	node index.js	
```

and then open http://localhost:3000 on postman to check following scenarios.

1. 	Create new user by accessing http://localhost:3000/user/register with username and password in postman using content type - application/json.
	-	if user already exists then it will print user already exists.
	-	else it will create user with generating bcrypt encoded hash.

2.	When user access this http://localhost:3000 url without passing basic authentication it will return error message.
	-	if user passes valid creds then it will show current date in json response.		

3.	It satisfies all user stories required in assignment00.01 and assignment1.


and for testing run following command.

```
	mocha
```
## Running AWS Scripts
1. Running Infrastructure as Code with AWS Command Line Interface
	Go to the terminal and run the script csye6225-aws-networking-setup.sh this is AWS CLI method to create all these things. You need to type a stack name after the command.
"sh csye6225-aws-networking-setup.sh STACK_NAME"
This STACK_NAME is not a real stack name. It will be used to name the vpc to mark which vpc is just created.

csye6225-aws-networking-teardown.sh is used to delete the resources created by csye6225-aws-networking-setup.sh. You need to input a name of the VPC of whole set of resources. Here is an example:
"sh csye6225-aws-networking-teardown.sh STACK_NAME"

2. Running Infrastructure as Code with AWS CloudFormation
	csye6225-aws-cf-create-stack.sh is creating a stack on AWS CloudFormation. 
First run "sh csye6225-aws-cf-create-stack.sh"
It will ask you for a name of this stack. The other things will be done by script automatically. The default cidr block of VPC is hardcoded in csye6225-cf-networking.json: 10.0.0.0/16. Default subnet cidr block: 10.0.1.0/24, 10.0.2.0/24 and 10.0.3.0/24.
All 3 subnets will be on us-east-1a, us-east-1b and es-east-1c.

csye6225-aws-cf-terminate-stack.sh is used to delete a stack. Run command:
"sh csye6225-aws-cf-terminate-stack.sh"
It will show all stack you created on your AWS. Input a stack name to delete it.

## Deploy Instructions

Its explained in Build sections above;

## Running Tests

Implemented and checks Unit tests 

and for testing run following command.

```
	mocha
```

## CI/CD


