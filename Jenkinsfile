pipeline {
	       tools {
	              maven 'Maven-3'
	              jdk 'Java-8'
	       }
	       
	       agent any 
	  
	       stages {
	              stage ('Build') {
	                     steps {
	                           echo 'In Compile'
	                           sh 'mvn clean install'
	                     }
	                     post {
	                           success {
	                                  emailext attachLog: true, 
	                                  body: "Jenkins Build Successful.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}</br>",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Jenkins Build Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                                  
									script {
	                                         def issue = [fields: [ project: [key: 'NM'],
	                                         summary: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])",
	                                         description: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])",
	                                         issuetype: [name: 'Bug'],
	                                                priority: [name: 'P1-High'],
	                                                assignee:[name:'Kunal.Pise']]]
	                                                def newIssue = jiraNewIssue issue: issue, site: 'HomeServices Cloud Jira'
	                                                echo newIssue.data.key
	                                                
	                                                /*jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kyle.Werve'
	                                                jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Punit.Shah'*/
	                                                jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kunal.Pise'
	                                                jiraLinkIssues inwardKey: "${newIssue.data.key}", outwardKey: 'NM-91', site: 'HomeServices Cloud Jira', type: 'Is linked to'
	                                                
	                                                /*jiraAssignIssue idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Santosh.Narate'*/
	                                   }
	                           }
	                     }
	              }
	              
	              stage ('UT-Code Analysis') {
	                     steps {
	                           echo 'In Compile'
	                           sh 'mvn test -P dev'
	                           sh 'mvn sonar:sonar'
	                           echo 'In Checkmarx Security Scan Phase'  
				              
	                     }
	                     post {
	                           success {
	                                  archive "target/**/*"
	                                  junit 'target/surefire-reports/*.xml'
	                                  
	                                  emailext attachLog: true, 
	                                  body: "Unit Testing Successful For.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}</br></br><B>Please find sonar dashboard for this build at: </B>http://10.232.81.231:9000/dashboard?id=net.petrikainulainen.spring%3Aspring-test-mvc-rest",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Unit Testing Successful - Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                                  
	                                  script {
			                                  try {
			                                         sh 'docker stop spring-mvc-rest-dev'
			                                         sh 'docker rm -f spring-mvc-rest-dev' 
			                                         sh 'docker image rm -f spring-mvc-rest-dev'
			                                  } catch(Exception e) {
			                                         echo 'No Docker image "spring-mvc-rest-dev" found..'
			                                  }
			                           
			                           
				                           sh 'cd /opt/docker' 
				                           sh 'docker build -t spring-mvc-rest-dev .' 
				                           sh 'docker build --tag=dev-env .'
				                           sh 'docker container  run -d --name spring-mvc-rest-dev -p 8390:8080 spring-mvc-rest-dev'
				                           echo 'Dev Environment image created successfully!!!'
				                           
				                           input ('Does Code review pass through?')
				                           
				                           sh 'docker stop spring-mvc-rest-dev'
			                               sh 'docker rm -f spring-mvc-rest-dev' 
			                               sh 'docker image rm -f spring-mvc-rest-dev'
			                           }
	                                  
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Unit Testing Failed For.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Unit Testing Failed For Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                                  
					   				script {
	                                	def issue = [fields: [ project: [key: 'NM'],
	                                  	summary: "Unit Tests Failed for Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])",
	                                  	description: "Unit Tests Failed for Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])",
	                                  	issuetype: [name: 'Bug'],
	                                  	priority: [name: 'P1-High'],
	                                  	assignee:[name:'Kunal.Pise']]]
	                                  	def newIssue = jiraNewIssue issue: issue, site: 'HomeServices Cloud Jira'
	                                  	echo newIssue.data.key
	                                                
		                                  /*jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kyle.Werve'
		                                  jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Punit.Shah'*/
		                                  jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kunal.Pise'
		                                  jiraLinkIssues inwardKey: "${newIssue.data.key}", outwardKey: 'NM-91', site: 'HomeServices Cloud Jira', type: 'Is linked to'
		                                  /*jiraAssignIssue idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Santosh.Narate'*/
	                                   }
	                           }
	                     }
	              }
	              stage('Manual Code Review') {
	                     steps {
	                           echo 'In Manual Code Review'
	                           
	                           script {
	                               def publisher = LastChanges.getLastChangesPublisher null, "SIDE", "LINE", true, true, "", "", "", "", ""
	                               publisher.publishLastChanges()
	                               def changes = publisher.getLastChanges()
	                               def diff = changes.getDiff()
	                               writeFile file: 'build.diff', text: diff
	                               emailext (
	                                 subject: "Code Review Scheduled with you for '${env.JOB_NAME} #${env.BUILD_NUMBER}'",
	                                 attachmentsPattern: '**/*.diff',
	                                 mimeType: 'text/html',
	                                 body: """<p>See attached diff of '${env.JOB_NAME} [${env.BUILD_NUMBER}]'.:</p>
	                                  <p>Check rich diff at <a href="${env.BUILD_URL}/last-changes">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
	                                 to: "Santosh.Narate@searshc.com"

	                               )
	                                  
	                                  def issue = [fields: [ project: [key: 'NM'],
	                                  summary: "Code Review for Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])",
	                                  description: """Code Review for Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}]).
					  	Please find Code differences for review at "${env.BUILD_URL}/last-changes" """,
	                                  issuetype: [name: 'Task'],
	                                  priority: [name: 'P1-High'],
	                                  assignee:[name:'Kunal.Pise']]]
	                                  def newIssue = jiraNewIssue issue: issue, site: 'HomeServices Cloud Jira'
	                                  echo newIssue.data.key
	                                                
	                                  /*jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kyle.Werve'
	                                  jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Punit.Shah'*/
	                                  jiraAddWatcher idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Kunal.Pise'
	                                  jiraLinkIssues inwardKey: "${newIssue.data.key}", outwardKey: 'NM-91', site: 'HomeServices Cloud Jira', type: 'Is linked to'
	                                                
	                                  /*jiraAssignIssue idOrKey: "${newIssue.data.key}", site: 'HomeServices Cloud Jira', userName: 'Santosh.Narate'*/
	
	                           }
	                           input ('Does Code review pass through?')
	                     }
	              }
	              stage('Creating QA Env') {
	                     steps {
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-qa'
	                                         sh 'docker rm -f spring-mvc-rest-qa' 
	                                         sh 'docker image rm -f spring-mvc-rest-qa'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-qa" found..'
	                                  }
	                           }
	                           
	                           sh 'cd /opt/docker' 
	                           sh 'docker build -t spring-mvc-rest-qa .' 
	                           sh 'docker build --tag=qa-env .'
	                           sh 'docker container  run -d --name spring-mvc-rest-qa -p 8090:8080 spring-mvc-rest-qa'
	                           echo 'QA Environment image created successfully!!!'
	                     }
	                     post {
	                           success {
	                                  echo 'QA Docker image Creation is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "QA Docker image creation Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "QA Docker image creation Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }             
	              stage ('Functional Testing') {
	                     steps {
	                           echo 'Performing Automated functional Testing'
	                           input ('Does the Functional testing pass through?')
	                     }
	                     post {
	                           success {
	                                  echo 'Functional Testing successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Functional Testing failed ... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Functional Testing Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('Regression Testing') {
	                     steps {
	                           echo 'Regression Testing on QA environment'
	                           
	                           
	                     }
	                     post {
	                           success {
	                                  echo 'Regression Testing successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Regression Testing failed ... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Regression Testing Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              
	              stage ('Integration Testing') {
	                     steps {
	                           echo 'Integration Testing on QA environment'
	                           sh 'mvn verify -P integration-test'
	                           
	                           
	                     }
	                     post {
	                           success {
	                                  echo 'Integration Testing successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Integration Testing failed ... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Integration Testing Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('Clean-up of QA Env') {
	                     steps {
	                           echo 'Cleaning up QA environment'
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-qa'
	                                         sh 'docker rm -f spring-mvc-rest-qa' 
	                                         sh 'docker image rm -f spring-mvc-rest-qa'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-qa" found'
	                                  }
	                           }
	                     }
	                     post {
	                           success {
	                                  echo 'QA Docker image deletion is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "QA Docker image deletion Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "QA Docker image deletion Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage('Creating UAT Env') {
	                     steps {
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-uat'
	                                         sh 'docker rm -f spring-mvc-rest-uat' 
	                                         sh 'docker image rm -f spring-mvc-rest-uat'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-uat" found'
	                                  }
	                           }
	                           sh 'cd /opt/docker' 
	                           sh 'docker build -t spring-mvc-rest-uat .' 
	                           sh 'docker build --tag=spring-mvc-rest-uat .'
	                           sh 'docker container  run -d --name spring-mvc-rest-uat -p 8190:8080 spring-mvc-rest-uat'
	                           echo 'UAT Environment image created successfully!!!'
	                     }
	                     post {
	                           success {
	                                  echo 'UAT Docker image Creation is successful...'
	                                  
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "UAT Docker image creation Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "UAT Docker image creation Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('UAT Testing') {
	                     steps {
	                           echo 'Performing UAT Testing'
	                           input ('Does the UAT testing pass through?')
	                     }
	                     post {
	                           success {
	                                  echo 'UAT Testing is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "UAT Testing Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "UAT Testing Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('Clean-up of UAT Env') {
	                     steps {
	                           echo 'Cleaning up QA environment'
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-uat'
	                                         sh 'docker rm -f spring-mvc-rest-uat' 
	                                         sh 'docker image rm -f spring-mvc-rest-uat'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-uat" found'
	                                  }      
	                           }
	                     }
	                     post {
	                           success {
	                                  echo 'UAT Docker image deletion is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "UAT Docker image deletion Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "UAT Docker image deletion Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage('Creating Staging Env') {
	                     steps {
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-stage'
	                                         sh 'docker rm -f spring-mvc-rest-stage' 
	                                         sh 'docker image rm -f spring-mvc-rest-stage'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-stage" found'
	                                  }
	                           }
	                           sh 'cd /opt/docker' 
	                           sh 'docker build -t spring-mvc-rest-stage .' 
	                           sh 'docker build --tag=spring-mvc-rest-stage .'
	                           sh 'docker container  run -d --name spring-mvc-rest-stage -p 8290:8080 spring-mvc-rest-stage'
	                           echo 'UAT Environment image created successfully!!!'
	                     }
	                     post {
	                           success {
	                                  echo 'Staging Docker image Creation is successful...'
	                           }
	                           failure {
	                                   emailext attachLog: true, 
	                                  body: "Staging Docker image creation Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                   from: 'Santosh.Narate@searshc.com',
	                                  subject: "Staging Docker image creation Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('Stage - Regression Testing') {
	                     steps {
	                           echo 'Performing Regression Testing on Staging Environment.'
	                           input ('Does the Stage Regression testing pass through?')
	                     }
	                     post {
	                           success {
	                                  echo 'Regression Testing is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Regression Testing Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Regression Testing Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	              stage ('Clean-up of Staging Env') {
	                     steps {
	                           echo 'Cleaning up Staging environment'
	                           script {
	                                  try {
	                                         sh 'docker stop spring-mvc-rest-stage'
	                                         sh 'docker rm -f spring-mvc-rest-stage' 
	                                         sh 'docker image rm -f spring-mvc-rest-stage'
	                                  } catch(Exception e) {
	                                         echo 'No Docker image "spring-mvc-rest-stage" found'
	                                  }      
	                           }
	                     }
	                     post {
	                           success {
	                                  echo 'Staging Docker image deletion is successful...'
	                           }
	                           failure {
	                                  emailext attachLog: true, 
	                                  body: "Staging Docker image deletion Failed.... <br/><B>Job: </B> ${env.JOB_NAME} <br/> <B>Build Number#:</B> ${env.BUILD_NUMBER}<br/> <B>More info at: </B>${env.BUILD_URL}",
	                                  to: 'Santosh.Narate@searshc.com',
	                                  from: 'Santosh.Narate@searshc.com',
	                                  subject: "Staging Docker image deletion Failed: Job ${env.JOB_NAME} (Build Number# [${env.BUILD_NUMBER}])"
	                           }
	                           
	                     }
	              }
	       }
	}
