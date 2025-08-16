<!-- 게임시작 첫번째 페이지 -->
<!-- 들어간 기능 : head태그 에서 제일 먼저 result 테이블에서 전적을 받아옴 스크립틀릿 이용 ! -->
<!-- JSTL core library tag를 이용하여 전적을 반복해서 뽑아주었음 -->
<!-- form에서 다음 페이지로 보낼 때 post방식을 이용해서 다음 페이지에 parameter를 넘겨줄 때 url에 보이지않게 전달함 -->
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
<title>카드 게임 대전</title>

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
    // --- 서버 사이드 데이터 준비 ---
    ResultDAO dao = new ResultDAO();
    List<ResultVO> record = dao.showRecord();
    request.setAttribute("recordList", record);
    
    String p1Name = request.getParameter("p1Name");
    String p2Name = request.getParameter("p2Name");

    if (p1Name != null && !p1Name.trim().isEmpty() && p2Name != null && !p2Name.trim().isEmpty()) {
        // 진짜 입력값 세션 저장
        session.setAttribute("p1Name", p1Name);
        session.setAttribute("p2Name", p2Name);

        // DB에 addPlayers로 초기 row 생성
        ResultDAO.addPlayers(p1Name, p2Name);

        response.sendRedirect("selectP1Card.jsp"); return;
    }
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

  /* ===== 헤더(히어로) ===== */
  .hero {
    position: relative;
    border-radius: 1.5rem;
    padding: 2.5rem;
    background: linear-gradient(135deg, rgba(255,255,255,.06), rgba(255,255,255,.03));
    backdrop-filter: blur(8px);
    border: 1px solid rgba(255,255,255,.08);
    box-shadow: 0 20px 40px rgba(0,0,0,.4);
  }
  .hero .badge-mode {
    background: rgba(59,130,246,.2);
    color: #cfe1ff;
    border: 1px solid rgba(59,130,246,.35);
  }

  /* ===== 플레이어 카드 ===== */
  .player-card {
    background: rgba(255,255,255,.06);
    border: 1px solid rgba(255,255,255,.08);
    backdrop-filter: blur(8px);
    border-radius: 1.25rem;
    transition: transform .15s ease, box-shadow .2s ease;
  }
  .player-card:hover { transform: translateY(-3px); }

  .symbol.symbol-150px { width:150px; height:150px; }
  .symbol .symbol-label {
    background: rgba(255,255,255,.08);
    border: 1px dashed rgba(255,255,255,.2);
  }

  /* VS 배지 */
  .vs-badge {
    width: 72px; height: 72px;
    display: grid; place-items:center;
    border-radius: 50%;
    background: linear-gradient(135deg, #60a5fa, #34d399);
    color: #0b1023;
    font-weight: 800;
    letter-spacing: .5px;
    box-shadow: 0 12px 30px rgba(56,189,248,.35);
    border: 3px solid rgba(255,255,255,.25);
  }

  /* 시작 버튼 */
  .btn-start {
    padding:.9rem 2rem;
    border-radius: 1rem;
    font-weight: 700;
    letter-spacing: .3px;
    background: linear-gradient(135deg, #6366f1, #22d3ee);
    border: none;
    color: #0b1023;
    box-shadow: 0 10px 30px rgba(99,102,241,.35);
  }
  .btn-start:hover { opacity: .95; }

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
    <!-- ===== Hero Header ===== -->
    <div class="hero mb-5">
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div>
          <div class="badge badge-mode px-3 py-2 mb-3">PVP · BEST OF 1</div>
          <h1 class="text-white fw-bold mb-2">카드 게임 대전</h1>
          <div class="text-gray-400">플레이어 이름을 입력하고, 최고의 카드 마스터에 도전하세요!</div>
        </div>
        <div class="d-flex align-items-center gap-3">
          <!-- 간단한 통계 위젯 -->
          <div class="text-end">
            <div class="fs-2hx fw-bold text-white">
              <%= (record != null) ? record.size() : 0 %>
            </div>
            <div class="text-gray-400">누적 매치</div>
          </div>
          <div class="vr opacity-25"></div>
          <div class="text-end">
            <div class="fs-2hx fw-bold text-white">
              <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor" class="me-1" style="vertical-align:-4px;"><path d="M15 17l-3-3-3 3V5h6v12zM5 19h14v2H5z"/></svg>
              GO
            </div>
            <div class="text-gray-400">지금 시작</div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Form 영역 ===== -->
    <form action="selectP1Card.jsp" name="form1" class="mb-5">
      <div class="row g-4 align-items-stretch">
        <!-- Player 1 -->
        <div class="col-12 col-lg-5">
          <div class="player-card h-100 card p-4">
            <div class="d-flex flex-column align-items-center text-center h-100">
              <div class="symbol symbol-150px mb-4">
                <div class="symbol-label d-flex align-items-center justify-content-center">
                  <img src="/pj2/assets/media/custom/player.png" class="h-100" alt="player1">
                </div>
              </div>
              <h3 class="text-white fw-semibold mb-2">Player 1</h3>
              <div class="text-gray-400 mb-4">닉네임을 입력하세요</div>

              <div class="input-group input-group-lg">
                <span class="input-group-text bg-transparent text-gray-300 border-secondary-subtle">
                  <!-- 사용자 아이콘 -->
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8V22h19.2v-2.8c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
                </span>
                <input type="text" class="form-control form-control-lg bg-transparent text-white border-secondary-subtle" 
                       name="p1Name" id="p1Name" placeholder="player1의 이름" maxlength="20" autocomplete="off">
              </div>
            </div>
          </div>
        </div>

        <!-- VS Badge -->
        <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">
          <div class="vs-badge">VS</div>
        </div>

        <!-- Player 2 -->
        <div class="col-12 col-lg-5">
          <div class="player-card h-100 card p-4">
            <div class="d-flex flex-column align-items-center text-center h-100">
              <div class="symbol symbol-150px mb-4">
                <div class="symbol-label d-flex align-items-center justify-content-center">
                  <img src="/pj2/assets/media/custom/player.png" class="h-100" alt="player2">
                </div>
              </div>
              <h3 class="text-white fw-semibold mb-2">Player 2</h3>
              <div class="text-gray-400 mb-4">닉네임을 입력하세요</div>

              <div class="input-group input-group-lg">
                <span class="input-group-text bg-transparent text-gray-300 border-secondary-subtle">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8V22h19.2v-2.8c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
                </span>
                <input type="text" class="form-control form-control-lg bg-transparent text-white border-secondary-subtle" 
                       name="p2Name" id="p2Name" placeholder="player2의 이름" maxlength="20" autocomplete="off">
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 시작 버튼 -->
      <div class="text-center mt-5">
        <button type="button" class="btn btn-start" onclick="start()">
          <span class="me-2">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
          </span>
          시작하기
        </button>
        <div class="form-text mt-3 text-gray-400">
          두 플레이어 모두 닉네임을 입력하면 대전이 시작됩니다.
        </div>
      </div>
    </form>

    <!-- ===== 전적 테이블 ===== -->
    <div class="card card-glass">
      <div class="card-header border-0 pt-4 pb-0">
        <div class="card-title">
          <span class="svg-icon svg-icon-2 me-2">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M5 4h14v2H5V4zm0 4h14v10H5V8zm2 2v6h10v-6H7z"/></svg>
          </span>
          <h3 class="text-white fw-semibold m-0">전적 기록</h3>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-row-dashed align-middle gs-0 gy-3">
            <thead>
              <tr class="text-start fw-semibold fs-7 text-uppercase">
                <th>Player 1</th>
                <th>Player 2</th>
                <th>승리자</th>
                <th>벌칙</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${recordList}" var="record">
                <tr>
                  <td class="fw-semibold text-gray-300">${record.p1_name}</td>
                  <td class="fw-semibold text-gray-300">${record.p2_name}</td>
                  <td>
                    <span class="badge badge-light-success text-success fw-bold">
                      <!-- 트로피 아이콘 -->
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" class="me-1"><path d="M17 3h-2V1H9v2H7a1 1 0 0 0-1 1v3a4 4 0 0 0 3 3.87V13H7v2h10v-2h-2V10.87A4 4 0 0 0 18 7V4a1 1 0 0 0-1-1zm-8 1h6v2a2 2 0 1 1-6 0V4zM5 5H3v2a4 4 0 0 0 4 4V9a2 2 0 0 1-2-2V5zm16 0h-2v2a2 2 0 0 1-2 2v2a4 4 0 0 0 4-4V5z"/></svg>
                      ${record.winner}
                    </span>
                  </td>
                  <td class="text-gray-300">${record.penalty}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty recordList}">
                <tr>
                  <td colspan="4" class="text-center text-gray-400">아직 전적이 없습니다. 첫 경기를 시작해보세요!</td>
                </tr>
              </c:if>
            </tbody>
          </table>
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

  <script>
    // 현재 연도
    document.getElementById('year').textContent = new Date().getFullYear();

    const p1Name = document.getElementById("p1Name");
    const p2Name = document.getElementById("p2Name");

    function shake(el) {
      el.classList.add('animate__animated','animate__shakeX');
      setTimeout(()=>el.classList.remove('animate__animated','animate__shakeX'), 700);
    }

    function start() {
      const n1 = p1Name.value.trim();
      const n2 = p2Name.value.trim();

      if (!n1 || !n2) {
        // Metronic 스타일 알림 (간단 alert 대체)
        const msg = !n1 && !n2 ? '두 플레이어의 이름을 입력하세요.' : (!n1 ? 'Player 1의 이름을 입력하세요.' : 'Player 2의 이름을 입력하세요.');
        window.alert(msg); // 프로젝트에 SweetAlert 등 쓰신다면 여기서 교체 가능
        if (!n1) shake(p1Name.closest('.player-card'));
        if (!n2) shake(p2Name.closest('.player-card'));
        return;
      }

      // 이름이 동일하면 경고
      if (n1 === n2) {
        if (!confirm('두 플레이어 이름이 같습니다. 그대로 진행할까요?')) return;
      }

      document.form1.submit();
    }
  </script>

  <!-- 선택: animate.css(있다면 살짝 흔들림 효과). 없다면 위 shake()는 무시 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

</body>
</html>