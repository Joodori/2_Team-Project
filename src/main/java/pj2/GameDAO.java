package pj2;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GameDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// 랜덤 카드 10장 조회
	public List<CardVO> getRandomCardList() throws Exception {
		List<CardVO> list = new ArrayList<>();

		conn = getConnection();
		String sql = "SELECT card_id, card_name, card_att, card_hp, img_path FROM card ORDER BY RAND() LIMIT 10";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			CardVO card = new CardVO();
			card.setCardId(rs.getInt("card_id"));
			card.setCardName(rs.getString("card_name"));
			card.setAtt(rs.getInt("card_att"));
			card.setHp(rs.getInt("card_hp"));
			card.setImgPath(rs.getString("img_path"));
			list.add(card);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 플레이어1 카드 DB 저장 (선택된 카드 3장)
	public void insertP1Card(List<P1CardVO> selectedCards) throws Exception {
		conn = getConnection();
		String insertSql = "INSERT INTO player1card(p1_name, card_name, card_att, card_hp, card_detail, img_path) VALUES(?, ?, ?, ?, ?,?)";
		pstmt = conn.prepareStatement(insertSql);

		for (int i = 0; i < selectedCards.size() && i < 3; i++) {
			P1CardVO card = selectedCards.get(i);
			pstmt.setString(1, card.getP1_name());
			pstmt.setString(2, card.getP1CardName());
			pstmt.setInt(3, card.getP1CardAtt());
			pstmt.setInt(4, card.getP1CardHp());
			pstmt.setString(5, "Player1 Card " + (i + 1));
			pstmt.setString(6, card.getImgPath());

			pstmt.executeUpdate();
		}
		pstmt.close();
		conn.close();
	}

	// 플레이어2 카드 DB 저장 (선택된 카드 3장)
	public void insertP2Card(List<P2CardVO> selectedCards) throws Exception {
		conn = getConnection();
		String insertSql = "INSERT INTO player2card(p2_name, card_name, card_att, card_hp, card_detail, img_path) VALUES(?, ?, ?, ?,?,?)";
		pstmt = conn.prepareStatement(insertSql);

		for (int i = 0; i < selectedCards.size() && i < 3; i++) {
			P2CardVO card = selectedCards.get(i);
			pstmt.setString(1, card.getP2_name());
			pstmt.setString(2, card.getP2CardName());
			pstmt.setInt(3, card.getP2CardAtt());
			pstmt.setInt(4, card.getP2CardHp());
			pstmt.setString(5, "Player2 Card " + (i + 1));
			pstmt.setString(6, card.getImgPath());
			pstmt.executeUpdate();
		}
		pstmt.close();
		conn.close();
	}

	// 플레이어1 카드 리스트 DB에서 읽기
	public List<P1CardVO> getP1Cards(String p1Name) throws Exception {
		List<P1CardVO> list = new ArrayList<>();
		conn = getConnection();
		String sql = "SELECT card_name, card_att, card_hp, card_detail, img_path FROM player1card where p1_name = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, p1Name);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			P1CardVO vo = new P1CardVO();
			vo.setP1CardName(rs.getString("card_name"));
			vo.setP1CardAtt(rs.getInt("card_att"));
			vo.setP1CardHp(Integer.parseInt(rs.getString("card_hp")));
			vo.setP1CardMaxHp(Integer.parseInt(rs.getString("card_hp")));
			vo.setP1Detail(rs.getString("card_detail"));
			vo.setImgPath(rs.getString("img_path"));
			list.add(vo);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 플레이어2 카드 리스트 DB에서 읽기
	public List<P2CardVO> getP2Cards(String p2Name) throws Exception {
		List<P2CardVO> list = new ArrayList<>();
		conn = getConnection();
		String sql = "SELECT card_name, card_att, card_hp, card_detail, img_path FROM player2card where p2_name = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, p2Name);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			P2CardVO vo = new P2CardVO();
			vo.setP2CardName(rs.getString("card_name"));
			vo.setP2CardAtt(rs.getInt("card_att"));
			vo.setP2CardHp(rs.getInt("card_hp"));
			vo.setP2CardMaxHp(Integer.parseInt(rs.getString("card_hp")));
			vo.setP2Detail(rs.getString("card_detail"));
			vo.setImgPath(rs.getString("img_path"));
			list.add(vo);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 플레이어 카드 테이블 초기화
	public boolean resetPlayerCardList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql1 = "DELETE FROM player1card";
			pstmt = conn.prepareStatement(sql1);
			pstmt.executeUpdate();
			pstmt.close();

			String sql2 = "DELETE FROM player2card";
			pstmt = conn.prepareStatement(sql2);
			pstmt.executeUpdate();

			pstmt.close();
			conn.close();

			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
			return false;
		}
	}

	private static Connection getConnection() throws Exception {
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:comp/env");
		DataSource ds = (DataSource) envContext.lookup("jdbc/mydb");
		return ds.getConnection();
	}
}
