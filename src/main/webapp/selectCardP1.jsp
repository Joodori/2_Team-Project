<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Player1 Card Selection</title>
<style>
    body {
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 20px;
        background-color: #f0f8ff;
    }
    
    h1 {
        color: #333;
        margin-bottom: 10px;
    }
    
    .instruction {
        color: #666;
        margin-bottom: 30px;
        font-size: 16px;
    }
    
    .card-container {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 30px;
        flex-wrap: wrap;
        max-width: 800px;
        margin-left: auto;
        margin-right: auto;
    }
    
    .card {
        border: 3px solid transparent;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        background: white;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        padding: 5px;
    }
    
    .card:hover {
        border-color: #007bff;
        transform: scale(1.1);
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
    }
    
    .card img {
        width: 120px;
        height: auto;
        border-radius: 8px;
        display: block;
    }
    
    .card-info {
        margin-top: 8px;
        font-size: 14px;
        color: #333;
        font-weight: bold;
    }
    
    .loading {
        font-size: 18px;
        color: #007bff;
        margin: 50px 0;
    }
    
    .error {
        color: #dc3545;
        font-size: 16px;
        margin: 50px 0;
        padding: 15px;
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        border-radius: 8px;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
    }
    
    .success-message {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0,0,0,0.8);
        color: white;
        padding: 20px;
        border-radius: 8px;
        font-size: 18px;
        display: none;
        z-index: 1000;
    }
</style>
</head>
<body>

<h1>Player 1, 카드를 선택하세요!</h1>
<p class="instruction">아래 카드 중 하나를 클릭하여 선택하세요</p>

<div id="loading" class="loading">
    <p>🃏 카드를 불러오는 중...</p>
</div>

<div id="error" class="error" style="display:none;">
</div>

<div id="cards" class="card-container" style="display:none;">
    <!-- JavaScript로 카드들이 여기에 추가됩니다 -->
</div>

<div id="success-message" class="success-message">
    카드가 선택되었습니다! 잠시만 기다려주세요...
</div>

<form id="cardForm" action="player1Result.jsp" method="post">
    <input type="hidden" name="selectedCardCode" id="selectedCardCode">
    <input type="hidden" name="selectedCardImage" id="selectedCardImage">
    <input type="hidden" name="selectedCardValue" id="selectedCardValue">
    <input type="hidden" name="selectedCardSuit" id="selectedCardSuit">
    <input type="hidden" name="deckId" id="deckId">
</form>

<script>
// 전역 변수
let currentDeckId = '';

// 카드 선택 함수
function selectCard(cardData) {
    console.log('선택된 카드:', cardData);
    
    // 선택된 카드 정보를 폼에 설정
    document.getElementById("selectedCardCode").value = cardData.code;
    document.getElementById("selectedCardImage").value = cardData.image;
    document.getElementById("selectedCardValue").value = cardData.value;
    document.getElementById("selectedCardSuit").value = cardData.suit;
    document.getElementById("deckId").value = currentDeckId;
    
    // 성공 메시지 표시
    document.getElementById("success-message").style.display = "block";
    
    // 1초 후 폼 제출
    setTimeout(() => {
        document.getElementById("cardForm").submit();
    }, 1000);
}

// 에러 표시 함수
function showError(message) {
    document.getElementById("loading").style.display = "none";
    document.getElementById("error").textContent = message;
    document.getElementById("error").style.display = "block";
    console.error('오류:', message);
}

// 카드 표시 함수
function displayCards(cards, deckId) {
    console.log('카드 표시 시작:', cards);
    
    document.getElementById("loading").style.display = "none";
    const cardContainer = document.getElementById("cards");
    
    // 덱 ID 저장
    currentDeckId = deckId;
    
    // 기존 카드들 제거
    cardContainer.innerHTML = '';
    
    // 각 카드를 화면에 추가
    cards.forEach((card, index) => {
        const cardDiv = document.createElement("div");
        cardDiv.className = "card";
        
        // 카드 HTML 구조 생성
        cardDiv.innerHTML = `
            <img src="${card.image}" alt="${card.value} of ${card.suit}" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDEyMCAxODAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxMjAiIGhlaWdodD0iMTgwIiBmaWxsPSIjZjBmMGYwIiBzdHJva2U9IiNjY2MiLz4KPHRleHQgeD0iNjAiIHk9IjkwIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTQiIGZpbGw9IiM5OTkiIHRleHQtYW5jaG9yPSJtaWRkbGUiPkNhcmQ8L3RleHQ+Cjwvc3ZnPgo=';">
            <div class="card-info">${card.value} of ${card.suit}</div>
        `;
        
        // 카드 클릭 이벤트 추가
        cardDiv.addEventListener("click", () => selectCard(card));
        
        // 컨테이너에 추가
        cardContainer.appendChild(cardDiv);
    });
    
    // 카드 컨테이너 표시
    cardContainer.style.display = "flex";
    console.log('카드 표시 완료');
}

// API 호출 및 카드 로드
function loadCards() {
    console.log("카드 로딩 시작...");
    
    // 새 덱 생성과 동시에 5장 뽑기 (한 번의 요청으로 처리)
    const apiUrl = 'https://deckofcardsapi.com/api/deck/new/draw/?count=5';
    console.log("API 호출:", apiUrl);
    
    fetch(apiUrl)
        .then(response => {
            console.log("API 응답 상태:", response.status, response.statusText);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log("받은 데이터:", data);
            
            // API 응답 검증
            if (!data) {
                throw new Error("API에서 데이터를 받지 못했습니다.");
            }
            
            if (data.success !== true) {
                throw new Error("API 호출이 실패했습니다: " + (data.error || "알 수 없는 오류"));
            }
            
            if (!data.cards || !Array.isArray(data.cards) || data.cards.length === 0) {
                throw new Error("카드 정보가 없습니다.");
            }
            
            if (!data.deck_id) {
                throw new Error("덱 ID가 없습니다.");
            }
            
            // 카드 표시
            displayCards(data.cards, data.deck_id);
        })
        .catch(error => {
            console.error("API 호출 오류:", error);
            showError("카드를 불러오는데 실패했습니다: " + error.message);
        });
}

// 페이지 로드 시 카드 로드
document.addEventListener('DOMContentLoaded', function() {
    console.log("페이지 로드 완료, 카드 로딩 시작");
    loadCards();
});

// 페이지 로드 완료 후에도 실행 (백업)
window.addEventListener('load', function() {
    // DOM이 준비되지 않은 경우를 대비
    if (document.getElementById('loading').style.display !== 'none') {
        console.log("백업 로딩 실행");
        loadCards();
    }
});
</script>

</body>
</html>
