pipeline {
  agent any

  environment {
    RAILS_ENV = 'test'
    RVM_RUBY = 'source /var/lib/jenkins/.rvm/scripts/rvm && rvm use 3.3.4 --default'
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
  }
}
