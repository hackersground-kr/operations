# Check CSC Trophies

이 스크립트는 Microsoft Learn의 CSC (Cloud Skills Challenge) 챌린지를 완료한 여부를 확인하기 위한 도구입니다.

## 요구 사항

- Python 3.7 이상

## 설치 및 설정

1. 이 저장소를 클론하거나 다운로드합니다.
1. 아래 명령어를 순서대로 실행시켜 파이썬 가상 환경을 설정합니다.

   > 여기서는 [`virtualenv`](https://pypi.org/project/virtualenv/)를 사용하는 것으로 가정합니다. 만약 필요하다면 아래 명령어를 이용해 먼저 설치하세요.
   > 
   > ```bash
   > pip install --user virtualenv
   > ```

    ```bash
    # On Windows
    python -m virtualenv venv
    ./venv/Scripts/activate
 
    # On Linux/MacOS
    virtualenv venv
    source venv/bin/activate
    ```

1. 아래 명령어를 순서대로 실행시켜 필요한 패키지를 설치합니다.

    ```bash
    pip install -r requirements.txt
    playwright install
    ```

## 사용법

다음과 같은 방법으로 챌린지 완료 여부를 확인할 수 있습니다:

```bash
python check-csc-trophies.py -p "https://learn.microsoft.com/ko-kr/users/{{ 계정명 }}" -c "{{ 챌린지 코드 }}"
```

- `-p` 옵션에는 Microsoft Learn 프로필 링크를 입력합니다.
- `-c` 옵션에는 완료를 확인하고 싶은 챌린지 코드를 입력합니다.

예를 들어, AZ-900 챌린지 완료 여부를 확인하려면 다음과 같이 실행합니다:

```bash
python check-csc-trophies.py -p "https://learn.microsoft.com/ko-kr/users/your-profile-link" -c "AZ-900"
```

## 참고 사항

- 이 스크립트는 [Playwright for Python](https://playwright.dev/python/)을 사용하여 웹 페이지를 자동으로 탐색합니다.
- 챌린지 완료 여부는 Microsoft Learn 웹 페이지의 내용에 따라 확인됩니다.
