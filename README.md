# (DRAFT) RAG 채팅 어플리케이션

## 💬 **RAG 채팅 어플리케이션 개요**

> ⚡ **이 프로젝트는 아래 GitHub 레포지토리를 기반으로 Azure 자원,일부 코드 등을 재구성한 것입니다.**
> [🔗 **Azure-Samples/chat-with-your-data-solution-accelerator**](https://github.com/Azure-Samples/chat-with-your-data-solution-accelerator)

---

## 📚 어플리케이션 소개

### 💡 User Story

- **Azure AI Search**와 **대형 언어 모델(LLMs)** 을 결합하여 **대화형 검색 경험** 제공
- **Azure OpenAI GPT 모델**과 **Azure AI Search 인덱스**를 사용하여 사용자 데이터에 대한 자연어 질의 처리
- **웹 애플리케이션 통합**: 자연어 인터페이스, **음성-텍스트 변환 기능 포함**
- **드래그 앤 드롭 파일 업로드**, **저장소 연결**, **기술적 설정 자동화** 지원
- 모든 구성 요소는 **사용자 구독에서 배포 가능**하여 빠른 활용 지원

### ⚙️ 주요 기능

- ✅ **Azure OpenAI 모델과 사용자 데이터 기반 채팅**
- 📂 **문서 업로드 및 처리**
- 🌐 **공개 웹 페이지 인덱싱 기능**
- 🧩 **간편한 프롬프트 구성**
- 🔍 **다양한 청크 분할 전략**
- ⚡ **Push 및 Pull 기반 데이터 수집 옵션**
- 🏗️ **Semantic Kernel, LangChain, OpenAI Functions, Prompt Flow 등의 오케스트레이션 선택**
- 🛠️ **실험 및 데이터 평가를 위한 RAG 구성 옵션 제공**

---

## 🏗️ RAG 채팅 어플리케이션 재구성 상세

### 🏛️ 아키텍처

- 💬 **Azure OpenAI GPT**: 사용자 데이터에 기반한 질의 응답
- 🔍 **Azure AI Search**: 사용자 데이터 인덱싱 및 고속 검색
- 🏃 **Azure Functions**: 대화 흐름 및 검색 로직 처리
- 🐳 **Azure Container Apps**: Docker 기반 RAG 모델 호스팅
- 🌐 **Azure App Service**: 프론트엔드 웹 인터페이스 제공
- 🔒 **VNet + Private Endpoint**: 네트워크 보안 및 서비스 간 비공개 통신
- 📊 **Application Insights**: 실시간 모니터링 및 문제 진단

---

### 💻 개발 환경

- 🏗️ **프로그래밍 언어**: Python, Node.js
- 🐳 **Docker**: 컨테이너화된 RAG 모델 및 백엔드 서비스
- ⚡ **Bicep**: Azure 리소스 배포 자동화
- 🧪 **CI/CD**: GitHub Actions를 통한 지속적 통합 및 배포
- 🏃 **Semantic Kernel 및 LangChain**을 통한 오케스트레이션 지원

---

## 🚀 **자원 배포 및 설정**

- 📝 **Bicep 템플릿**을 사용한 Azure 리소스 배포
- 📦 **Azure Container Registry**에 Docker 이미지 저장 및 배포
- 🔗 **원클릭 배포** 혹은 **cli 명령어** 방식 등 활용

### 방법 1. 🖱️ Quick Deploy

#### 파라미터 설명

- `APP_NAME`: 배포하고자하는 리소스의 별칭입니다.
- `AZURE_ENV_NAME`: 배포 환경의 별칭입니다.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjinkookchoi%2Fchat-with-your-data%2Frefs%2Fheads%2Fmain%2Finfra%2Fmain.json)

#### 🚨 추가 작업 필요

- 배포 후 `Function App`에 클라이언트 키 세팅(Function App의 Cold Start 이슈)
- `Admin App`의 좌측 환경변수 항목에서 `FUNCTION_KEY` 값 확인
- `Function App`의 App keys 메뉴에서 `ClientKey`의 이름으로 등해 주세요.

### 방법 2. 👩🏻‍💻 Deploy with `azd` cli

#### 1. 필수 도구 설치

Azure CLI 및 `azd`(Azure Developer CLI)가 설치되어 있어야 합니다.
설치가 되어 있지 않다면 다음 명령어로 설치하세요.

```bash
# Azure CLI 설치 (MacOS, Homebrew 이용)
brew install azure-cli

# Azure Developer CLI 설치
curl -fsSL https://aka.ms/install-azd.sh | bash
```

#### 2. 레포지토리 클론

```bash
git clone https://github.com/your-repo/chat-with-your-data.git
cd chat-with-your-data
```

#### 3. Azure 로그인 및 환경 설정

```bash
# Azure 로그인
azd auth login

# 새로운 배포 환경 생성 (예: dev)
azd env new dev
```

#### 4. 애플리케이션 이름 설정

```bash
export APP_NAME=app-chat
azd env set APP_NAME $APP_NAME
```

#### 5. Azure 리소스 프로비저닝

```bash
azd provision
```

이 명령어는 필요한 Azure 리소스를 자동으로 생성하고 설정합니다.

---

### 확인 및 배포 완료

#### 1. Azure Portal에서 리소스 확인

Azure Portal(https://portal.azure.com)에 로그인한 후, 배포된 리소스를 확인하세요.

- **Web App**: 배포된 Web App을 찾습니다.
    - 채팅용, 어드민용 각각 생성되어 있습니다.
- **Function App**: 배포된 Function App을 찾습니다.

#### 2. Web App 실행 및 확인

1. Azure Portal에서 **Web App**으로 이동합니다.
2. **개요(Overview)** 탭에서 **URL**을 클릭하여 브라우저에서 엽니다.
    - 채팅용, 어드민용 각각 확인합니다.
3. 페이지가 정상적으로 로드되는지 확인합니다.

#### 3. Function App 확인

1. Azure Portal에서 **Function App**으로 이동합니다.
2. **Functions** 메뉴에서 배포된 함수 목록을 확인합니다.

배포된 애플리케이션이 정상적으로 동작하면 모든 과정이 완료된 것입니다. 추가적인 설정이 필요하면 Azure Portal에서 리소스를 관리하세요.


<!--
---

## 💬 주요 변경 및 최적화 사항

-->

---

## 🎯 요약

- 📦 **이 프로젝트는 [Azure-Samples/chat-with-your-data-solution-accelerator](https://github.com/Azure-Samples/chat-with-your-data-solution-accelerator) 레포지토리를 기반으로 재구성되었습니다.**
- **Azure OpenAI**, **AI Search**, **Azure Functions**, **Azure Container Apps**를 사용하여 **RAG 기반 채팅 어플리케이션**을 구현되었습니다.
- **배포 타겟이 되는 Azure 환경에 따라 자원 구성 및 일부 코드 변경이 필요할 수 있습니다.**

---

💡 **이 프로젝트의 상세한 내용에 대해서는 `docs` 폴더 내 문서를 참고하시길 바랍니다.  😊**
