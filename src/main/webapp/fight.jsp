<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="pj2.GameDAO, pj2.P1CardVO, pj2.P2CardVO, pj2.ResultDAO, java.util.List"%>

<%!
	// P1 카드가 살아있는지 체크
	private boolean isP1CardAlive(List<P1CardVO> cards, int index) {
		return (index < cards.size() && cards.get(index).getP1CardHp() > 0);
	}

	// P2 카드가 살아있는지 체크
	private boolean isP2CardAlive(List<P2CardVO> cards, int index) {
		return (index < cards.size() && cards.get(index).getP2CardHp() > 0);
	}

	// 죽었는지 여부는 살아있는 여부의 반대
	private boolean isP1CardDead(List<P1CardVO> cards, int index) {
		return !isP1CardAlive(cards, index);
	}
	private boolean isP2CardDead(List<P2CardVO> cards, int index) {
		return !isP2CardAlive(cards, index);
	}

	// P1 살아있는 카드 수 반환
	private long countAliveP1(List<P1CardVO> cards) {
		return cards.stream().filter(x -> x.getP1CardHp() > 0).count();
	}

	// P2 살아있는 카드 수 반환
	private long countAliveP2(List<P2CardVO> cards) {
		return cards.stream().filter(x -> x.getP2CardHp() > 0).count();
	}
%>

<%
	int gameID = (int) session.getAttribute("gameID");

	// DAO 객체 생성
	GameDAO dao = new GameDAO();
	ResultDAO rdao = new ResultDAO();

	// 세션에서 플레이어 이름 가져오기
	String player1Name = (String) session.getAttribute("p1Name");
	String player2Name = (String) session.getAttribute("p2Name");

	// 세션 초기화 (최초 실행 시 카드 리스트, 현재 인덱스, 턴, 로그 설정)
	if (session.getAttribute("p1Cards") == null || session.getAttribute("p2Cards") == null) {
		session.setAttribute("p1Cards", dao.getP1Cards(player1Name, gameID)); // modified
		session.setAttribute("p2Cards", dao.getP2Cards(player2Name, gameID)); // modified
		session.setAttribute("p1ActiveIndex", 0); // 현재 사용 중인 카드
		session.setAttribute("p2ActiveIndex", 0);
		session.setAttribute("turn", "p1");       // 첫 턴은 p1부터
		session.setAttribute("battleLog", "");   // 전투 로그 초기화
		session.setAttribute("gameResultSaved", null); // 결과 저장 여부
	}

	// 세션에서 카드 및 상태 불러오기
	List<P1CardVO> p1Cards = (List<P1CardVO>) session.getAttribute("p1Cards");
	List<P2CardVO> p2Cards = (List<P2CardVO>) session.getAttribute("p2Cards");
	int p1Index = (Integer) session.getAttribute("p1ActiveIndex");
	int p2Index = (Integer) session.getAttribute("p2ActiveIndex");
	String turn = (String) session.getAttribute("turn");
	String battleLog = (String) session.getAttribute("battleLog");

	// 현재 카드 생존 여부 / 게임 종료 여부
	boolean p1Alive = countAliveP1(p1Cards) > 0;
	boolean p2Alive = countAliveP2(p2Cards) > 0;
	boolean gameOver = !p1Alive || !p2Alive;

	// ================== 공격 처리 ==================
	String atk = request.getParameter("attack");
	if (atk != null && !gameOver) {
		// P1 턴 → P1 공격
		if ("p1".equals(turn) && isP1CardAlive(p1Cards, p1Index) && isP2CardAlive(p2Cards, p2Index)) {
			P1CardVO attacker = p1Cards.get(p1Index);
			P2CardVO defender = p2Cards.get(p2Index);

			// 공격력 만큼 상대 HP 감소 (최소 0까지)
			int dmg = attacker.getP1CardAtt();
			defender.setP2CardHp(Math.max(0, defender.getP2CardHp() - dmg));

			// 전투 로그 기록
			battleLog += "P1의 " + attacker.getP1CardName() + " → " + defender.getP2CardName() + " : -" + dmg + " HP<br>";

			// 상대 카드 쓰러짐
			if (defender.getP2CardHp() <= 0) {
				battleLog += defender.getP2CardName() + " 쓰러짐!<br>";
				p2Index++; // 다음 카드로 전환
				session.setAttribute("p2ActiveIndex", p2Index);
			}
			turn = "p2"; // 턴 교체
		}
		// P2 턴 → P2 공격
		else if ("p2".equals(turn) && isP2CardAlive(p2Cards, p2Index) && isP1CardAlive(p1Cards, p1Index)) {
			P2CardVO attacker = p2Cards.get(p2Index);
			P1CardVO defender = p1Cards.get(p1Index);

			int dmg = attacker.getP2CardAtt();
			defender.setP1CardHp(Math.max(0, defender.getP1CardHp() - dmg));

			battleLog += "P2의 " + attacker.getP2CardName() + " → " + defender.getP1CardName() + " : -" + dmg + " HP<br>";

			if (defender.getP1CardHp() <= 0) {
				battleLog += defender.getP1CardName() + " 쓰러짐!<br>";
				p1Index++;
				session.setAttribute("p1ActiveIndex", p1Index);
			}
			turn = "p1";
		}
	}

	// 상태 갱신
	p1Alive = countAliveP1(p1Cards) > 0;
	p2Alive = countAliveP2(p2Cards) > 0;
	gameOver = !p1Alive || !p2Alive;

	// ================== 게임 종료 처리 ==================
	if (gameOver && session.getAttribute("gameResultSaved") == null) {
		String p1Name = (String) session.getAttribute("p1Name");
		String p2Name = (String) session.getAttribute("p2Name");

		// 이름 값 보정 (request에서 가져오기)
		if (p1Name == null || p1Name.trim().isEmpty()) p1Name = request.getParameter("p1Name");
		if (p2Name == null || p2Name.trim().isEmpty()) p2Name = request.getParameter("p2Name");

		// 세션에 저장
		if (p1Name != null && !p1Name.trim().isEmpty()) session.setAttribute("p1Name", p1Name);
		if (p2Name != null && !p2Name.trim().isEmpty()) session.setAttribute("p2Name", p2Name);

		// 플레이어 DB에 추가 (최초 1회만)
		if (session.getAttribute("playersAdded") == null) {
			ResultDAO.addPlayers(p1Name, p2Name);
			session.setAttribute("playersAdded", true);
		}

		// 승자 판정
		String winner = "무승부";
		if (!p1Alive && p2Alive) winner = p2Name;
		else if (!p2Alive && p1Alive) winner = p1Name;

		// 패널티 조회
		String penalty = ResultDAO.getPenalty();

		// DB 결과 업데이트
		if (p1Name != null && p2Name != null && !p1Name.trim().isEmpty() && !p2Name.trim().isEmpty()) {
			rdao.updateResult(p1Name, p2Name, winner, penalty);
		}

		session.setAttribute("gameResultSaved", true); // 결과 저장 완료 표시
	}

	// ================== 카드 교체 처리 ==================
	String switchCard = request.getParameter("switchCard");
	if (switchCard != null && !gameOver) {
		int switchIndex = Integer.parseInt(switchCard);


		// P1 턴일 때 카드 교체
		if ("p1".equals(turn) && isP1CardAlive(p1Cards, switchIndex)) {
			p1Index = switchIndex;
			session.setAttribute("p1ActiveIndex", p1Index);
			battleLog += "P1이 " + p1Cards.get(p1Index).getP1CardName() + " 카드를 교체했습니다.<br>";
			turn = "p2";
		}
		// P2 턴일 때 카드 교체
		else if ("p2".equals(turn) && isP2CardAlive(p2Cards, switchIndex)) {
			p2Index = switchIndex;
			session.setAttribute("p2ActiveIndex", p2Index);
			battleLog += "P2가 " + p2Cards.get(p2Index).getP2CardName() + " 카드를 교체했습니다.<br>";
			turn = "p1";
		}
	}


	// 세션 값 최종 갱신
	session.setAttribute("p1Cards", p1Cards);
	session.setAttribute("p2Cards", p2Cards);
	session.setAttribute("battleLog", battleLog);
	session.setAttribute("p1ActiveIndex", p1Index);
	session.setAttribute("p2ActiveIndex", p2Index);
	session.setAttribute("turn", turn);
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>카드 배틀 · 턴제 전투</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>

<!-- Bootstrap & Metronic -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="canonical" href="http://preview.keenthemes.com/index.html" />
<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
<link href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css"
	rel="stylesheet" type="text/css" />
<link href="assets/plugins/custom/datatables/datatables.bundle.css"
	rel="stylesheet" type="text/css" />
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet"
	type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet"
	type="text/css" />

<style>
body {
	min-height: 100vh;
	background: radial-gradient(1200px 500px at 10% 10%, rgba(59, 130, 246, .15),
		transparent 60%),
		radial-gradient(900px 500px at 90% 0%, rgba(16, 185, 129, .12),
		transparent 60%), linear-gradient(180deg, #0f172a 0%, #0b1023 100%);
	color: #e5e7eb;
}

.container-main {
	max-width: 1200px;
}

.hero {
	background: linear-gradient(135deg, rgba(255, 255, 255, .06),
		rgba(255, 255, 255, .03));
	border: 1px solid rgba(255, 255, 255, .08);
	backdrop-filter: blur(8px);
	border-radius: 1.5rem;
	padding: 2rem;
	box-shadow: 0 20px 40px rgba(0, 0, 0, .4);
}

.badge-mode {
	background: rgba(99, 102, 241, .25);
	color: #dbeafe;
	border: 1px solid rgba(99, 102, 241, .35);
}

.duel-col .card-glass {
	background: rgba(255, 255, 255, .06);
	border: 1px solid rgba(255, 255, 255, .08);
	backdrop-filter: blur(6px);
	border-radius: 1rem;
	transition: transform .15s ease, box-shadow .2s ease;
}

.duel-col .card-glass:hover {
	transform: translateY(-3px);
	box-shadow: 0 .75rem 1.5rem rgba(0, 0, 0, .25);
}

.symbol-240 {
	width: 240px;
	height: 240px;
	border-radius: 1rem;
	overflow: hidden;
	border: 1px solid rgba(255, 255, 255, .1);
}

.vs-badge {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	background: linear-gradient(135deg, #60a5fa, #34d399);
	color: #0b1023;
	display: grid;
	place-items: center;
	font-weight: 800;
	border: 3px solid rgba(255, 255, 255, .25);
	box-shadow: 0 12px 30px rgba(56, 189, 248, .35);
}

.stat-pill {
	border: 1px solid rgba(255, 255, 255, .15);
	background: rgba(255, 255, 255, .06);
	color: #e5e7eb;
	border-radius: 999px;
	padding: .25rem .6rem;
	font-size: .85rem;
}

.hp-hit {
	color: #ff6b6b !important;
	font-weight: 800;
	animation: blink .5s ease-in-out 2;
}

@
keyframes blink { 0%{
	opacity: 1
}

50




%
{
opacity




:




0




}
100




%
{
opacity




:




1




}
}
.log-card {
	background: rgba(255, 255, 255, .06);
	border: 1px solid rgba(255, 255, 255, .08);
	border-radius: 1rem;
}

.sticky-actions {
	position: sticky;
	bottom: 0;
	z-index: 50;
	background: rgba(2, 6, 23, .85);
	backdrop-filter: blur(8px);
	border-top: 1px solid rgba(255, 255, 255, .08);
}

.btn-attack {
	background: linear-gradient(135deg, #ef4444, #f59e0b);
	color: #0b1023;
	border: none;
	font-weight: 800;
	border-radius: 1rem;
	padding: .9rem 1.25rem;
	box-shadow: 0 10px 30px rgba(239, 68, 68, .35);
}

.btn-reset {
	background: #111827;
	border: 1px solid rgba(255, 255, 255, .12);
	color: #e5e7eb;
	border-radius: .8rem;
}

.table tbody td, .table thead th {
	color: #e5e7eb;
}

.table thead th {
	border-bottom-color: rgba(255, 255, 255, .12) !important;
	color: #cbd5e1 !important;
}
</style>
</head>

<body>
	<div class="container-main mx-auto py-5">

		<!-- Hero -->
		<div class="hero mb-5">
			<div
				class="d-flex align-items-center justify-content-between flex-wrap gap-3">
				<div>
					<span class="badge badge-mode px-3 py-2 mb-3">TURN-BASED
						DUEL</span>
					<h1 class="text-white fw-bold mb-2">카드 배틀</h1>
					<div class="text-gray-400">
						현재 턴: <span class="badge stat-pill"> <%="p1".equals(turn) ? "PLAYER 1" : "PLAYER 2"%>
						</span>
						<%=gameOver ? "<span class='ms-2 text-danger fw-bold'>게임 종료</span>" : ""%>
					</div>
				</div>
				<div class="text-end">
					<div class="fs-2hx fw-bold text-white"><%=p1Cards.stream().filter(c -> c.getP1CardHp() > 0).count()%>
						:
						<%=p2Cards.stream().filter(c -> c.getP2CardHp() > 0).count()%>
					</div>
						<div class="text-gray-400">덱 카드 수</div>
				</div>
			</div>

			<!-- Duel Area -->
			<div class="row g-4 align-items-stretch">
				<!-- Player 1 -->
				<div class="col-12 col-lg-5 duel-col">
					<div class="card card-glass h-100">
						<div
							class="card-header border-0 d-flex justify-content-between align-items-center">
							<h3 class="text-white fw-semibold m-0"><%=player1Name%></h3>
							<span class="stat-pill">Active #<%=Math.min(p1Index + 1, p1Cards.size())%></span>
						</div>
						<div class="card-body">
							<%
							if (p1Cards.size() > p1Index) {
								P1CardVO c = p1Cards.get(p1Index);
								int hp = c.getP1CardHp();
								int maxHp = c.getP1CardMaxHp();
								int hpPercent = (int) (((double) hp / maxHp) * 100);
							%>
							<div class="d-flex flex-column align-items-center text-center">
								<div class="symbol-240 mb-3">
									<img src="/pj2/<%=p1Cards.get(p1Index).getImgPath()%>"
										class="w-100 h-100" alt="active card p1" />
								</div>
								<h4 class="text-white fw-bold mb-1"><%=c.getP1CardName()%></h4>
								<div class="d-flex gap-2 mb-3">
									<span class="stat-pill">ATK <strong><%=c.getP1CardAtt()%></strong></span>
									<span class="stat-pill">ROLE <strong><%=c.getP1Detail()%></strong></span>
								</div>
								<div class="w-100">
									<div class="d-flex justify-content-between text-gray-300 small">
										<span>HP</span><span id="p1-hp" class="text-white fw-bold"><%=maxHp%></span>
									</div>
									<div class="progress mt-1" role="progressbar" aria-valuemin="0"
										aria-valuemax="<%=maxHp%>" aria-valuenow="<%=hp%>">
										<div class="progress-bar bg-danger"
											style="width:<%=hpPercent%>%;">
											<%=hp%>
											/
											<%=maxHp%>
										</div>
									</div>
								</div>
							</div>
							<%
							} else {
							%>
							<%
							long aliveCount1 = p1Cards.stream().filter(x -> x.getP1CardHp() > 0).count();
							if (!gameOver && aliveCount1 > 0 && (p1Cards.size() <= p1Index || p1Cards.get(p1Index).getP1CardHp() <= 0)) {
							%>
							<div class="alert alert-warning border-0 fw-bold">교체할 카드를
								선택해 주세요</div>
							<%
							} else {
							%>
							<div class="alert alert-dark border-0">활성 카드 없음</div>
							<%
							}
							%>
							<%
							}
							%>
						</div>
						<div class="card-footer border-0 pt-0">
							<%
							if ("p1".equals(turn) && !gameOver && p1Cards.size() > p1Index) {
							%>
							<form method="post" class="m-0">
								<button name="attack" value="p2" class="btn btn-attack w-100">공격하기</button>
							</form>
							<%
							}
							%>
						</div>

						<!-- 보유 카드 -->
						<div class="p-4 pt-0">
							<h6 class="text-uppercase text-gray-400 mb-3">보유 카드</h6>
							<div class="table-responsive">
								<table class="table table-row-dashed align-middle gy-2">
									<thead>
										<tr>
											<th>카드 이름</th>
											<th>설명</th>
										</tr>
									</thead>
									<tbody>
										<%
										for (int i = 0; i < p1Cards.size(); i++) {
											P1CardVO c = p1Cards.get(i);
											if (c.getP1CardHp() > 0) {
										%>
										<tr>
											<td class="fw-semibold text-gray-300"><%=c.getP1CardName()%></td>
											<td class="text-gray-300"><%=c.getP1Detail()%></td>
											<td>
												<%
												if ("p1".equals(turn) && !gameOver && i != p1Index) {
												%>
												<form method="post" class="d-inline" action="fight.jsp">
													<button type="submit" name="switchCard" value="<%=i%>"
														class="btn btn-sm btn-secondary">교체</button>
												</form> <%
 }
 %>
											</td>
										</tr>
										<%
										}
										}
										%>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

				<!-- VS Badge -->
				<div
					class="col-12 col-lg-2 d-flex align-items-center justify-content-center">
					<div class="vs-badge">VS</div>
				</div>

				<!-- Player 2 -->
				<div class="col-12 col-lg-5 duel-col">
					<div class="card card-glass h-100">
						<div
							class="card-header border-0 d-flex justify-content-between align-items-center">
							<h3 class="text-white fw-semibold m-0"><%=player2Name%></h3>
							<span class="stat-pill">Active #<%=Math.min(p2Index + 1, p2Cards.size())%></span>
						</div>
						<div class="card-body">
							<%
							if (p2Cards.size() > p2Index) {
								P2CardVO c2 = p2Cards.get(p2Index);
								int hp2 = c2.getP2CardHp();
								int maxHp2 = c2.getP2CardMaxHp();
								int hpPercent2 = (int) (((double) hp2 / maxHp2) * 100);
							%>
							<div class="d-flex flex-column align-items-center text-center">
								<div class="symbol-240 mb-3">
									<img src="/pj2/<%=p2Cards.get(p2Index).getImgPath()%>"
										class="w-100 h-100" alt="active card p2" />
								</div>
								<h4 class="text-white fw-bold mb-1"><%=c2.getP2CardName()%></h4>
								<div class="d-flex gap-2 mb-3">
									<span class="stat-pill">ATK <strong><%=c2.getP2CardAtt()%></strong></span>
									<span class="stat-pill">ROLE <strong><%=c2.getP2Detail()%></strong></span>
								</div>
								<div class="w-100">
									<div class="d-flex justify-content-between text-gray-300 small">
										<span>HP</span><span id="p2-hp" class="text-white fw-bold"><%=maxHp2%></span>
									</div>
									<div class="progress mt-1" role="progressbar" aria-valuemin="0"
										aria-valuemax="<%=maxHp2%>" aria-valuenow="<%=hp2%>">
										<div class="progress-bar bg-danger"
											style="width:<%=hpPercent2%>%;">
											<%=hp2%>
											/
											<%=maxHp2%>
										</div>
									</div>
								</div>
							</div>
							<%
							} else {
							%>
							<%
							long aliveCount1 = p1Cards.stream().filter(x -> x.getP1CardHp() > 0).count();
							if (!gameOver && aliveCount1 > 0 && (p2Cards.size() <= p2Index || p2Cards.get(p2Index).getP2CardHp() <= 0)) {
							%>
							<div class="alert alert-warning border-0 fw-bold">교체할 카드를
								선택해 주세요</div>
							<%
							} else {
							%>
							<div class="alert alert-dark border-0">활성 카드 없음</div>
							<%
							}
							%>
							<%
							}
							%>
						</div>
						<div class="card-footer border-0 pt-0">
							<%
							if ("p2".equals(turn) && !gameOver && p2Cards.size() > p2Index) {
							%>
							<form method="post" class="m-0">
								<button name="attack" value="p1" class="btn btn-attack w-100">공격하기</button>
							</form>
							<%
							}
							%>
						</div>

						<!-- 보유 카드 -->
						<div class="p-4 pt-0">
							<h6 class="text-uppercase text-gray-400 mb-3">보유 카드</h6>
							<div class="table-responsive">
								<table class="table table-row-dashed align-middle gy-2">
									<thead>
										<tr>
											<th>카드 이름</th>
											<th>설명</th>
										</tr>
									</thead>
									<tbody>
										<%
										for (int i = 0; i < p2Cards.size(); i++) {
											P2CardVO c = p2Cards.get(i);
											if (c.getP2CardHp() > 0) {
										%>
										<tr>
											<td class="fw-semibold text-gray-300"><%=c.getP2CardName()%></td>
											<td class="text-gray-300"><%=c.getP2Detail()%></td>
											<td>
												<%
												if ("p2".equals(turn) && !gameOver && i != p2Index) {
												%>
												<form method="post" class="d-inline" action="fight.jsp">
													<button type="submit" name="switchCard" value="<%=i%>"
														class="btn btn-sm btn-secondary">교체</button>
												</form> <%
 }
 %>
											</td>
										</tr>
										<%
										}
										}
										%>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

			</div>

			<!-- Battle Log -->
			<div class="log-card card mt-5">
				<div class="card-header border-0">
					<h3 class="text-white fw-semibold m-0">배틀 로그</h3>
				</div>
				<div class="card-body">
					<div class="text-gray-200" id="battleLog">
						<%=(battleLog == null || battleLog.isEmpty()) ? "시작하세요!" : battleLog%>
					</div>
				</div>
			</div>

			<!-- Sticky Actions -->
			<div class="sticky-actions mt-4">
				<div
					class="container-main mx-auto py-3 d-flex flex-wrap align-items-center justify-content-between gap-3">
					<div class="text-gray-400">
			
					</div>
					<div class="d-flex gap-2">
						<%
						if (gameOver) {
						%>
						<a href="result.jsp" class="btn btn-primary fw-bold">결과 보기</a>
						<%
						}
						%>
					
					</div>
				</div>
			</div>

		</div>

		<!-- JS bundles -->
		<script src="assets/plugins/global/plugins.bundle.js"></script>
		<script src="assets/js/scripts.bundle.js"></script>
		<script src="js/bootstrap.bundle.min.js"></script>

		<script>
$(function(){
  // 공격 버튼 클릭 시 HP 깜빡임(서버 포스트 전에 클래스 추가)
  $("button[name='attack']").on("click", function(){
    var t = "<%=turn%>
		";
				if (t === "p1")
					$("#p2-hp").addClass("hp-hit");
				else if (t === "p2")
					$("#p1-hp").addClass("hp-hit");
				setTimeout(function() {
					$("#p1-hp,#p2-hp").removeClass("hp-hit");
				}, 1000);
			});
		});
	</script>
</body>
</html>
