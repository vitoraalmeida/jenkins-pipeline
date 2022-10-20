GRADLE = "./gradlew" //caminho para binário do gradle
BOM_FILE = "./build/reports/bom.xml"
DEPENDENCY_TRACK_UPLOAD_URL = "http://192.168.0.104:8081/api/v1/bom"

properties(
    [
        parameters([
                string(name: 'ORG'),
                string(name: 'PROJECT'),
                choice(
                    choices: ['GRADLE', 'COMPOSER'],
                    name: 'BUILD_TOOL'
                ),
        ])   
    ]
)  

node {
    cleanWs()
    def PROJECT = params.PROJECT
    stage ('clone repos') {
        echo "Clonando ${PROJECT}"
        git branch: 'main', url: "https://github.com/${ORG}/${PROJECT}"
    }

    stage ('execute cyclonedxBom') {
        if (BUILD_TOOL == 'GRADLE') {
            echo "Executando cyclonedxBom em ${PROJECT}"
            sh "${GRADLE} cyclonedxBom -info --no-daemon"
        } else if (BUILD_TOOL == 'COMPOSER') {
            echo "execute compose"
        } else {
            echo "Linguagem não suportada"
        }
    }

    stage('publish to dependency track') {
        // recupera a credencial do dependency track e armazena na variável KEY
        withEnv(["URL=${DEPENDENCY_TRACK_UPLOAD_URL}",
                 "PROJECT=${PROJECT}",
                 "FILE=${BOM_FILE}"]){
            withCredentials([string(credentialsId: 'dependency-track', variable: 'KEY')]) {
                sh('curl -X POST -H accept:application/json -H Content-Type:multipart/form-data -H X-API-KEY:$KEY -F autoCreate=True -F projectName=$PROJECT -F projectVersion=1 -F bom=@$FILE $URL')
            }
        }
    }
}
