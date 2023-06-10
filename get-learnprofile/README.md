# Get Learn Profile

주어진 문자열에서 Microsoft Learn Profile 링크를 추출하는 파워셸 스크립트입니다. 아래 예시와 같이 GitHub 액션에서 활용할 수 있습니다.

```yml
- name: Get Microsoft Learn profile
  id: profile
  shell: pwsh
  run: |
    $scriptUrl = "https://raw.githubusercontent.com/hackersground-kr/operations/${{ github.ref_name }}/get-learnprofile/Get-LearnProfile.ps1"
    Invoke-RestMethod $scriptUrl | Out-File ~/Get-LearnProfile.ps1

    $text = "깃헙 ID: https://github.com/octocat\r\n\r\nMicrosoft Learn 프로필 링크: https://learn.microsoft.com/ko-kr/users/octocat/\r\n\r\n클라우드 스킬 챌린지 토픽/코드: 애저 기초 (PL-900)"
    $profileLink = $(~/Get-LearnProfile.ps1 -Text $text1)

    echo "link=$profileLink" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf-8 -Append

- name: Show Microsoft Learn profile
  shell: pwsh
  run: |
    echo "${{ steps.profile.outputs.link }}"
```
