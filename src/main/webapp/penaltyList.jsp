<%@page import="pj2.PenaltyVO"%>
<%@page import="java.util.List"%>
<%@page import="pj2.ResultDAO"%>
<%@page import="pj2.ResultVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>벌칙 확인 페이지</title>

<!-- Bootstrap (CSS) -->
<link rel="stylesheet" href="css/bootstrap.min.css">

<!-- Metronic (CSS) -->
<link rel="canonical" href="http://preview.keenthemes.com/index.html" />
<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
<link href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/plugins/custom/datatables/datatables.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />

<%

    ResultDAO dao = new ResultDAO();
    List<PenaltyVO> pList = dao.showPenalty();
    request.setAttribute("penaltyList", pList);
    
%>


<style>
  /* ===== 배경 & 전체 레이아웃 ===== */
  body {
    min-height: 100vh;
    background: radial-gradient(1200px 500px at 10% 10%, rgba(59,130,246,.15), transparent 60%),
                radial-gradient(900px 500px at 90% 0%, rgba(16,185,129,.12), transparent 60%),
                linear-gradient(180deg, #0f172a 0%, #0b1023 100%);
    color: #e5e7eb;
  }
  .container-main {
    max-width: 1100px;
  }

  /* 전적 카드 테이블 */
  .card-glass {
    background: rgba(255,255,255,.06);
    border: 1px solid rgba(255,255,255,.08);
    backdrop-filter: blur(6px);
    border-radius: 1.25rem;
  }
  .table thead th {
    color: #cbd5e1 !important;
    border-bottom: 1px solid rgba(255,255,255,.12) !important;
  }
  .table tbody td {
    color: #e5e7eb;
    border-color: rgba(255,255,255,.06) !important;
  }

  /* 하단 푸터 */
  .mini-footer {
    color: #94a3b8;
    font-size: .9rem;
  }
</style>
</head>

<body>
  <div class="container-main mx-auto py-5">
   
    <!-- ===== 전적 테이블 ===== -->
    <div class="card card-glass">
      <div class="card-header border-0 pt-4 pb-0">
        <div class="card-title">
          <span class="svg-icon svg-icon-2 me-2">
            <svg width="30" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M5 4h14v2H5V4zm0 4h14v10H5V8zm2 2v6h10v-6H7z"/></svg>
          </span>
          <h3 class="text-white fw-semibold m-0">벌칙 목록</h3>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-row-dashed align-middle gs-0 gy-3">
            <thead>
              <tr class="text-start fw-semibold fs-7 text-uppercase">
                <th>NO.</th>
                <th>벌칙 내용</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${penaltyList}" var="pList">
                <tr>
                  <td class="fw-semibold text-gray-300">${pList.id}</td>
                  <td class="fw-semibold text-gray-300">${pList.detail}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty penaltyList}">
                <tr>
                  <td colspan="4" class="text-center text-gray-400">아직 벌칙이 없습니다. 첫번째 벌칙을 추가해보세요!</td>
                </tr>
              </c:if>
            </tbody>
          </table>
          <div align="center">
              <form action="first.jsp">
              	<button type="submit" class="btn btn-primary"><span class="text-center text-white-400">시작화면으로 돌아가기</span></button>
              </form>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Footer ===== -->
    <div class="mini-footer text-center mt-4">
      © <span id="year"></span> Card Battle Arena · Built with Bootstrap & Metronic
    </div>
  </div>

  <!-- ===== Metronic & Bootstrap (JS) ===== -->
  <script src="assets/plugins/global/plugins.bundle.js"></script>
  <script src="assets/js/scripts.bundle.js"></script>
  <script src="js/bootstrap.bundle.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <script>
    // 현재 연도
    document.getElementById('year').textContent = new Date().getFullYear();
	
    const penalty = document.getElementById("addPenalty");
    const p1Name = document.getElementById("p1Name");
    const p2Name = document.getElementById("p2Name");

    function start() {
      const n1 = p1Name.value.trim();
      const n2 = p2Name.value.trim();

      if (!n1 || !n2) {
        // Metronic 스타일 알림 (간단 alert 대체)
        // 삼항 연산자 사용 &&이 모두 참이면 : 의 왼쪽부분 , 아니면 괄호에서 선택해서 사용
        const msg = !n1 && !n2 ? '두 플레이어의 이름을 입력하세요.' : (!n1 ? 'Player 1의 이름을 입력하세요.' : 'Player 2의 이름을 입력하세요.');
        window.alert(msg);
        return;
      }

      // 이름이 동일하면 경고
      if (n1 === n2) {
        if (!confirm('두 플레이어 이름이 같습니다. 그대로 진행할까요?')) return;
      }

      document.form1.submit();
    }
    
    function addPenaltyList() {
    	  const input = document.getElementById("addPenalty");
    	  const penalty = input.value.trim();
    	  if (!penalty) {
    	    alert("벌칙 내용을 입력해주세요.");
    	    return;
    	  }
    	  $.ajax({
    	    url: 'addPenalty.jsp',
    	    type: 'POST',
    	    data: { penalty: penalty },
    	    success: function(response) {
    	      alert('벌칙이 추가되었습니다.');
    	      input.value = ""; // 벌칙 추가되면 알림 + input값 비워놓기
    	    }
    	  });
    	}
  </script>

  <!-- 선택: animate.css(있다면 살짝 흔들림 효과). 없다면 위 shake()는 무시 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

</body>
</html>