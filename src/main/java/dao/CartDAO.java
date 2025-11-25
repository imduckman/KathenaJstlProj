package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import dto.CartDTO;
import util.DBUtil;

public class CartDAO {
    private static CartDAO instance = new CartDAO();
    public static CartDAO getInstance() { return instance; }
    private CartDAO() {}

    // 1. 장바구니 담기
    public int addToCart(String memberId, int itemId) {
        String sql = "INSERT INTO CART (MEMBER_ID, ITEM_ID, COUNT) VALUES (?, ?, 1)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            pstmt.setInt(2, itemId);
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 2. 내 장바구니 목록 (상품 정보와 JOIN해서 가져옴)
    public List<CartDTO> getCartList(String memberId) {
        List<CartDTO> list = new ArrayList<>();
        String sql = "SELECT C.*, I.NAME, I.PRICE, I.IMAGE_URL " +
                     "FROM CART C JOIN ITEM I ON C.ITEM_ID = I.ITEM_ID " +
                     "WHERE C.MEMBER_ID = ? ORDER BY C.CART_ID DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
                CartDTO c = new CartDTO();
                c.setCartId(rs.getInt("CART_ID"));
                c.setMemberId(rs.getString("MEMBER_ID"));
                c.setItemId(rs.getInt("ITEM_ID"));
                c.setCount(rs.getInt("COUNT"));
                c.setItemName(rs.getString("NAME"));      // 상품이름
                c.setItemPrice(rs.getInt("PRICE"));       // 상품가격
                c.setItemImageUrl(rs.getString("IMAGE_URL"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. 장바구니 개별 삭제
    public int deleteCart(int cartId) {
        String sql = "DELETE FROM CART WHERE CART_ID=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, cartId);
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
    // 4. 장바구니 비우기 (구매 완료 후 사용)
    public void clearCart(String memberId) {
        String sql = "DELETE FROM CART WHERE MEMBER_ID=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}