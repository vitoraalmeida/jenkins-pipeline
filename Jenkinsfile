projects = ["forum"]

GRADLE = "./gradlew" //caminho para binário do gradle
BOM_FILE = "./build/reports/bom.xml"
DEPENDENCY_TRACK_UPLOAD_URL = "http://192.168.1.2:8081/api/v1/bom"

node {
    cleanWs()

/*
    stage ('clone repos') {
        for(project in projects) {
            dir("${project}") {
                echo "Clonando ${project}"
                git branch: 'main', url: "https://github.com/vitoraalmeida/${project}"
            }
        }
    }

    stage ('execute cyclonedxBom') {
        for(project in projects) {
            dir("${project}") {
                echo "Executanddo cyclonedxBom em ${project}"
                sh "${GRADLE} cyclonedxBom -info"
            }
        }
    }
    */

    stage('publish to dependency track') {
        for(project in projects) {
            dir("${project}") {
                // recupera a credencial do dependency track e armazena na variável KEY
                withCredentials([string(credentialsId: 'dependency-track', variable: 'KEY')]) {
                    sh('echo $KEY' + "${DEPENDENCY_TRACK_UPLOAD_URL}")
                }
            }
        }
    }
}
