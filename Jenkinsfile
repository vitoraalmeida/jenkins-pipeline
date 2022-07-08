projects = ["forum", "leilao"]
node {
    stage ('clone repos') {
        clone_projects(projects)
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
}

@NonCPS
def clone_projects(list) {
    list.each { item ->
        echo "creating ${item} directory"
        dir("${item}") {
            git branch: 'main', url: "https://github.com/vitoraalmeida/${item}"
        }
    }
}

@NonCPS
def loop_of_sh(list) {
    list.each { item ->
        echo "Hello ${item}"
    }
}
