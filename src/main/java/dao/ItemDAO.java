package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.ItemDTO;
import util.DBUtil;

public class ItemDAO {
    
    // 싱글톤 패턴
    private static ItemDAO instance = new ItemDAO();
    public static ItemDAO getInstance() { return instance; }
    private ItemDAO() {}

    // ▶ 기능 1: 전체 상품 목록 가져오기
    public List<ItemDTO> getAllItems() {
        List<ItemDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ITEM ORDER BY ITEM_ID DESC"; // 최신순 정렬
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ItemDTO item = new ItemDTO();
                item.setItemId(rs.getInt("ITEM_ID"));
                item.setName(rs.getString("NAME"));
                item.setPrice(rs.getInt("PRICE"));
                item.setStock(rs.getInt("STOCK"));
                item.setDescription(rs.getString("DESCRIPTION"));
                item.setImageUrl(rs.getString("IMAGE_URL"));
                item.setRegDate(rs.getTimestamp("REG_DATE"));
                
                list.add(item); // 리스트에 추가
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        return list;
    }

    // ▶ 기능 2: 상품 등록 (관리자용)
    public int insertItem(ItemDTO item) {
        int result = 0;
        String sql = "INSERT INTO ITEM (NAME, PRICE, STOCK, DESCRIPTION, IMAGE_URL, REG_DATE) VALUES (?, ?, ?, ?, ?, NOW())";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, item.getName());
            pstmt.setInt(2, item.getPrice());
            pstmt.setInt(3, item.getStock());
            pstmt.setString(4, item.getDescription());
            pstmt.setString(5, item.getImageUrl()); // 이미지 주소 (URL)
            
            result = pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        return result;
    }
    public int updateItem(ItemDTO item) {
        String sql = "UPDATE ITEM SET NAME=?, PRICE=?, STOCK=?, DESCRIPTION=?, IMAGE_URL=? WHERE ITEM_ID=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, item.getName());
            pstmt.setInt(2, item.getPrice());
            pstmt.setInt(3, item.getStock());
            pstmt.setString(4, item.getDescription());
            pstmt.setString(5, item.getImageUrl());
            pstmt.setInt(6, item.getItemId());
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // ▶ 기능 4: 상품 삭제
    public int deleteItem(int itemId) {
        String sql = "DELETE FROM ITEM WHERE ITEM_ID=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
    // ▶ 기능 5: 상품 1개 정보 가져오기 (수정 화면용)
    public ItemDTO getItem(int itemId) {
        String sql = "SELECT * FROM ITEM WHERE ITEM_ID=?";
        ItemDTO item = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) {
                item = new ItemDTO();
                item.setItemId(rs.getInt("ITEM_ID"));
                item.setName(rs.getString("NAME"));
                item.setPrice(rs.getInt("PRICE"));
                item.setStock(rs.getInt("STOCK"));
                item.setDescription(rs.getString("DESCRIPTION"));
                item.setImageUrl(rs.getString("IMAGE_URL"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return item;
    }
}