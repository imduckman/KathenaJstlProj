package dto;

import java.sql.Timestamp; // 날짜 시간용

public class MemberDTO {
    // 1. 멤버 변수 (DB 컬럼명과 매칭)
    private String memberId;
    private String password;
    private String name;
    private int point;
    private Timestamp joinDate;
    private String role;

    // 2. 기본 생성자 (필수)
    public MemberDTO() {}

    // 3. 모든 필드를 초기화하는 생성자 (편의용)
    public MemberDTO(String memberId, String password, String name, int point, Timestamp joinDate, String role) {
        this.memberId = memberId;
        this.password = password;
        this.name = name;
        this.point = point;
        this.joinDate = joinDate;
        this.role = role;
    }

    // 4. Getter & Setter (단축키: Alt + Shift + S 누른 뒤 R)
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getPoint() { return point; }
    public void setPoint(int point) { this.point = point; }

    public Timestamp getJoinDate() { return joinDate; }
    public void setJoinDate(Timestamp joinDate) { this.joinDate = joinDate; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}