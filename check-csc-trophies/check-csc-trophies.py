from playwright.sync_api import sync_playwright
import time

def check_challenge_completion(url, challenge):
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        page = browser.new_page()

        # 웹 페이지 열기
        page.goto(url)

        challenge_input = challenge

        # 대기 설정
        ## 웹페이지 실행하자마자 트로피 정보가 뜨는 게 아니라 정보 로드될 때까지 기다려야 함
        time.sleep(5)  # 5초 대기 (필요에 따라 조정 가능)

        # section 내부에서 card-content-title 클래스를 가진 요소들 찾기
        elements = page.query_selector_all(".card-content-title")

        A = [element.text_content().replace("\n", "").replace("\t", "").strip() for element in elements]

        Flag_az_900 = 1
        Flag_ai_900 = 1
        Flag_dp_900 = 1
        Flag_pl_900 = 1
        Flag_sc_900 = 1
        Flag_ms_900 = 1

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

        if challenge_input == "AZ-900":
            if Flag_az_900 == 1:
                print("AZ-900 완료 /ok")
            else:
                print("AZ-900 NO")

        if challenge_input == "AI-900":
            if Flag_ai_900 == 1:
                print("AI-900 완료 /ok")
            else:
                print("AI-900 NO")

        if challenge_input == "DP-900":
            if Flag_dp_900 == 1:
                print("DP-900 완료 /ok")
            else:
                print("DP-900 NO")

        if challenge_input == "PL-900":
            if Flag_pl_900 == 1:
                print("PL-900 완료 /ok")
            else:
                print("PL-900 NO")

        if challenge_input == "SC-900":
            if Flag_sc_900 == 1:
                print("SC-900 완료 /ok")
            else:
                print("SC-900 NO")

        if challenge_input == "MS-900":
            if Flag_ms_900 == 1:
                print("MS-900 완료 /ok")
            else:
                print("MS-900 NO")

        browser.close()

# 프로필 링크와 챌린지 코드를 입력받음
profile_link = input("Microsoft Learn 프로필 링크를 입력해주세요: ")

print("\n* `AZ-900`: 애저 기초 챌린지\n* `AI-900`: 애저 AI 기초 챌린지\n* `DP-900`: 애저 데이터 기초 챌린지\n* `PL-900`: 파워 플랫폼 기초 챌린지\n* `SC-900`: 보안 기초 챌린지\n* `MS-900`: Microsoft365 기초 챌린지")

challenge_code = input("\n완료를 확인하고 싶은 챌린지 코드를 입력해 주세요 (예시: AZ-900): ")

# 함수 호출
check_challenge_completion(profile_link, challenge_code)

