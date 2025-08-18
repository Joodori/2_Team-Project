<%@ page import="pj2.ResultDAO" %>
<%
  String penalty = request.getParameter("penalty");
  response.setContentType("text/plain; charset=UTF-8");
  if(penalty != null && !penalty.trim().isEmpty()){
    ResultDAO dao = new ResultDAO();
    dao.addPenalty(penalty);
  }
%>