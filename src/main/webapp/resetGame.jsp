<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ page import="pj2.GameDAO" %>
<%
Integer gameIDObj = (Integer) session.getAttribute("gameID");
int gameID = gameIDObj.intValue();

GameDAO dao = new GameDAO();
dao.resetPlayerCardList(gameID);
session.invalidate();
response.sendRedirect("first.jsp");
%>

</body>
</html>