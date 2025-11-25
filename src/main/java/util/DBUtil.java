package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    
    // DB 연결을 가져오는 공통 메소드
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1. JDBC 드라이버 로드 (MySQL 8.x 버전용)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. 연결 주소 및 인증 정보 설정
            // 주의: 비밀번호(pw)는 본인이 MySQL 설치 시 설정한 것을 넣어야 합니다!
            String url = "jdbc:mysql://localhost:3306/kathena_shop?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8";
            String id = "root"; 
            String pw = "qwemin310!";

            // 3. DB 연결 시도
            conn = DriverManager.getConnection(url, id, pw);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ DB 연결 실패! 아이디/비밀번호나 드라이버 파일(lib)을 확인하세요.");
        }
        return conn;
    }
}