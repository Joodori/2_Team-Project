제일 먼저 해야할 것은 깃허브 계정생성 및 Git 설치입니다.
구글에 " Git "만 치시고 Git - Downloading Package 이거로 들어가서 받으시면 됩니다.
Git 설치하시면 바탕화면 빈곳에서 우클릭하면 무지개색으로 Open git Bash here 클릭 
---
< 첫 화면 이미지 >
---

사용자의 정보를 입력해야하는데 push를 할 때 누가 올렸는지 파악하기위해 사용자정보를 입력해주어야 합니다
git config --global user.email "you@example.com"
git config --global user.email
이거를 한번 더 쳐서 확인할 수 있습니다.

git config --global user.name "Your Name"
git config --global user.name




이제 여러분 컴퓨터엔 아무것도 존재하지 않기때문에 제일 먼저 이 저장소에 있는 파일들을 복제(clone)해서 가져와야합니다
---
git clone https://github.com/Joodori/2_Team-Project.git
---
+ 복제완료 사진

이걸 하고나면 제일 최신의 프로젝트 상황을 받을 수 있습니다.

--------------------------------------------------------------------

- 작업한거 올리기
일단 내가 지금 작업한 것들을 올릴건데 누군가 작업한 내용들이 있을 수 있기 때문에 pull을 진행해야 합니다.
clone과 다른 것이기 때문에 새로운 명령어를 open git Bash here를 통해서 진행해주어야 합니다.

일단 <repository - local 저장소 - 폴더> 이렇게 연결이 되어야하는데 로컬 저장소가 어디서 받아와야할지 모르기 때문에
git remote add origin https://github.com/Joodori/2_Team-Project.git 를 git bash here에 입력하여 어디서 받아오고 어디로 보낼지를 저장해줍니다.
그 이후에 


