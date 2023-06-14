import sys
import subprocess
import argparse

def print_result(challenge_input, flags, A):
    completion_status = {}

    for challenge_code, challenge_flags in flags.items():
        is_completed = all(flag in A for flag in challenge_flags)
        completion_status[challenge_code] = is_completed

    if challenge_input.upper() in completion_status:
        if completion_status[challenge_input.upper()]:
            print(f"{challenge_input} 완료 /ok")
        else:
            print(f"{challenge_input} NO")
    else:
        print("유효하지 않은 챌린지 코드입니다.")

def check_challenge_completion(url, challenge):
    from playwright.sync_api import sync_playwright
    import time

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        page = browser.new_page()

        # 웹 페이지 열기
        page.goto(url)

        challenge_input = challenge.strip()  # 공백 제거

        # 대기 설정
        ## 웹페이지 실행하자마자 트로피 정보가 뜨는 게 아니라 정보 로드될 때까지 기다려야 함
        time.sleep(5)  # 5초 대기 (필요에 따라 조정 가능)

        # section 내부에서 card-content-title 클래스를 가진 요소들 찾기
        elements = page.query_selector_all(".card-content-title")

        A = [element.text_content().replace("\n", "").replace("\t", "").strip() for element in elements]

        # 플래그 변수를 딕셔너리로 정의합니다.
        flags = {
            "AZ-900": ["Microsoft Azure 기본 사항: 클라우드 개념 설명", "Azure 기본 사항: Azure 아키텍처 및 서비스 설명", "Azure 기본 사항: Azure 관리 및 거버넌스 설명"],
            "AI-900": ["Microsoft Azure AI 기본 사항: 인공 지능 시작", "Microsoft Azure AI 기본 사항: 기계 학습을 위한 시각적 도구 살펴보기", "Microsoft Azure AI 기본 사항: 컴퓨터 비전 살펴보기", "Microsoft Azure AI 기본 사항: 자연어 처리 살펴보기", "Microsoft Azure AI 기본 사항: 의사 결정 지원 살펴보기", "Microsoft Azure AI 기본 사항: 지식 마이닝 살펴보기"],
            "DP-900": ["Microsoft Azure 데이터 기본 사항: 핵심 데이터 개념 살펴보기", "Microsoft Azure 데이터 기본 사항: Azure에서 관계형 데이터 탐색", "Microsoft Azure 데이터 기본 사항: Azure에서 비관계형 데이터 탐색", "Microsoft Azure 데이터 기본 사항: Azure의 데이터 분석 탐색"],
            "PL-900": ["PL-900: Microsoft Power Platform Fundamentals"],
            "SC-900": ["Microsoft 보안, 규정 준수 및 ID 기본 사항: 보안, 규정 준수 및 ID의 개념 설명", "Microsoft 보안, 규정 준수, ID 기본 사항: Microsoft Entra의 일부인 Microsoft Azure Active Directory의 기능 설명", "Microsoft 보안, 규정 준수 및 ID 기본 사항: Microsoft 보안 솔루션의 기능 설명", "MS-900 Microsoft 365 기본 사항: Microsoft 365 보안 및 규정 준수 기능 설명"],
            "MS-900": ["MS-900 Microsoft 365 기본 사항: Microsoft 365 보안 및 규정 준수 기능 설명", "Microsoft 보안, 규정 준수 및 ID 기본 사항: Microsoft 규정 준수 솔루션의 기능 설명", "MS-900 Microsoft 365 기본 사항: Microsoft 365 앱 및 서비스 설명", "MS-900 Microsoft 365 기본 사항: Microsoft 365 가격 책정, 라이선스 및 지원 설명"]
        }

        print_result(challenge_input, flags, A)

        # 브라우저 종료
        browser.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--profile-link", type=str, help="프로필 링크")
    parser.add_argument("-c", "--challenge-code", type=str, help="챌린지 코드")
    args = parser.parse_args()

    url = args.profile_link
    challenge = args.challenge_code

    check_challenge_completion(url, challenge)
