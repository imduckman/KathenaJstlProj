package dto;

import java.sql.Timestamp;

public class PurchaseDTO {
    // 1. 구매 테이블(PURCHASE) 정보
    private int purchaseId;
    private String memberId;
    private int itemId;
    private int purchasePoint;
    private Timestamp purchaseDate;
    
    // 2. 화면 출력을 위해 추가한 상품 정보 (JOIN 결과 저장용)
    private String itemName;
    private String itemImageUrl;

    public PurchaseDTO() {}

    // Getter & Setter
    public int getPurchaseId() { return purchaseId; }
    public void setPurchaseId(int purchaseId) { this.purchaseId = purchaseId; }
    
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public int getPurchasePoint() { return purchasePoint; }
    public void setPurchasePoint(int purchasePoint) { this.purchasePoint = purchasePoint; }
    
    public Timestamp getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Timestamp purchaseDate) { this.purchaseDate = purchaseDate; }
    
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    
    public String getItemImageUrl() { return itemImageUrl; }
    public void setItemImageUrl(String itemImageUrl) { this.itemImageUrl = itemImageUrl; }
}