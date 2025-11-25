package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.PurchaseDTO;
import util.DBUtil;

public class PurchaseDAO {
    
    // 싱글톤 패턴 (DAO 객체를 하나만 만들어 공유해서 사용)
    private static PurchaseDAO instance = new PurchaseDAO();
    public static PurchaseDAO getInstance() { return instance; }
    private PurchaseDAO() {}

    // ====================================================================
    // ▶ 기능 1: 상품 구매 처리 (트랜잭션 적용)
    // 1. 회원 포인트 차감 / 2. 상품 재고 감소 / 3. 구매 기록 저장 -> 모두 성공해야 Commit
    // ====================================================================
    public boolean purchaseItem(String memberId, int itemId, int price) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        
        try {
            conn = DBUtil.getConnection();
            // ★ 중요: 자동 저장을 끄고 수동으로 관리 (트랜잭션 시작)
            conn.setAutoCommit(false);
            
            // 1. 회원 포인트 차감
            String sql1 = "UPDATE MEMBER SET POINT = POINT - ? WHERE MEMBER_ID = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setInt(1, price);
            pstmt.setString(2, memberId);
            int result1 = pstmt.executeUpdate();
            pstmt.close();
            
            // 2. 상품 재고 감소
            String sql2 = "UPDATE ITEM SET STOCK = STOCK - 1 WHERE ITEM_ID = ?";
            pstmt = conn.prepareStatement(sql2);
            pstmt.setInt(1, itemId);
            int result2 = pstmt.executeUpdate();
            pstmt.close();
            
            // 3. 구매 기록 남기기
            String sql3 = "INSERT INTO PURCHASE (MEMBER_ID, ITEM_ID, PURCHASE_POINT, PURCHASE_DATE) VALUES (?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql3);
            pstmt.setString(1, memberId);
            pstmt.setInt(2, itemId);
            pstmt.setInt(3, price);
            int result3 = pstmt.executeUpdate();
            
            // 4. 세 가지 작업이 모두 성공했는지 확인
            if (result1 > 0 && result2 > 0 && result3 > 0) {
                conn.commit(); // 진짜 저장 (성공)
                result = true;
            } else {
                conn.rollback(); // 하나라도 실패하면 되돌리기
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {} // 에러나면 되돌리기
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            // 커넥션을 반납하기 전에 다시 원래대로(AutoCommit true) 돌려놓는 것이 관례
            try { if(conn != null) { conn.setAutoCommit(true); conn.close(); } } catch(Exception e) {}
        }
        
        return result;
    }

    // ====================================================================
    // ▶ 기능 2: 내 구매 내역 조회 (JOIN 쿼리 사용)
    // PURCHASE 테이블과 ITEM 테이블을 합쳐서 상품 이름과 이미지까지 가져옴
    // ====================================================================
    public List<PurchaseDTO> getPurchaseList(String memberId) {
        List<PurchaseDTO> list = new ArrayList<>();
        
        // P: 구매테이블 별칭, I: 상품테이블 별칭
        String sql = "SELECT P.*, I.NAME, I.IMAGE_URL " +
                     "FROM PURCHASE P " +
                     "JOIN ITEM I ON P.ITEM_ID = I.ITEM_ID " +
                     "WHERE P.MEMBER_ID = ? " +
                     "ORDER BY P.PURCHASE_DATE DESC"; // 최신순 정렬
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                PurchaseDTO dto = new PurchaseDTO();
                // 1. 구매 정보 매핑
                dto.setPurchaseId(rs.getInt("PURCHASE_ID"));
                dto.setMemberId(rs.getString("MEMBER_ID"));
                dto.setItemId(rs.getInt("ITEM_ID"));
                dto.setPurchasePoint(rs.getInt("PURCHASE_POINT"));
                dto.setPurchaseDate(rs.getTimestamp("PURCHASE_DATE"));
                
                // 2. 상품 정보 매핑 (JOIN 결과)
                dto.setItemName(rs.getString("NAME"));
                dto.setItemImageUrl(rs.getString("IMAGE_URL"));
                
                list.add(dto);
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
}