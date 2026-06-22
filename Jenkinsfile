pipeline {
  agent any

  environment {
    RAILS_ENV = 'test'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'ruby -v'
        sh 'bundle -v'
        sh 'bundle install'
      }
    }

    stage('Prepare database') {
      steps {
        sh 'bin/rails db:prepare'
      }
    }

    stage('Run RSpec') {
      steps {
        sh 'bundle exec rspec'
      }
    }

    stage('Run RuboCop') {
      steps {
        sh 'bundle exec rubocop'
      }
    }

    stage('Run Brakeman') {
      steps {
        sh 'bundle exec brakeman --no-pager'
      }
    }
  }
}
