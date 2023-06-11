# Set Team Repository

주어진 팀 이름에 해당하는 팀의 리포지토리를 생성하고 팀원을 할당하는 스크립트입니다. 아래 예시와 같이 GitHub 액션에서 활용할 수 있습니다.

```yml
- name: Set team repository
  shell: pwsh
  env:
    GH_TOKEN: ${{ secrets.GH_PAT }}
  run: |
    $scriptUrl = "https://raw.githubusercontent.com/hackersground-kr/operations/main/set-teamrepository/Set-TeamRepository.ps1"
    Invoke-RestMethod $scriptUrl | Out-File ~/Set-TeamRepository.ps1
    ~/Set-TeamRepository.ps1 -RepositoryName "${{ github.event.inputs.repository }}") -TeamLeader "${{ github.event.inputs.leader }}" -TeamMembers "${{ github.event.inputs.members }}"

- name: Get team repository details
  shell: pwsh
  env:
    GH_TOKEN: ${{ secrets.GH_PAT }}
  run: |
    gh api /repos/hackersground-kr/${{ github.event.inputs.repository }} -q ".full_name"
    gh api /repos/hackersground-kr/${{ github.event.inputs.repository }}/collaborators?affiliation=direct -q ".[] | .login"
```
