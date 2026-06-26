pipeline {
  agent any

  environment {
    RAILS_ENV = 'test'
    RVM_RUBY = 'source /var/lib/jenkins/.rvm/scripts/rvm && rvm use 3.3.4 --default'
    EC2_HOST = '13.207.200.211'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'bash -lc "$RVM_RUBY && ruby -v"'
        sh 'bash -lc "$RVM_RUBY && bundle -v"'
        sh 'bash -lc "$RVM_RUBY && bundle install"'
      }
    }

    stage('Prepare database') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bin/rails db:prepare"'
      }
    }

    stage('Run RSpec') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bundle exec rspec"'
      }
    }

    stage('Run RuboCop') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bundle exec rubocop"'
      }
    }

    stage('Run Brakeman') {
      steps {
        sh 'bash -lc "$RVM_RUBY && bundle exec brakeman --no-pager"'
      }
    }

    stage('Deploy to EC2') {
      when {
        anyOf {
          branch 'main'
          expression { env.BRANCH_NAME == 'main' }
          expression { env.GIT_BRANCH == 'origin/main' }
          expression { env.GIT_BRANCH == 'main' }
        }
      }
      steps {
        sshagent(['ec2-ssh-key']) {
          sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} 'cd ~/hello-world-infra-lab && ./script/deploy.sh'"
        }
      }
    }
  }
}
