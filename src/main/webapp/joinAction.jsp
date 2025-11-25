<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO"%>
<%@ page import="dto.MemberDTO"%>

<%
    // 1. 한글 처리 (필수)
    request.setCharacterEncoding("UTF-8");

    // 2. 입력값 받기
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String name = request.getParameter("name");
    
    // 3. DTO 객체에 담기
    MemberDTO newMember = new MemberDTO();
    newMember.setMemberId(id);
    newMember.setPassword(pw);
    newMember.setName(name);
    
    // 4. DAO 호출해서 DB에 저장
    MemberDAO dao = MemberDAO.getInstance();
    int result = dao.insertMember(newMember);
    
    // 5. 결과 확인
    if (result == 1) {
        // 성공 시
%>
        <script>
            alert("회원가입 성공! \n로그인 해주세요.");
            location.href = "login.jsp";
        </script>
<%
    } else {
        // 실패 시 (주로 아이디 중복)
%>
        <script>
            alert("가입 실패!\n이미 사용 중인 아이디이거나 오류가 발생했습니다.");
            history.back();
        </script>
<%
    }
%>