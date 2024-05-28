#AWS CloudWatch agent to monitor the httpdservice status

1. create an EC2 instance tyoe : T2.micro
2. create an IAM role "CloudWatchAgentServerPolicy" and attach the same to the Instance (choose Actions, Security, Modify IAM role.)
3. Configure the script to run in every 5 mins
	i. sudo yum install cronie
	ii. sudo systemctl start crond
	iii. sudo systemctl enable crond
	iv. sudo systemctl status crond
	
	crontab -e
	*/5 * * * * /home/user/sum_script.sh  [ this is to run your script in every 5 mins ]
	
	crontab -l [ this will show the details of the scripts scheduled for running ]
	
4. Install the AWS CloudWatch Agent usin command below
	sudo yum install amazon-cloudwatch-agent
		
	. Download the rpm package file (wget https://amazoncloudwatch-agent.s3.amazonaws.com/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm)
	. Install the rpm package file (sudo rpm -U ./amazon-cloudwatch-agent.rpm)
	. Before starting the CloudWatch agent prepare the configuration file (sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard)
		--> here which configuring the config.json file you should select the option for addition log file moniotoring and give the patch (here it is /home/ec2-user/httpsservice.log)
	. start the cloud-watch-agent by using the command 
		sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
	. check status of cloudWatch agent
		sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
		
5. Login to AWS and choose cloudWatch --> under log group you will find the log group created by the cloudwatch agent
6. Create an alarm by extracting the word "inactive" from the logs
7. Create an SNS topic and attach to the CloudWatch agent to trigger it when there is a breach.

###### NOTE IF THE CloudWatch Agent is not able to send the data to cloudWatch dashboad, then it might be permissions issue
	go to the path : - /opt/aws/amazon-cloudwatch-agent/bin/
		here you need to edit config.json file
			"agent": {
				"metrics_collection_interval": 60,
				"run_as_user": "cwagent" [ replace cwagent with root]
			},
reload the configuration file 
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

restart the services
	sudo systemctl restart amazon-cloudwatch-agent.service

Now you should see the log group specifyed in the config.json file is created and it is sending data to CloudWatch dashbaord
