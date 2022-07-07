pipeline {
    agent any
    stages {
        stage ('clone-repo') {
            steps {
                echo "clonning"
                git url: "https://github.com/vitoraalmeida/forum"
            }
        }
        stage ('test') {
            steps {
                echo "testing app"
            }
        }
        stage ('buid') {
            steps {
                echo "building app"
            }
        }
    }
}

