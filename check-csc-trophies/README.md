# Check CSC Trophies

이 스크립트는 Microsoft Learn의 CSC (Cloud Skills Challenge) 챌린지를 완료한 여부를 확인하기 위한 도구입니다.


## 사전 준비 사항

- Python 3.6 이상
- `playwright` Python 패키지

## 설치

다음 명령어를 실행하여 `playwright` 패키지를 설치합니다:
```
pip3 install playwright
```

다음 명령어를 실행하여 필요한 브라우저를 다운로드합니다:
```
python3 -m playwright install
```

## 사용법

1. 스크립트 파일을 다운로드하고 해당 파일의 경로를 확인합니다.
   - [check-csc-trophies.py](https://raw.githubusercontent.com/your-username/your-repo/main/check-csc-trophies.py)를 클릭하여 파일을 다운로드합니다.
   - 다운로드한 파일의 경로를 확인합니다. (예: /workspaces/operations/check-csc-trophies/check-csc-trophies.py)

2. 다음 명령어로 스크립트를 실행합니다:
```
python3 <파일 경로> -p <프로필 링크> -c <챌린지 코드>
```

- `<파일 경로>`에는 다운로드한 스크립트 파일의 경로를 입력합니다.
- `<프로필 링크>`에는 확인하려는 Microsoft Learn 프로필의 URL을 입력합니다.
- `<챌린지 코드>`에는 확인하려는 챌린지 모듈의 코드를 입력합니다.

사용 예시:
```
python3 /workspaces/operations/check-csc-trophies/check-csc-trophies.py -p "https://learn.microsoft.com/ko-kr/users/minjuncha-9657/" -c "AZ-900"
```

스크립트는 지정한 챌린지 모듈의 완료 상태를 표시합니다.

참고: 올바른 프로필 링크와 챌린지 코드를 제공해야 합니다.
