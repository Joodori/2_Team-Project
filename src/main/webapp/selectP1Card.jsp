<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List,pj2.GameDAO,pj2.CardVO, pj2.ResultDAO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">

<title>Insert title here</title>

<!--부트스트랩 -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<!-- 메트로닉 -->
<link rel="canonical" href="http://preview.keenthemes.comindex.html" />
		<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
		<!--begin::Fonts(mandatory for all pages)-->
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
		<!--end::Fonts-->
		<!--begin::Vendor Stylesheets(used for this page only)-->
		<link href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet" type="text/css" />
		<link href="assets/plugins/custom/datatables/datatables.bundle.css" rel="stylesheet" type="text/css" />
		<!--end::Vendor Stylesheets-->
		<!--begin::Global Stylesheets Bundle(mandatory for all pages)-->
		<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
		<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
		
		
			<%
    // 이름은 세션에서 일관되게 사용
    String p1Name = (String) session.getAttribute("p1Name");
    String p2Name = (String) session.getAttribute("p2Name");
    // 혹시 이전 단계에서 세션이 비었다면 요청 파라미터로도 한번 더 시도
    if (p1Name == null || p1Name.trim().isEmpty()) p1Name = request.getParameter("p1Name");
    if (p2Name == null || p2Name.trim().isEmpty()) p2Name = request.getParameter("p2Name");
    if (p1Name != null && !p1Name.trim().isEmpty()) session.setAttribute("p1Name", p1Name);
    if (p2Name != null && !p2Name.trim().isEmpty()) session.setAttribute("p2Name", p2Name);
    // addPlayers는 first.jsp 또는 fight.jsp(세이프가드)에서만 호출

GameDAO dao = new GameDAO();
  				List<CardVO> cardList = dao.getRandomCardList();
			%>



<style>

  body{

    min-height:100vh;

    background: radial-gradient(1200px 500px at 10% 10%, rgba(59,130,246,.15), transparent 60%),

                radial-gradient(900px 500px at 90% 0%, rgba(16,185,129,.12), transparent 60%),

                linear-gradient(180deg, #0f172a 0%, #0b1023 100%);

    color:#e5e7eb;

  }

  .container-main{ max-width:1200px; }

  .hero{

    background:linear-gradient(135deg, rgba(255,255,255,.06), rgba(255,255,255,.03));

    border:1px solid rgba(255,255,255,.08);

    backdrop-filter:blur(8px);

    border-radius:1.5rem;

    padding:2rem;

    box-shadow:0 20px 40px rgba(0,0,0,.4);

  }

  .badge-mode{

    background:rgba(99,102,241,.25);

    color:#dbeafe;

    border:1px solid rgba(99,102,241,.35);

  }

  .card-glass{

  	--bs-card-color: #e5e7eb;

    background:rgba(255,255,255,.06);

    border:1px solid rgba(255,255,255,.08);

    backdrop-filter:blur(6px);

    border-radius:1rem;

    transition:transform .15s ease, box-shadow .2s ease, outline-color .2s ease;

    cursor:pointer;

    height:100%;

  }

  .card-glass:hover{ transform:translateY(-3px); box-shadow:0 .75rem 1.5rem rgba(0,0,0,.25); }

  .card-glass.selected{

    outline:3px solid #22d3ee;

    outline-offset:2px;

    box-shadow:0 .75rem 1.5rem rgba(34,211,238,.35);

  }

  .card-img-top{ -webkit-user-drag:none; user-select:none; }

  .sticky-progress{

    position:sticky; bottom:0; z-index:50;

    background:rgba(2,6,23,.75);

    backdrop-filter:blur(8px);

    border-top:1px solid rgba(255,255,255,.08);

  }

  .btn-next{

    background:linear-gradient(135deg,#6366f1,#22d3ee);

    border:none; color:#0b1023;

    font-weight:700; border-radius:1rem;

    padding:.9rem 1.5rem;

    box-shadow:0 10px 30px rgba(99,102,241,.35);

  }

  .btn-toggle{

  	background: linear-gradient(135deg,#6366f1,#22d3ee);

  	border: none;

  	color: #0b1023;

  	font-weight: 700;

  	border-radius: 1rem;

  	padding: .6rem .9rem;

  	box-shadow: 0 10px 30px rgba(99,102,241,.35);

  	transition: transform .12s ease, opacity .12s ease;

  }

  .btn-toggle:hover{ opacity:.95; transform: translateY(-1px); }

  .btn-toggle:focus{ outline:0; box-shadow: 0 0 0 .25rem rgba(34,211,238,.35); }

  .card-galss.selected .btn-toggle{

  	background: linear-gradient(135deg,#22d3ee,#6366f1);

  }

  .mini-pill{

    border:1px solid rgba(255,255,255,.15);

    background:rgba(255,255,255,.06);

    color:#e5e7eb; border-radius:999px;

  }

  .thumb{

    width:44px;height:44px;object-fit:cover;border-radius:.5rem;border:1px solid rgba(255,255,255,.15);

  }

</style>

</head>



<body>

<div class="container-main mx-auto py-5">



  <!-- Hero -->

  <div class="hero mb-5">

    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">

      <div>

        <span class="badge badge-mode px-3 py-2 mb-3">PLAYER 1 · PICK 3</span>

        <h1 class="text-white fw-bold mb-2">카드 선택</h1>

        <div class="text-gray-400">원하는 카드를 최대 <strong>3장</strong>까지 선택하세요. 선택 후 하단의 <b>다음으로</b> 버튼을 눌러 진행합니다.</div>

      </div>

      <div class="d-flex align-items-center gap-3">

        <div class="text-end">

          <div class="fs-2hx fw-bold text-white"><%= (cardList!=null? cardList.size():0) %></div>

          <div class="text-gray-400">추천 카드</div>

        </div>

        <div class="vr opacity-25"></div>

        <div class="text-end">

          <div class="fs-2hx fw-bold text-white" id="pickCounter">0/3</div>

          <div class="text-gray-400">선택 수</div>

        </div>

      </div>

    </div>

  </div>



  <!-- 카드 그리드 -->

  <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-xl-5 g-4">

    <%

      for(CardVO card : cardList){

        String path = (card.getImgPath()==null || card.getImgPath().isEmpty())

                      ? "assets/media/avatars/300-25.jpg"

                      : card.getImgPath();

    %>

      <div class="col">

        <div class="card card-glass h-100" 

             data-name="<%= card.getCardName() %>" 

             data-att="<%= card.getAtt() %>" 

             data-hp="<%= card.getHp() %>" 

             data-detail="<%= card.getDetail() %>" 

             data-img="/pj2/<%= path %>">

          <img src="/pj2/<%= path %>" class="card-img-top" alt="<%= card.getCardName() %>">

          <div class="card-body">

            <div class="d-flex align-items-start justify-content-between">

              <h5 class="text-white fw-semibold mb-2"><%= card.getCardName() %></h5>

              <span class="badge mini-pill px-2 py-1">ATK <%= card.getAtt() %></span>

            </div>

            <div class="d-flex align-items-center justify-content-between">

              <span class="text-gray-300">HP <strong class="text-white"><%= card.getHp() %></strong></span>

              <span class="badge mini-pill px-2 py-1">특징</span>

            </div>

            <div class="text-gray-400 small mt-2"><%= card.getDetail() %></div>

          </div>

          <div class="card-footer border-0 pt-0 pb-3 px-3 bg-transparent">

            <button type="button" class="btn w-100 btn-sm fw-bold btn-toggle">선택하기</button>

          </div>

        </div>

      </div>

    <% } %>

  </div>



  <!-- 하단 진행 바 -->

  <div class="sticky-progress mt-4">

    <div class="container-main mx-auto py-3 d-flex flex-wrap align-items-center justify-content-between gap-3">

      <div class="d-flex align-items-center gap-2" id="selectedThumbs"></div>

      <div class="d-flex align-items-center gap-3">

        <span class="text-gray-300">선택: <strong id="pickCounter2">0</strong> / <strong>3</strong></span>

        <button class="btn-next" type="button" id="btnNext" disabled onclick="goToP2SelectCard()">

          다음으로

          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" class="ms-1"><path d="M8 5v14l11-7z"/></svg>

        </button>

      </div>

    </div>

  </div>



</div>



<!-- 선택 데이터 POST -->

<form id="p1Form" method="post" action="saveP1Cards.jsp" class="d-none">

  <div id="selectedCardsWrap"></div>

</form>



<!-- Toast 영역 -->

<div class="position-fixed top-0 end-0 p-3" style="z-index:1080">

  <div id="toastPick" class="toast align-items-center text-bg-dark border-0" role="alert" aria-live="assertive" aria-atomic="true">

    <div class="d-flex">

      <div class="toast-body" id="toastMsg">카드가 추가되었습니다.</div>

      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>

    </div>

  </div>

</div>



<!-- JS -->

<script src="assets/plugins/global/plugins.bundle.js"></script>

<script src="assets/js/scripts.bundle.js"></script>

<script src="js/bootstrap.bundle.min.js"></script>



<script>

  const MAX_PICK = 3;

  const selected = []; // {name,att,hp,detail,img}

  const pickCounter = document.getElementById('pickCounter');

  const pickCounter2 = document.getElementById('pickCounter2');

  const thumbs = document.getElementById('selectedThumbs');

  const wrap = document.getElementById('selectedCardsWrap');

  const btnNext = document.getElementById('btnNext');



  // 카드 클릭/버튼으로 토글 선택

  document.querySelectorAll('.card-glass').forEach(card => {

    const btn = card.querySelector('.btn-toggle');

    function toggle(){

      const data = {

        name: card.dataset.name,

        att: card.dataset.att,

        hp: card.dataset.hp,

        detail: card.dataset.detail,

        img: card.dataset.img

      };

      const idx = selected.findIndex(s => s.name === data.name && s.att === data.att && s.hp === data.hp);



      if (idx >= 0) {

        // 해제

        selected.splice(idx,1);

        card.classList.remove('selected');

        btn.textContent = '선택하기';

        showToast('선택 해제: ' + data.name);

      } else {

        if (selected.length >= MAX_PICK) {

          showToast('최대 ' + MAX_PICK + '장까지 선택 가능합니다.');

          return;

        }

        selected.push(data);

        card.classList.add('selected');

        btn.textContent = '선택됨';

        showToast('선택됨: ' + data.name);

      }

      syncUI();

    }

    card.addEventListener('click', (e)=>{

      // 내부 버튼을 누를 때도 카드 전체 클릭이 중복되지 않도록 처리

      if (e.target.classList.contains('btn-toggle')) {

        toggle();

      } else if (!e.target.closest('.btn-toggle')) {

        toggle();

      }

    });

  });



  function syncUI(){

    // 카운터

    pickCounter.textContent = selected.length + '/' + MAX_PICK;

    pickCounter2.textContent = selected.length;

    // 썸네일

    thumbs.innerHTML = '';

    selected.forEach(s=>{

      const img = document.createElement('img');

      img.src = s.img;

      img.className = 'thumb';

      img.title = s.name;

      thumbs.appendChild(img);

    });

    // 히든 인풋 갱신

    wrap.innerHTML = '';

    selected.forEach(s=>{

      wrap.appendChild(makeInput('cardName', s.name));

      wrap.appendChild(makeInput('cardAtt', s.att));

      wrap.appendChild(makeInput('cardHp', s.hp));

      wrap.appendChild(makeInput('cardDetail', s.detail));

      wrap.appendChild(makeInput('cardImgPath', s.img.replace('/pj2/',''))); // 서버에서 필요 시 경로 정리

    });

    // 다음 버튼

    btnNext.disabled = (selected.length !== MAX_PICK);

  }



  function makeInput(n, v){

    const inp = document.createElement('input');

    inp.type = 'hidden'; inp.name = n; inp.value = v;

    return inp;

  }



  function showToast(msg){

    const el = document.getElementById('toastPick');

    document.getElementById('toastMsg').textContent = msg;

    const t = new bootstrap.Toast(el, { delay: 1200 });

    t.show();

  }



  function goToP2SelectCard(){

    if (selected.length !== MAX_PICK) {

      showToast('카드 ' + MAX_PICK + '장을 모두 선택하세요.');

      return;

    }

    document.getElementById('p1Form').submit();

  }

</script>

</body>

</html>