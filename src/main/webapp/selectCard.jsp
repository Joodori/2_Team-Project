<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,pj2.GameDAO,pj2.CardVO" %>
<!DOCTYPE html>

<html>

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
</head>

<body>
<div class="container mt-4">
  <h1 class="text-center mb-4">카드선택</h1>

  <%
  GameDAO dao = new GameDAO();
  List<CardVO> cardList = dao.getRandomCardList();
  %>

  <form method="post" action="selectCardProcess.jsp" onsubmit="return validateSelection();">
  <div class="row row-cols-2 row-cols-sm-3 row-cols-md-5 g-3">
  <% for(CardVO card : cardList) {
       String path = (card.getImgPath()==null || card.getImgPath().isEmpty())
                     ? "assets/media/avatars/300-25.jpg"
                     : card.getImgPath();
  %>
    <div class="col">
      <div class="card h-100" onclick="toggleSelect(this)">
        <img src="/pj2/<%= path %>" class="card-img-top" alt="<%= card.getCardName() %>">
        <div class="card-body text-center">
          <h5 class="cardName">카드이름: <%= card.getCardName() %></h5>
          <h5 class="cardAtt">공격력: <%= card.getAtt() %></h5>
          <h5 class="cardHp">체력: <%= card.getHp() %></h5>
          <!-- 체크박스를 보이지 않게 하면서 선택값으로 사용 -->
          <input type="checkbox" name="selectedCardId" value="<%= card.getCardId() %>" style="display:none;">
        </div>
      </div>
    </div>
  <% } %>
  </div>
  <br>
  <button type="submit" class="btn btn-primary">다음으로</button>
  </form>
</div>

<script>
// 카드 선택 토글 함수 (카드 클릭 시 스타일 토글 + 체크박스 체크/해제)
function toggleSelect(cardDiv) {
  cardDiv.classList.toggle('selected');
  var checkbox = cardDiv.querySelector('input[type="checkbox"]');
  checkbox.checked = !checkbox.checked;
}

// 제출 전 선택 카드 3장 체크
function validateSelection() {
  var checked = document.querySelectorAll('input[name="selectedCardId"]:checked');
  if (checked.length !== 3) {
    alert('정확히 3장을 선택하세요.');
    return false;
  }
  return true;
}
</script>

<style>
h1 {
  margin-top: 10px;
}

.card {
  transition: transform .18s ease, box-shadow .18s ease, outline-color .18s ease;
  cursor: pointer; /* 카드 위에 커서 = 손가락 */
}
.card:hover {
  transform: translateY(-2px) scale(1.03);
  box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
}
.card.selected {
  outline: 3px solid #0d6efd;   /* 선택 표시 (파란 테두리) */
  outline-offset: 2px;
  box-shadow: 0 .5rem 1rem rgba(13,110,253,.25);
}
/* 이미지 드래그 선택 방지 */
.card-img-top {
  -webkit-user-drag: none;
  user-select: none;
}
</style>
</body>
</html>