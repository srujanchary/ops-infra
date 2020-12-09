pipeline {
  agent any
  //parameters {
    //password (name: 'AWS_ACCESS_KEY_ID')
    //password (name: 'AWS_SECRET_ACCESS_KEY')
  //}
  parameters {
        choice(name: 'type', choices: ['apply', 'destroy'], description: 'Pick something')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }  
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
  /*
  stages {
    stage('Terraform Init') {
      steps {
        sh "terraform init"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "terraform plan -out=tfplan -input=false"
      }
    }
    stage('Terraform Apply') {
      if (${}) {
      steps {
        sh "terraform apply -input=false tfplan"
      }
      }
    }
    stage('AWSpec Tests') {
      steps {
          sh '''#!/bin/bash -l
bundle install --path ~/.gem
bundle exec rake spec || true
'''

        junit(allowEmptyResults: true, testResults: '*//*testResults/.xml')
      }
    }
  }
  */
  stages {
        stage('Plan') {
            steps {
                sh 'terraform init -input=false'
                sh "terraform plan -input=false -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
          steps {
            script {
          if (params.type == 'apply') {
                sh "terraform apply -input=false tfplan"
          }
          }
          }  
        }
        stage('Destroy') {
          steps {
            script {
          if (params.type == 'destroy') {
                sh "terraform destroy -input=false"
          } 
          } 
          }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}

