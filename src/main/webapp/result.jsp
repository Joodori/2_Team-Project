<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="pj2.ResultDAO, pj2.ResultVO, pj2.P1CardVO, pj2.P2CardVO, pj2.GameDAO" %>
<%
    String p1Name = (String) session.getAttribute("p1Name");
    String p2Name = (String) session.getAttribute("p2Name");

    pj2.ResultDAO rdao = new pj2.ResultDAO();
    pj2.GameDAO gdao = new pj2.GameDAO();
    pj2.ResultVO result = null;

    try {
        result = rdao.getLastResult(p1Name, p2Name);
    } catch(Exception e) {
        e.printStackTrace();
    }

    String winner = (result != null && result.getWinner() != null) ? result.getWinner() : "무승부";
    String penalty = (result != null && result.getPenalty() != null) ? result.getPenalty() : "-";

    List<pj2.P1CardVO> p1Cards = new ArrayList<>();
    List<pj2.P2CardVO> p2Cards = new ArrayList<>();
    int p1TotalHp = 0, p2TotalHp = 0;

    try {
        p1Cards = gdao.getP1Cards(p1Name);
        p2Cards = gdao.getP2Cards(p2Name);
        for(pj2.P1CardVO c : p1Cards) p1TotalHp += c.getP1CardHp();
        for(pj2.P2CardVO c : p2Cards) p2TotalHp += c.getP2CardHp();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>게임 결과</title>

<!-- Bootstrap & Metronic -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="canonical" href="http://preview.keenthemes.com/index.html" />
<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
<link href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/plugins/custom/datatables/datatables.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />

<style>
  body{
    min-height:100vh;
    background: radial-gradient(1200px 500px at 10% 10%, rgba(59,130,246,.15), transparent 60%),
                radial-gradient(900px 500px at 90% 0%, rgba(16,185,129,.12), transparent 60%),
                linear-gradient(180deg, #0f172a 0%, #0b1023 100%);
    color:#e5e7eb;
  }
  .container-main{ max-width:1200px; }

  /* Hero */
  .hero{
    background:linear-gradient(135deg, rgba(255,255,255,.06), rgba(255,255,255,.03));
    border:1px solid rgba(255,255,255,.08);
    backdrop-filter:blur(8px);
    border-radius:1.5rem;
    padding:2rem;
    box-shadow:0 20px 40px rgba(0,0,0,.4);
  }
  .badge-mode{
    background:rgba(16,185,129,.25);
    color:#d1fae5;
    border:1px solid rgba(16,185,129,.35);
  }
  .stat-pill{
    border:1px solid rgba(255,255,255,.15);
    background:rgba(255,255,255,.06);
    color:#e5e7eb; border-radius:999px;
    padding:.35rem .7rem; font-size:.9rem;
  }
  .trophy{
    width:42px;height:42px; display:grid; place-items:center;
    border-radius:50%; background:linear-gradient(135deg,#fbbf24,#f59e0b);
    color:#0b1023; border:2px solid rgba(255,255,255,.3);
    box-shadow:0 8px 24px rgba(245,158,11,.35);
  }

  /* Cards */
  .card-glass{
    background:rgba(255,255,255,.06);
    border:1px solid rgba(255,255,255,.08);
    backdrop-filter:blur(6px);
    border-radius:1rem;
    transition:transform .15s ease, box-shadow .2s ease;
  }
  .card-glass:hover{ transform:translateY(-3px); box-shadow:0 .75rem 1.5rem rgba(0,0,0,.25); }

  .dead{
    background:linear-gradient(135deg, rgba(244,63,94,.18), rgba(244,63,94,.08));
    border-color:rgba(244,63,94,.35);
  }
  .hp-bar{ height:.6rem; }
  .label-dead{
    background:rgba(244,63,94,.25);
    border:1px solid rgba(244,63,94,.4);
    color:#fecaca; border-radius:.5rem;
    padding:.2rem .5rem; font-weight:700; font-size:.8rem;
  }

  /* Sticky footer actions */
  .sticky-actions{
    position:sticky; bottom:0; z-index:50;
    background:rgba(2,6,23,.85);
    backdrop-filter:blur(8px);
    border-top:1px solid rgba(255,255,255,.08);
  }
  .btn-restart{
    background:linear-gradient(135deg,#22d3ee,#6366f1);
    border:none; color:#0b1023; font-weight:800;
    border-radius:1rem; padding:.9rem 1.25rem;
    box-shadow:0 10px 30px rgba(99,102,241,.35);
  }
</style>
</head>

<body>
<div class="container-main mx-auto py-5">

  <!-- Hero / Summary -->
  <div class="hero mb-5">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
      <div>
        <span class="badge badge-mode px-3 py-2 mb-3">MATCH SUMMARY</span>
        <h1 class="text-white fw-bold mb-2">게임 결과</h1>
        <div class="d-flex flex-wrap align-items-center gap-2 text-gray-300">
          <span class="stat-pill">P1 HP <strong class="ms-1 text-white"><%= p1TotalHp %></strong></span>
          <span class="stat-pill">P2 HP <strong class="ms-1 text-white"><%= p2TotalHp %></strong></span>
          <span class="stat-pill">벌칙 <strong class="ms-1 text-white"><%= penalty %></strong></span>
        </div>
      </div>

      <div class="d-flex align-items-center gap-3">
        <div class="text-end">
          <div class="text-gray-400 small">승자</div>
          <div class="d-flex align-items-center gap-2">
            <div class="trophy">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M17 3h-2V1H9v2H7a1 1 0 0 0-1 1v3a4 4 0 0 0 3 3.87V13H7v2h10v-2h-2V10.87A4 4 0 0 0 18 7V4a1 1 0 0 0-1-1zm-8 1h6v2a2 2 0 1 1-6 0V4zM5 5H3v2a4 4 0 0 0 4 4V9a2 2 0 0 1-2-2V5zm16 0h-2v2a2 2 0 0 1-2 2v2a4 4 0 0 0 4-4V5z"/></svg>
            </div>
            <div class="fs-2 fw-extrabold text-white"><%= winner %></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Players Final Decks -->
  <div class="row g-4">
    <!-- Player 1 -->
   <div class="col-12 col-xl-6">
  <div class="card card-glass h-100">
    <div class="card-header border-0 d-flex justify-content-between align-items-center">
      <h3 class="text-white fw-semibold m-0">Player 1 최종 카드</h3>
      <span class="stat-pill">총 HP <strong class="ms-1 text-white"><%= p1TotalHp %></strong></span>
    </div>
    <div class="card-body">
      <div class="row g-3">
        <% for (P1CardVO c : p1Cards) {
             boolean isDead = c.getP1CardHp() <= 0;
             int bar = Math.max(0, Math.min(100, c.getP1CardHp())); // HP 그대로 %로 가정
        %>
          <div class="col-12 col-md-6">
            <div class="card card-glass <%= isDead ? "dead" : "" %> h-100">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                  <h6 class="text-white fw-bold mb-1"><%= c.getP1CardName() %></h6>
                  <span class="stat-pill">ATK <strong><%= c.getP1CardAtt() %></strong></span>
                </div>
                <div class="text-gray-300 small mb-2"><%= c.getP1Detail() %></div>
                <div class="d-flex justify-content-between text-gray-300 small">
                  <span>HP</span>
                  <span class="<%= isDead ? "text-danger fw-bold" : "text-white fw-bold" %>"><%= c.getP1CardHp() %></span>
                </div>
                <div class="progress hp-bar mt-1 bg-dark">
                  <div class="progress-bar <%= isDead ? "bg-danger" : "" %>" style="width:<%= bar %>%"></div>
                </div>
                <% if(isDead){ %>
                  <div class="mt-2 label-dead d-inline-block">쓰러짐</div>
                <% } %>
              </div>
            </div>
          </div>
        <% } %>
      </div>
    </div>
  </div>
</div>

<!-- Player 2 -->
<div class="col-12 col-xl-6">
  <div class="card card-glass h-100">
    <div class="card-header border-0 d-flex justify-content-between align-items-center">
      <h3 class="text-white fw-semibold m-0">Player 2 최종 카드</h3>
      <span class="stat-pill">총 HP <strong class="ms-1 text-white"><%= p2TotalHp %></strong></span>
    </div>
    <div class="card-body">
      <div class="row g-3">
        <% for (P2CardVO c : p2Cards) {
             boolean isDead = c.getP2CardHp() <= 0;
             int bar = Math.max(0, Math.min(100, c.getP2CardHp())); 
        %>
          <div class="col-12 col-md-6">
            <div class="card card-glass <%= isDead ? "dead" : "" %> h-100">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                  <h6 class="text-white fw-bold mb-1"><%= c.getP2CardName() %></h6>
                  <span class="stat-pill">ATK <strong><%= c.getP2CardAtt() %></strong></span>
                </div>
                <div class="text-gray-300 small mb-2"><%= c.getP2Detail() %></div>
                <div class="d-flex justify-content-between text-gray-300 small">
                  <span>HP</span>
                  <span class="<%= isDead ? "text-danger fw-bold" : "text-white fw-bold" %>"><%= c.getP2CardHp() %></span>
                </div>
                <div class="progress hp-bar mt-1 bg-dark">
                  <div class="progress-bar <%= isDead ? "bg-danger" : "" %>" style="width:<%= bar %>%"></div>
                </div>
                <% if(isDead){ %>
                  <div class="mt-2 label-dead d-inline-block">쓰러짐</div>
                <% } %>
              </div>
            </div>
          </div>
        <% } %>
      </div>
    </div>
  </div>
</div>


  <!-- Sticky Actions -->
  <div class="sticky-actions mt-5">
    <div class="container-main mx-auto py-3 d-flex flex-wrap align-items-center justify-content-between gap-3">
      <div class="text-gray-300">
        최종 결과: <span class="badge bg-success"><%= winner %></span>
        <span class="ms-2">벌칙: <span class="badge bg-danger"><%= penalty %></span></span>
      </div>
      <div>
        <a href="resetGame.jsp" class="btn-restart">다시 시작</a>
      </div>
    </div>
  </div>

</div>

<!-- JS bundles -->
<script src="assets/plugins/global/plugins.bundle.js"></script>
<script src="assets/js/scripts.bundle.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
