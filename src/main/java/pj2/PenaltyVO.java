package pj2;

public class PenaltyVO {
	String detail;
	int id;

	public PenaltyVO(int id, String detail) {
		super();
		this.id = id;
		this.detail = detail;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	
}
