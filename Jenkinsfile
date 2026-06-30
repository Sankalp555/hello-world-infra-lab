pipeline {
  agent any

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  environment {
    RAILS_ENV = 'test'
    RVM_RUBY = 'source /var/lib/jenkins/.rvm/scripts/rvm && rvm use 3.3.4 --default'
    EC2_HOST = '13.207.119.208'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
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
