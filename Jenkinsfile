pipeline {
    agent any
    stages {
        stage ('Git checkout') {
            steps {
                echo "clonning..."
                git branch: 'main', url: "https://github.com/vitoraalmeida/forum"
                sh 'ls'
            }
        }
        stage ('test') {
            steps {
                echo "executing gradle test app..."
                sh './gradlew clean test --no-daemon'
            }
        }
        stage ('buid') {
            steps {
                echo "building app"
            }
        }
    }
}

