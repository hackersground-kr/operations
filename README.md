# Operations

해커그라운드 운영을 위한 각종 코드를 모아놓은 리포지토리

## 시작하기

### `Get-RandomAssignee.ps1`

이슈 담당자를 랜덤하게 선택하기 위한 파워셸 스크립트

```yml
- name: Get random assignee
  id: assignee
  shell: pwsh
  run: |
    Invoke-RestMethod https://raw.githubusercontent.com/hackersground-kr/operations/main/Get-RandomAssignee.ps1 | Out-File ~/Get-RandomAssignee.ps1
    $assignee = $(~/Get-RandomAssignee.ps1 -Assignees ${{ secrets.ASSIGNEES }})

    echo "value=$assignee" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf-8 -Append

- name: Show assignee
  shell: pwsh
  run: |
    echo "${{ steps.assignee.outputs.value }}"
```
