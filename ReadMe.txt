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
아마도 

제일 처음 clone ~ first push
git clone http://github~ => 프로젝트파일 생성 이후 => 작업 => git status => 빨간거 확인하면 자기가 작업한거 git add . 또는 git add (자기자신이 작업한 파일이름_빨간색으로된거 그대로 적으면 됨) => git commit -m "자신이 뭘 했는지 여기에 적어주세요"
=> git push -u origin master    (이부분은 첫번째 push할때만 이렇게하고 나중에는 그냥 git push만 써도될거에요) => 이러면 무슨 빨간줄 다음에 노란줄 첫번째가 Update were rejected because the remote contains work that you do not 라고 뜰겁니다.
이 부분은 이 repository에 누군가가 작업한 부분을 올린거기때문에 최신의 프로젝트를 pull해와서 다시 push해야해요 => git pull => 이러면 눈앞이 캄캄해질건데 esc누르고 :wq를 누른다음에 엔터를 치시면 됩니다. 그러면 뭐가 막 뜰텐데 무슨 Auto-merging /폴더/폴더/파일
이렇게 뜨고 밑에는 Merge어쩌구 써있을거에요 그러면 아마 병합이 된 상태일겁니다. 혹시모르니 git 켜놓은 상태에서 eclipse나 VScode 들어가서 작업한거 확인해보시고 안되면 GPT친구한테 물어보는게 좋을거에요 => 그 다음에 git push -u origin master하시면 됩니다
=> 마지막으로 repository가서 자신이 커밋한거 확인하시면 끝입니다.


두번째 push
git status -> git add . -> git commit -m "Second commit I did something" -> git push --> 오류가 난다면 다시 merge해야하므로 -> git pull -> esc -> :wq -> enter  --=> git push -> repository와서 확인해보기 == 끝





