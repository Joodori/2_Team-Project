<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>게임 시작 페이지</title>
</head>
<body>

	<!-- 플레이어 정보 작성 부분 -->
	<h1>플레이어 이름 입력</h1>
	<!-- post방식의 form 이용 + p1_name과 p2_name의 parameter로 전송 -->
	<!-- table의 첫번째 열의 사진 src는 이름 입력 후 player_db에서 이름을 통해 사진을 찾아오는 함수를 작성해야함 -->
	<!-- 이름이 비어있으면 알림 + focus주는것 + 입력한 부분은 사진 바뀌게 만들기 -->
	<!-- 프론트가 작업하기 쉽게 table 위치 조정 필요(?) -->
    <div class="playerInfo">
    <form action="selectCardP1.jsp" method="post">
        <table>
        	<tr>
        		<th><img src="test.png"> 사진 바뀌게 하는 함수 적용해야함 </th> <th><img src="test.png"></th>
        	</tr>
            <tr>
                <td>Player 1 이름:</td>
                <td><input type="text" name="p1_name" placeholder="플레이어 1의 이름을 입력해주세요."></td>
                <td>Player 2 이름:</td>
                <td><input type="text" name="p2_name" placeholder="플레이어 2의 이름을 입력해주세요."></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" value="게임 시작">
                </td>
            </tr>
        </table>
    </form>
    </div>
    
    
	<!-- 전적표시 부분 -->
	<!-- just DB에서 값 가져오는 용도 -->
	<!-- JSTL 사용 -->
	<div class="resultSet">
    <h2>역대 전적</h2>
    <table>
   	 	<c:forEach item="${ data }" var="person">
   	 		<tr>
   	 			<td>Player1 : $(person.getP1())</td>
   	 			<td>Player2 : $(person.getP2())</td>
   	 			<td>Winner : $(person.getWinner())</td>
   	 		</tr>
   	 		<tr>
   	 			<td>Looser : $(person.getLooser())</td>
   	 			<td>Penalty : $(person.getPenalty())</td>
   	 		</tr>
   	 	</c:forEach>
    </table>
	</div>
</body>
</html>