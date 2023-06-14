# Check CSC Trophies

이 스크립트는 Microsoft Learn의 CSC (Cloud Skills Challenge) 챌린지를 완료한 여부를 확인하기 위한 도구입니다.

## 요구 사항

- Python 3.6 이상
- `requirements.txt`에 명시된 패키지

## 설치 및 설정

1. 이 저장소를 클론하거나 다운로드합니다.

2. 터미널 또는 명령 프롬프트를 열고 프로젝트 디렉토리로 이동합니다.

3. 가상 환경을 생성합니다:

   ```shell
   python -m venv myenv
   ```

4. 가상 환경을 활성화합니다:

   - Windows:

     ```shell
     myenv\Scripts\activate
     ```

   - macOS/Linux:

     ```shell
     source myenv/bin/activate
     ```

5. 필요한 패키지를 설치합니다:

   ```shell
   pip install -r requirements.txt
   ```

## 사용법

다음과 같은 방법으로 챌린지 완료 여부를 확인할 수 있습니다:

```shell
python check-csc-trophies.py -p "https://learn.microsoft.com/profile/프로필_사용자_링크" -c "챌린지_코드"
```

- `-p` 옵션에는 Microsoft Learn 프로필 링크를 입력합니다.
- `-c` 옵션에는 완료를 확인하고 싶은 챌린지 코드를 입력합니다.

예를 들어, AZ-900 챌린지 완료 여부를 확인하려면 다음과 같이 실행합니다:

```shell
python check-csc-trophies.py -p "https://learn.microsoft.com/profile/your-profile-link" -c "AZ-900"
```

## 참고 사항

- 이 스크립트는 [Playwright](https://playwright.dev/)를 사용하여 웹 페이지를 자동으로 탐색합니다.
- 챌린지 완료 여부는 Microsoft Learn 웹 페이지의 내용에 따라 확인됩니다.
