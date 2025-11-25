<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO"%>
<%@ page import="dto.MemberDTO"%>

<%
    // 1. 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 2. 사용자가 입력한 값 받기
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    
    // 3. DAO를 통해 로그인 시도
    MemberDAO dao = MemberDAO.getInstance();
    MemberDTO member = dao.login(id, pw);
    
    // 4. 결과 처리
    if(member != null) {
        // 성공: 세션에 회원 정보 저장 ("loginUser"라는 이름표를 붙임)
        session.setAttribute("loginUser", member);
        
        // 메인 페이지로 이동 (아직 안만들었지만 일단 보냄)
        response.sendRedirect("main.jsp");
    } else {
        // 실패: 경고창 띄우고 뒤로 가기
%>
        <script>
            alert("로그인 실패! 아이디나 비밀번호를 확인하세요.");
            history.back();
        </script>
<%
    }
%>