## 사용법

1. `from playwright.sync_api import sync_playwright`를 통해 `sync_playwright` 모듈을 가져옵니다.
2. `check_challenge_completion(url, challenge)` 함수를 정의합니다. 이 함수는 Microsoft Learn 프로필의 링크와 확인하고자 하는 챌린지 코드를 매개변수로 받습니다.
3. `profile_link` 변수에 Microsoft Learn 프로필 링크를 입력합니다. (예: `https://example.microsoft.com/learn/profile/your-profile`)
4. `challenge_code` 변수에 확인하고자 하는 챌린지 코드를 입력합니다. (예: `AZ-900`)
5. `check_challenge_completion(profile_link, challenge_code)`를 호출하여 챌린지 완료 여부를 확인합니다.

### 예시

```python
from playwright.sync_api import sync_playwright
import time

def check_challenge_completion(url, challenge):
    # 함수 내용 생략

# 프로필 링크와 챌린지 코드를 입력받음
profile_link = input("Microsoft Learn 프로필 링크를 입력해주세요: ")

print("\n* `AZ-900`: 애저 기초 챌린지\n* `AI-900`: 애저 AI 기초 챌린지\n* `DP-900`: 애저 데이터 기초 챌린지\n* `PL-900`: 파워 플랫폼 기초 챌린지\n* `SC-900`: 보안 기초 챌린지\n* `MS-900`: Microsoft365 기초 챌린지")

challenge_code = input("\n완료를 확인하고 싶은 챌린지 코드를 입력해 주세요 (예시: AZ-900): ")

# 함수 호출
check_challenge_completion(profile_link, challenge_code)
```

위의 예시 코드를 실행하면 프로필 링크와 챌린지 코드를 입력하고, 해당 챌린지의 완료 여부를 확인할 수 있습니다.

### 주의사항

- 코드 실행 전에 `playwright` 패키지가 설치되어 있는지 확인해주세요. 설치되어 있지 않다면 다음 명령을 사용하여 설치할 수 있습니다:
  ```
  pip install playwright
  ```

- 코드 실행 시 브라우저가 자동으로 실행되며 웹 페이지를 엽니다. 이때, `headless=True`로 설정되어 있어 브라우저가 백그라운드에서 실행됩니다. 만약 브라우저를 시각적으로 보고 싶다면 `headless=False`로 변경해주세요.

- 웹 페이지가 로드되는 동안 대기 시간을 설정하기 위해 `time.sleep()` 함수를 사용합니다. 대기 시간은 필요에 따라 조정할 수 있습니다.
