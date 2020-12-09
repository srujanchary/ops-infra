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
        sh "terraform init"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "terraform plan"
      }
    }
    stage('Terraform Apply') {
      steps {
        sh "terraform apply"
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
