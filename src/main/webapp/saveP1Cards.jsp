<%@ page import="java.util.*,pj2.P1CardVO,pj2.GameDAO" %>
<%
request.setCharacterEncoding("UTF-8");

String p1Name = (String) session.getAttribute("p1Name");
String[] names = request.getParameterValues("cardName");
String[] atts = request.getParameterValues("cardAtt");
String[] hps = request.getParameterValues("cardHp");
String[] details = request.getParameterValues("cardDetail");
String[] imgPaths = request.getParameterValues("cardImgPath");

List<P1CardVO> selectedCards = new ArrayList<>();
if (names != null) {
    for (int i = 0; i < names.length; i++) {
        P1CardVO card = new P1CardVO();
        card.setP1_name(p1Name);
        card.setP1CardName(names[i]);
        card.setP1CardAtt(Integer.parseInt(atts[i]));
        card.setP1CardHp(Integer.parseInt(hps[i]));
        card.setP1Detail(details[i]);
        card.setImgPath(imgPaths[i]);
        selectedCards.add(card);
    }
}

GameDAO dao = new GameDAO();
dao.insertP1Card(selectedCards);

response.sendRedirect("selectP2Card.jsp");
%>