<%@ page import="java.util.*,pj2.P2CardVO,pj2.GameDAO" %>
<%
request.setCharacterEncoding("UTF-8");

Integer gameIDObj = (Integer) session.getAttribute("gameID"); // modified
String p2Name = (String) session.getAttribute("p2Name");
String[] names = request.getParameterValues("cardName");
String[] atts = request.getParameterValues("cardAtt");
String[] hps = request.getParameterValues("cardHp");
String[] details = request.getParameterValues("cardDetail");
String[] imgPaths = request.getParameterValues("cardImgPath");

int gameID = gameIDObj.intValue(); // modified 

List<P2CardVO> selectedCards = new ArrayList<>();
if (names != null) {
    for (int i = 0; i < names.length; i++) {
        P2CardVO card = new P2CardVO();
        card.setP2_name(p2Name);
        
        card.setP2CardName(names[i]);
        card.setP2CardAtt(Integer.parseInt(atts[i]));
        card.setP2CardHp(Integer.parseInt(hps[i]));
        card.setP2Detail(details[i]);
        card.setImgPath(imgPaths[i]);
        selectedCards.add(card);
    }
}

GameDAO dao = new GameDAO();
dao.insertP2Card(selectedCards, gameID); // modified

response.sendRedirect("fight.jsp");
%>