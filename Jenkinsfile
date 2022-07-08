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

        stage ('build') {
            steps {
                echo "building app"
                sh './gradlew assemble'
            }
        }

        stage ('cyclonedx') {
            steps {
                echo "executing gradle test app..."
                sh './gradlew cyclonedxBom -info'
            }
        }
        stage('dependencyTrackPublisher') {
            steps {
                withCredentials([string(credentialsId: 'zXvMbR5ceXtJp8yPUuKn7gZ5yoOB2Eag', variable: 'API_KEY')]) {
                    dependencyTrackPublisher artifact: 'build/reports/bom.xml', projectName: 'forum', projectVersion: '1', synchronous: true, dependencyTrackApiKey: API_KEY
                }
            }
        }
    }
}

