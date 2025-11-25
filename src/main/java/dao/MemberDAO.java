package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import dto.MemberDTO;
import util.DBUtil;

public class MemberDAO {
    
    // 싱글톤 패턴 (DAO 객체를 하나만 만들어 쓰기 위함)
    private static MemberDAO instance = new MemberDAO();
    public static MemberDAO getInstance() { return instance; }
    private MemberDAO() {} // 외부에서 new 못하게 막음

    // ▶ 기능 1: 로그인 처리 (아이디, 비번 받아서 회원정보 리턴)
    public MemberDTO login(String id, String pw) {
        MemberDTO member = null;
        String sql = "SELECT * FROM MEMBER WHERE MEMBER_ID = ? AND PASSWORD = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection(); // DB 연결
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // 로그인 성공! DB에서 꺼낸 정보를 DTO에 담기
                member = new MemberDTO();
                member.setMemberId(rs.getString("MEMBER_ID"));
                member.setPassword(rs.getString("PASSWORD"));
                member.setName(rs.getString("NAME"));
                member.setPoint(rs.getInt("POINT"));
                member.setRole(rs.getString("ROLE"));
                member.setJoinDate(rs.getTimestamp("JOIN_DATE"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제 (순서 중요: rs -> pstmt -> conn)
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        
        return member; // 회원이면 객체 리턴, 아니면 null 리턴
    }
    public int insertMember(MemberDTO member) {
        int result = 0;
        //권한은 'USER', 가입일은 현재시간(NOW())으로 설정
        String sql = "INSERT INTO MEMBER (MEMBER_ID, PASSWORD, NAME, POINT, ROLE, JOIN_DATE) VALUES (?, ?, ?, 0, 'USER', NOW())";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, member.getMemberId());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getName());
            
            result = pstmt.executeUpdate(); // 성공하면 1 반환
            
        } catch (Exception e) {
            e.printStackTrace(); // 아이디 중복 시 여기서 에러 발생
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        
        return result;
    }
    public java.util.List<MemberDTO> getAllMembers() {
        java.util.List<MemberDTO> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM MEMBER ORDER BY JOIN_DATE DESC"; // 최근 가입순
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                MemberDTO m = new MemberDTO();
                m.setMemberId(rs.getString("MEMBER_ID"));
                m.setName(rs.getString("NAME"));
                m.setPoint(rs.getInt("POINT"));
                m.setRole(rs.getString("ROLE"));
                m.setJoinDate(rs.getTimestamp("JOIN_DATE"));
                list.add(m);
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

    // ▶ 기능 4: 포인트 변경 (플러스면 충전, 마이너스면 차감)
    public int updatePoint(String memberId, int amount) {
        int result = 0;
        // 기존 포인트에 입력된 값(amount)을 더함 (음수면 알아서 빠짐)
        String sql = "UPDATE MEMBER SET POINT = POINT + ? WHERE MEMBER_ID = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, amount);
            pstmt.setString(2, memberId);
            
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        return result;
    }
 // ▶ 기능 5: 회원 강제 탈퇴 (삭제)
    public int deleteMember(String memberId) {
        String sql = "DELETE FROM MEMBER WHERE MEMBER_ID=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            return pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}