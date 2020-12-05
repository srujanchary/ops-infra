pipeline {
  agent any
  //parameters {
    //password (name: 'AWS_ACCESS_KEY_ID')
    //password (name: 'AWS_SECRET_ACCESS_KEY')
  //}
 /* 
  environment {
    //TF_WORKSPACE = 'dev' //Sets the Terraform Workspace
    TF_IN_AUTOMATION = 'true'
    TF_VAR_access_key = "${access_key_id}"
    TF_VAR_secret_key = "${seceret_key_id}"
    //AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    //AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  }
  */
  stages {
    stage('Terraform Init') {
      steps {
        withCredentials([
                    usernamePassword(credentialsId: 'AWS_ACCESS_KEY_ID',usernameVariable: 'access_key', passwordVariable: 'access_key_id'),
                    usernamePassword(credentialsId: 'AWSSecretKey',usernameVariable: 'secret_key', passwordVariable: 'secret_key_id')
    ])
  {
        sh "export TF_VAR_access_key='${access_key_id}'"
        sh "export TF_VAR_secret_key='${seceret_key_id}'"
        sh "terraform init -input=false"
  }
      }
    }
    stage('Terraform Plan') {
      steps {
        withCredentials([
                    usernamePassword(credentialsId: 'AWS_ACCESS_KEY_ID',usernameVariable: 'access_key', passwordVariable: 'access_key_id'),
                    usernamePassword(credentialsId: 'AWSSecretKey',usernameVariable: 'secret_key', passwordVariable: 'secret_key_id')
    ])
  {
        sh "export TF_VAR_access_key='${access_key_id}'"
        sh "export TF_VAR_secret_key='${seceret_key_id}'"
        sh "terraform plan -out=tfplan -input=false"
  }      
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        sh "terraform apply -input=false tfplan"
      }
    }
    stage('AWSpec Tests') {
      steps {
          sh '''#!/bin/bash -l
bundle install --path ~/.gem
bundle exec rake spec || true
'''

        junit(allowEmptyResults: true, testResults: '*/testResults/.xml')
      }
    }
  }
}
