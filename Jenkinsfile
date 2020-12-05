pipeline {
  agent any  
  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
  }
  environment {
    //TF_WORKSPACE = 'dev' //Sets the Terraform Workspace
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  }
  stages {
    stage('Terraform Init') {
      steps {
        sh "terraform init"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh terraform plan -input=false -backend-config="access_key=${params.AWS_ACCESS_KEY_ID}" -backend-config="secret_key=${params.AWS_SECRET_ACCESS_KEY}"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        sh terraform plan -input=false -backend-config="access_key=${params.AWS_ACCESS_KEY_ID}" -backend-config="secret_key=${params.AWS_SECRET_ACCESS_KEY}"
      }
    }
  }
}
