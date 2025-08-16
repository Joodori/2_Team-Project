package pj2;

public class CardVO {
	int cardId;
	String cardName;
	int att;
	int hp;
	String detail;
	String imgPath; // 추가

    // getters/setters
	
    public String getImgPath() {
    	return imgPath; 
    }
    public void setImgPath(String imgPath) { 
    	this.imgPath = imgPath; 
    }
	public int getCardId() {
		return cardId;
	}
	public void setCardId(int cardId) {
		this.cardId = cardId;  
	}
	public String getCardName() {
		return cardName;
	}
	public void setCardName(String cardName) {
		this.cardName = cardName;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public int getAtt() {
		return att;
	}
	public void setAtt(int att) {
		this.att = att;
	}
	public int getHp() {
		return hp;
	}
	public void setHp(int hp) {
		this.hp = hp;
	}

}