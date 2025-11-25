package dto;

import java.sql.Timestamp;

public class CartDTO {
    private int cartId;
    private String memberId;
    private int itemId;
    private int count;
    private Timestamp regDate;
    
    // DB에는 없지만 화면 출력을 위해 추가한 변수 (JOIN 결과용)
    private String itemName;
    private int itemPrice;
    private String itemImageUrl;

    public CartDTO() {}

    // Getter & Setter
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public int getCount() { return count; }
    public void setCount(int count) { this.count = count; }
    public Timestamp getRegDate() { return regDate; }
    public void setRegDate(Timestamp regDate) { this.regDate = regDate; }
    
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public int getItemPrice() { return itemPrice; }
    public void setItemPrice(int itemPrice) { this.itemPrice = itemPrice; }
    public String getItemImageUrl() { return itemImageUrl; }
    public void setItemImageUrl(String itemImageUrl) { this.itemImageUrl = itemImageUrl; }
}