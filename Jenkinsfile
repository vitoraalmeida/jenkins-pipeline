tools {
    maven 'maven-default'
}

projects = ["forum", "leilao"]
node {
    cleanWs()
    stage ('clone repos') {
        for(project in projects) {
            dir("${project}") {
                echo "dentro de ${project}"
                git branch: 'main', url: "https://github.com/vitoraalmeida/${project}"
            }
        }
        sh 'ls'
    }
    stage ('clone repos') {
        for(project in projects) {
            dir("${project}") {
                if (fileExists('pom.xml')) {
                    echo "Executing cyclonedxBom in ${project}"
                    sh 'mvn clean install'
                } else {
                    echo "Executing cyclonedxBom in ${project}"
                    sh './gradlew cyclonedxBom -info'
                }
            }
        }
    }

/*
    stage ('build') {
        steps {
            echo "building app"
            sh './gradlew assemble'
        }
    }

    stage ('cyclonedx') {
        dir('forum') {
            echo "executing gradle test app..."
            sh './gradlew cyclonedxBom -info'
        }
    }

    stage('dependencyTrackPublisher') {
        dir('forum'){
            withCredentials([string(credentialsId: 'dependency-track', variable: 'API_KEY')]) {
                dependencyTrackPublisher artifact: 'build/reports/bom.xml', projectName: 'forum', projectVersion: '1', synchronous: true, dependencyTrackApiKey: API_KEY
            }
        }
    }

    cleanWs()
*/
}

