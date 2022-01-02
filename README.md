# KG Mission Pack

<div align="center"><img src="https://i.imgur.com/HfOmhbD.png"></center></div>

Arma 3를 플레이하는 KimchiGuys 그룹을 위한 MCC Sandbox 애드온 입니다.

# Author
원작자는 <a href=https://github.com/shaygman>shaygman</a> 입니다.

# License
GPLv3의 조건 하에 배포됩니다.
따라서, 어떠한 목적이든 사용 가능하며 2차 개작을 포함한 재배포가 모두 허용됩니다.

# 개발 흐름
- (1) 작업해야 할 내용을 Issue로 생성합니다.
  - 작업할 내용에 대한 설명과, 구현 설계를 작성합니다.
  - 필요하다면 Comment로 잠시 의논을 합니다.
  - 충분한 논의 이후, 개발 담당을 Assignee에 할당합니다.
- (2) 작업할 Branch를 생성합니다.
  - ```dev``` Branch에서 분기합니다.
  - 브렌치명은 ```{이슈번호}-{제목}``` 입니다.
    - (예시: ```145-fix-kg-optic-code```)
- (3) 작업 완료 후 Pull Request를 생성합니다.
  - 코드 리뷰를 받고 수정 요청을 반영합니다.
  - Merge 및 Delete Branch는 리뷰어가 진행합니다.

# Issue 생성 없이 개발할 경우
- Branch 이름을 ```{작업자}/{날짜}-{제목}``` 으로 생성합니다.
  - (예시: ```goguryeo/210925-added-new-map```)

# 주의 사항
- 핫픽스 포함 모든 커밋은 ```main```, ```dev``` 브렌치에 직접 커밋하지 않습니다.
  - ```main```: 실제 본 서버에 적용되는 코드 (production)
  - ```dev```: 테스트 서버에서 사용할 코드 (dev+stage)
- Issue에서 충분한 협의 후, Assign을 받고 작업을 시작해야 합니다.
  - 임의로 작업 시작할 경우, 잘못된 설계로 인해 PR이 거절될 수 있습니다.
  - 단, Issue가 없어도 스탭 회의 게시판에서 논의하고 작업을 시작할 수도 있습니다.

# GitHub 정책
- Issue와 무관하게 개발자 간 소통이 필요한 경우, Discussions를 사용합니다.
  - Issue는 개발 Issue에 관한 것만 작성합니다.

# 기여자
 - <a href=https://github.com/shaygman>shaygman</a><br>
 - <a href=https://github.com/goguryeo1>GOGURYEO</a>
