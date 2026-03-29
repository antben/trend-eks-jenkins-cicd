pipeline {
    agent any

    stages {
        stage('Checkout Verification') {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Verify App Files') {
            steps {
                sh '''
                    if [ -d dist ]; then
                      echo "dist folder found"
                    else
                      echo "dist folder not found"
                      exit 1
                    fi
                '''
            }
        }
    }
}
