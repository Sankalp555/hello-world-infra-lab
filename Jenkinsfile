pipeline {
  agent any

  options {
    // Jenkins equivalent to GitHub's concurrency:
    // Prevents multiple builds from running at the same time and stepping on each other.
    disableConcurrentBuilds()
    // Keeps the build history clean
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  environment {
    RAILS_ENV = 'test'
    RVM_RUBY = 'source /var/lib/jenkins/.rvm/scripts/rvm && rvm use 3.3.4 --default'
    EC2_HOST = '13.207.119.208'
    // AWS Region for Terraform
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Infrastructure (Terraform)') {
      // Only run if files in terraform-lab folder changed
      when { changeset "terraform-lab/**" }
      steps {
        // Uses Jenkins Secret Text credentials for AWS keys
        withCredentials([
          string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          dir('terraform-lab') {
            sh 'terraform init'
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    stage('Configuration (Ansible)') {
      // Run if ansible files OR terraform files changed (since infra change needs re-config)
      when {
        anyOf {
          changeset "ansible/**"
          changeset "terraform-lab/**"
        }
      }
      steps {
        // Uses the SSH key stored in Jenkins credentials
        sshagent(['ec2-ssh-key']) {
          dir('ansible') {
            // Jenkins provides the key via the SSH_AUTH_SOCK or temporary file
            sh "ansible-playbook -i inventory.ini playbook.yml -e 'ansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"'"
          }
        }
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bundle install"'
      }
    }

    stage('Prepare database') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bin/rails db:prepare"'
      }
    }

    stage('Run Tests & Lint') {
      parallel {
        stage('RSpec') {
          steps { sh 'bash -lc "$RVM_RUBY && bundle exec rspec"' }
        }
        stage('RuboCop') {
          steps { sh 'bash -lc "$RVM_RUBY && bundle exec rubocop"' }
        }
        stage('Brakeman') {
          steps { sh 'bash -lc "$RVM_RUBY && bundle exec brakeman --no-pager"' }
        }
      }
    }

    stage('Deploy to EC2') {
      when {
        branch 'main'
      }
      steps {
        sshagent(['ec2-ssh-key']) {
          sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} 'cd ~/hello-world-infra-lab && ./script/deploy.sh'"
        }
      }
    }
  }
}
