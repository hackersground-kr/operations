from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Chrome 웹 드라이버 경로 설정
## 웹 드라이버 경로에 맞게 수정
### https://chromedriver.chromium.org/downloads 크롬 버전에 맞춰 설치
webdriver_service = Service('./chromedriver_mac64/chromedriver.exe')

# Chrome 옵션 설정
options = Options()
options.add_argument('--headless')  # 브라우저 창을 띄우지 않고 실행

# Selenium 웹 드라이버 생성
driver = webdriver.Chrome(service=webdriver_service, options=options)

# 웹 페이지 열기
url = input("Microsoft Learn 프로필 링크를 입력해주세요: ")
driver.get(url)

print("\n* `AZ-900`: 애저 기초 챌린지\n* `AI-900`: 애저 AI 기초 챌린지\n* `DP-900`: 애저 데이터 기초 챌린지\n* `PL-900`: 파워 플랫폼 기초 챌린지\n* `SC-900`: 보안 기초 챌린지\n* `MS-900`: Microsoft365 기초 챌린지")
print("\n완료를 확인하고 싶은 챌린지 코드를 입력해 주세요: ")
print("예시 : AZ-900\n")
challenge=input("코드 입력: ")

# 대기 설정
## 웹페이지 실행하자마자 트로피 정보가 뜨는 게 아니라 정보 로드될 때까지 기다려야 함
wait = WebDriverWait(driver, 10)

# section 요소 찾기
## 배지 title도 동일한 class명(card-content-title)을 가지고 있음
section = wait.until(EC.presence_of_element_located((By.ID, "trophies-section")))

# section 내부에서 card-content-title 클래스를 가진 요소들 찾기
elements = section.find_elements(By.CLASS_NAME, "card-content-title")

A=[]
# 요소 확인
for element in elements:
    text = element.text
    A.append(text)

Flag_az_900=1
Flag_ai_900=1
Flag_dp_900=1
Flag_pl_900=1
Flag_sc_900=1
Flag_ms_900=1

if "Microsoft Azure 기본 사항: 클라우드 개념 설명" not in A:
    Flag_az_900 = 0
if "Azure 기본 사항: Azure 아키텍처 및 서비스 설명" not in A:
    Flag_az_900 = 0
if "Azure 기본 사항: Azure 관리 및 거버넌스 설명" not in A:
    Flag_az_900 = 0

if "Microsoft Azure AI 기본 사항: 인공 지능 시작" not in A:
    Flag_ai_900 = 0
if "Microsoft Azure AI 기본 사항: 기계 학습을 위한 시각적 도구 살펴보기" not in A:
    Flag_ai_900 = 0
if "Microsoft Azure AI 기본 사항: 컴퓨터 비전 살펴보기" not in A:
    Flag_ai_900 = 0
if "Microsoft Azure AI 기본 사항: 자연어 처리 살펴보기" not in A:
    Flag_ai_900 = 0
if "Microsoft Azure AI 기본 사항: 의사 결정 지원 살펴보기" not in A:
    Flag_ai_900 = 0
if "Microsoft Azure AI 기본 사항: 지식 마이닝 살펴보기" not in A:
    Flag_ai_900 = 0

if "Microsoft Azure 데이터 기본 사항: 핵심 데이터 개념 살펴보기" not in A:
    Flag_dp_900 = 0
if "Microsoft Azure 데이터 기본 사항: Azure에서 관계형 데이터 탐색" not in A:
    Flag_dp_900 = 0
if "Microsoft Azure 데이터 기본 사항: Azure에서 비관계형 데이터 탐색" not in A:
    Flag_dp_900 = 0
if "Microsoft Azure 데이터 기본 사항: Azure의 데이터 분석 탐색" not in A:
    Flag_dp_900 = 0

if "PL-900: Microsoft Power Platform Fundamentals" not in A:
    Flag_pl_900 = 0

if "Microsoft 보안, 규정 준수 및 ID 기본 사항: 보안, 규정 준수 및 ID의 개념 설명" not in A:
    Flag_sc_900 = 0
if "Microsoft 보안, 규정 준수, ID 기본 사항: Microsoft Entra의 일부인 Microsoft Azure Active Directory의 기능 설명" not in A:
    Flag_sc_900 = 0
if "Microsoft 보안, 규정 준수 및 ID 기본 사항: Microsoft 보안 솔루션의 기능 설명" not in A:
    Flag_sc_900 = 0
if "MS-900 Microsoft 365 기본 사항: Microsoft 365 보안 및 규정 준수 기능 설명" not in A:
    Flag_sc_900 = 0

if "MS-900 Microsoft 365 기본 사항: Microsoft 365 보안 및 규정 준수 기능 설명" not in A:
    Flag_ms_900 = 0
if "Microsoft 보안, 규정 준수 및 ID 기본 사항: Microsoft 규정 준수 솔루션의 기능 설명" not in A:
    Flag_ms_900 = 0
if "MS-900 Microsoft 365 기본 사항: Microsoft 365 앱 및 서비스 설명" not in A:
    Flag_ms_900 = 0
if "MS-900 Microsoft 365 기본 사항: Microsoft 365 가격 책정, 라이선스 및 지원 설명" not in A:
    Flag_ms_900 = 0


if challenge=="AZ-900":
    if Flag_az_900 == 1:
        print("AZ-900 완료 /ok")
    else:
        print("AZ-900 NO")

if challenge=="AI-900":
    if Flag_ai_900 == 1:
        print("AI-900 완료 /ok")
    else:
        print("AI-900 NO")

if challenge=="DP-900":
    if Flag_dp_900 == 1:
        print("DP-900 완료 /ok")
    else:
        print("DP-900 NO")

if challenge=="PL-900":
    if Flag_pl_900 == 1:
        print("PL-900 완료 /ok")
    else:
        print("PL-900 NO")

if challenge=="SC-900":
    if Flag_sc_900 == 1:
        print("SC-900 완료 /ok")
    else:
        print("SC-900 NO")

if challenge=="MS-900":
    if Flag_ms_900 == 1:
        print("MS-900 완료 /ok")
    else:
        print("MS-900 NO")

# Selenium 사용 완료 후 브라우저 종료
driver.quit()
