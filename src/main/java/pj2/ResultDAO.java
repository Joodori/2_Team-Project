package pj2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ResultDAO {
	
	static String driverClassName = "com.mysql.cj.jdbc.Driver";
	static String connectionUrl = "jdbc:mysql://localhost:3306/newhr?serverTimezone=UTC";
	static String userName = "root";
	static String password = "rootroot";
	
	
	
	public void insertResult(String p1Name, String p2Name, String winner, String penalty) throws Exception {
	    Connection conn = getConnection();
	    String sql = "INSERT INTO result (p1_name, p2_name, winner, penalty) VALUES (?, ?, ?, ?)";
	    PreparedStatement pstmt = conn.prepareStatement(sql);
	    pstmt.setString(1, p1Name);
	    pstmt.setString(2, p2Name);
	    pstmt.setString(3, winner);
	    pstmt.setString(4, penalty);
	    pstmt.executeUpdate();
	    pstmt.close();
	    conn.close();
	}
	// getPenalty 메소드의 2번째줄에서 필요한 penalty 테이블의 길이 구하는 메소드 
	public static int getPenaltyListLength() throws Exception {
		 int length = 0;
		    Connection conn = getConnection();
		    String sql = "select count(*) from penalty";
		    PreparedStatement psmt = conn.prepareStatement(sql);
		    ResultSet rs = psmt.executeQuery();
		    if (rs.next()) {            // ✅ 이 부분 추가
		        length = rs.getInt(1);
		    }
		    rs.close();
		    psmt.close();
		    conn.close();
		    return length;
	}
	
	// 벌칙 정하는 메소드
	public static String getPenalty() throws Exception {
	    int length = getPenaltyListLength();
	    if (length == 0) return null;

	    int rd = (int)(Math.random() * length) + 1;  // 1 ~ length 범위
	    String penalty = null;

	    Connection conn = getConnection();
	    String sql = "SELECT penalty_detail FROM penalty WHERE penalty_id = ?";
	    PreparedStatement psmt = conn.prepareStatement(sql);
	    psmt.setInt(1, rd);
	    ResultSet rs = psmt.executeQuery();

	    if (rs.next()) {
	        penalty = rs.getString("penalty_detail");
	    }

	    rs.close();
	    psmt.close();
	    conn.close();

	    return penalty;
	}
	// 첫번째 화면(first.jsp)에서 전적확인 메소드
	public static List<ResultVO> showRecord() throws Exception {
		List<ResultVO> voList = new ArrayList<ResultVO>();
		
		Connection conn = getConnection();
		String sql = "select * from result";
		PreparedStatement psmt = conn.prepareStatement(sql);
		ResultSet rs = psmt.executeQuery();
		while (rs.next()) {
			ResultVO rvo = new ResultVO();
			rvo.setGame_id(rs.getInt("result_id"));
			rvo.setP1_name(rs.getString("p1_name"));
			rvo.setP2_name(rs.getString("p2_name"));
			rvo.setWinner(rs.getString("winner"));
			rvo.setPenalty(rs.getString("penalty"));
			voList.add(rvo);
		}
		conn.close();
		return voList;
	}
	
	// 벌칙 추가하기 메소드 *나중에 뺄수도있음 *아직 jsp에 구현해놓지는 않았음
	public static void addPenalty(String str) throws Exception {
		Connection conn = getConnection();
		String sql = "insert into penalty(penalty_detail) values(?)";
		PreparedStatement psmt = conn.prepareStatement(sql);
		psmt.setString(1, str);
		int affectedRow = psmt.executeUpdate();
		
		if (affectedRow > 0 ) {
			System.out.println("벌칙 추가");
		} else {
			System.out.println("벌칙 추가 안되었으니 확인");
		}
		
		conn.close();
		return;
	}
	
	// 첫번째 화면(first.jsp)에서 이름 입력하고 두번째 페이지(selectCard.jsp)들어가면 Head태그에서 실행되는 메소드
	public static void addPlayers(String p1Name, String p2Name) throws Exception {
		        if (p1Name == null || p2Name == null || p1Name.trim().isEmpty() || p2Name.trim().isEmpty()) {
            // 이름이 유효하지 않으면 삽입하지 않음
            return;
        }
Connection conn = getConnection();
		String sql = "insert into result(p1_name, p2_name) values(?,?)";
		PreparedStatement psmt = conn.prepareStatement(sql);
		psmt.setString(1, p1Name);
		psmt.setString(2, p2Name);
		int affectedRow = psmt.executeUpdate();
		
		if (affectedRow > 0 ) {
			System.out.println("insert 완료 나머지 값들은 null로 설정되어있음");
		} else {
			System.out.println("첫번째 화면에서 게임시작 버튼 눌렀을 때 DB에 저장이 안됨");
		}
		
		conn.close();
		return;
	}
	
	public void updateResult(String  p1Name, String p2Name, String winner, String penalty) throws Exception {
	    Connection conn = getConnection();
	    String selectIdSql = "SELECT result_id FROM result WHERE p1_name=? AND p2_name=? AND (winner IS NULL OR winner='') AND (penalty IS NULL OR penalty='') ORDER BY result_id DESC LIMIT 1";
	    PreparedStatement idStmt = conn.prepareStatement(selectIdSql);
	    idStmt.setString(1, p1Name);
	    idStmt.setString(2, p2Name);
	    ResultSet idRs = idStmt.executeQuery();

	    Integer resultId = null;
	    if (idRs.next()) {
	        resultId = idRs.getInt("result_id");
	    }
	    idRs.close();
	    idStmt.close();

	    if (resultId != null) {
	        String updateSql = "UPDATE result SET winner=?, penalty=? WHERE result_id=?";
	        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	        updateStmt.setString(1, winner);
	        updateStmt.setString(2, penalty);
	        updateStmt.setInt(3, resultId);
	        int updatedRows = updateStmt.executeUpdate();
	        updateStmt.close();

	        System.out.println("updateResult: 업데이트된 행 수 = " + updatedRows);
	    } else {
	        // 보완: 해당 row 없으면 insertResult 호출 (중복 저장 조심!)
	        insertResult(p1Name, p2Name, winner, penalty);
	        System.out.println("updateResult: 해당 row 없어 insertResult 호출");
	    }
	    conn.close();
	}

	// result.jsp에서 결과출력 메소드
	public ResultVO getLastResult(String p1Name, String p2Name) throws Exception {
	    ResultVO result = null;
	    Connection conn = getConnection();
	    String sql = "SELECT * FROM result WHERE p1_name=? AND p2_name=? ORDER BY result_id DESC LIMIT 1";
	    PreparedStatement pstmt = conn.prepareStatement(sql);
	    pstmt.setString(1, p1Name);
	    pstmt.setString(2, p2Name);
	    ResultSet rs = pstmt.executeQuery();
	    if (rs.next()) {
	        result = new ResultVO();
	        result.setGame_id(rs.getInt("result_id"));
	        result.setP1_name(rs.getString("p1_name"));
	        result.setP2_name(rs.getString("p2_name"));
	        result.setWinner(rs.getString("winner"));
	        result.setPenalty(rs.getString("penalty"));
	    }
	    rs.close();
	    pstmt.close();
	    conn.close();
	    return result;
	}
	// DB연결 메소드
	private static Connection getConnection() throws Exception {
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:comp/env");
		DataSource dataSource = (DataSource) envContext.lookup("jdbc/mydb");
		Connection connection = dataSource.getConnection();
		return connection;
		}
	
}
