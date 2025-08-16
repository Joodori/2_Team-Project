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
GameDAO dao = new GameDAO();
dao.resetPlayerCardList();
session.invalidate();
response.sendRedirect("first.jsp");
%>

</body>
</html>