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
                sh './gradle clean test'
            }
        }
        stage ('buid') {
            steps {
                echo "building app"
            }
        }
    }
}

