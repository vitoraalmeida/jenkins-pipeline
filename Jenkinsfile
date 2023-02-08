GRADLE = "./gradlew" //caminho para binário do gradle
DEPENDENCY_TRACK_UPLOAD_URL = "http://192.168.0.104:8081/api/v1/bom"
VERSION_FILE_GRADLE = "./gradle.properties"
VERSION_FILE_COMPOSER = "./composer.json"

properties(
    [
        parameters([
                string(name: 'ORG'),
                string(name: 'PROJECT'),
                choice(
                    choices: ['GRADLE', 'COMPOSER', 'DOCKER'],
                    name: 'BUILD_TOOL'
                ),
                string(name: 'PHP_VERSION'),
        ])   
    ]
)  

node {
    cleanWs()
    def PROJECT = params.PROJECT

    stage ('execute cyclonedxBom') {
        if (BUILD_TOOL == 'GRADLE') {
            echo "Clonando ${PROJECT}"
            git branch: 'main', url: "https://github.com/${ORG}/${PROJECT}"
            echo "Executando cyclonedxBom em ${PROJECT}"
            sh "${GRADLE} --no-daemon cyclonedxBom -info"
        } else if (BUILD_TOOL == 'COMPOSER') {
            sh "git clone https://github.com/vitoraalmeida/jenkins-pipeline"
            dir("jenkins-pipeline") {
                sh "ls"
                sh "DOCKER_BUILDKIT=1 docker build --build-arg MY_IMAGE=php:${PHP_VERSION} --build-arg REPO='${PROJECT}' --build-arg ORG='${ORG}' --output . . "
                sh "ls"
            }
        } else if (BUILD_TOOL == 'DOCKER')  {
            sh "docker run anchore/syft ${IMAGE} -o cyclonedx-json > bom.json"
        } else {
            echo "Linguagem não suportada"
        }
    }

    stage('publish to dependency track') {
        // recupera a credencial do dependency track e armazena na variável KEY
        withEnv(["URL=${DEPENDENCY_TRACK_UPLOAD_URL}",
                 "ORG=${ORG}",
                 "PROJECT=${PROJECT}",
                 "FILE=${getBomLocation()}",
                 "VERSION=${getVersion()}",]){
            withCredentials([string(credentialsId: 'dtrack', variable: 'KEY')]) {
                sh "$FILE"
                sh('curl -X POST -H accept:application/json -H Content-Type:multipart/form-data -H X-API-KEY:$KEY -F autoCreate=True -F projectName=$ORG-$PROJECT -F projectVersion=$VERSION -F bom=@$FILE $URL')
            }
        }
    }
}

def getVersion() {
    if (BUILD_TOOL == 'GRADLE') {
        getVersionGradle()
    } else if (BUILD_TOOL == 'COMPOSER') {
        getVersionComposer()
    } else {
        echo "Linguagem não suportada"
    }
}

def getVersionGradle() {
    def lines = readFile(VERSION_FILE_GRADLE).split("\n")
    def result = "not_found"
    for (line in lines) {
        if (line.contains("version")) {
            result = line.split("=")[1].trim()
        }
    }
    return result.replace(" ","_")
}

def getVersionComposer() {
    def lines = readFile(VERSION_FILE_COMPOSER).split("\n")
    def result = "not_found"
    for (line in lines) {
        if (line.contains('"php": "')) {
            result = line.split(">=")[1].trim()
        }
    }
    return "1.0"
}

def getBomLocation() {
    if (BUILD_TOOL == 'GRADLE') {
        return "./build/reports/bom.xml"
    } else if (BUILD_TOOL == 'COMPOSER') {
        return "./bom.xml"
    } else {
        return "./bom.json" 
    }
}
