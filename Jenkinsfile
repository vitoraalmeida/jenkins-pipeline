projects = ["forum", "leilão"]
node {
    stage ('Git checkout') {
        echo "clonning..."
        git branch: 'main', url: "https://github.com/vitoraalmeida/forum"
        sh 'ls'
    }

/*
    stage ('build') {
        steps {
            echo "building app"
            sh './gradlew assemble'
        }
    }
*/

    stage ('cyclonedx') {
        echo "executing gradle test app..."
        sh './gradlew cyclonedxBom -info'
    }

    stage('dependencyTrackPublisher') {
        withCredentials([string(credentialsId: 'dependency-track', variable: 'API_KEY')]) {
            dependencyTrackPublisher artifact: 'build/reports/bom.xml', projectName: 'forum', projectVersion: '1', synchronous: true, dependencyTrackApiKey: API_KEY
        }
    }

    stage('loop over list') {
        for (int i = 0; i < browsers.size(); ++i) {
            echo "${projects[i]}" 
        } 
    }

    cleanWs()
}

