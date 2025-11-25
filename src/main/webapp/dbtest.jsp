<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.DBUtil"%>
<%@ page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB 연결 테스트</title>
</head>
<body>
    <div style="text-align:center; margin-top: 50px;">
        <h1>데이터베이스 연결 테스트</h1>
        <hr>
        <%
            // 방금 만든 DBUtil을 사용해서 연결 시도
            Connection conn = DBUtil.getConnection();

            if (conn != null) {
        %>
            <h2 style="color: green;">✅ 연결 성공!</h2>
            <p>MySQL 데이터베이스 <b>kathena_shop</b>에 정상적으로 접속했습니다.</p>
        <%
                conn.close(); // 테스트 끝났으니 연결 닫기
            } else {
        %>
            <h2 style="color: red;">❌ 연결 실패...</h2>
            <p>이클립스 하단의 <b>Console</b> 창에서 오류 내용을 확인해주세요.</p>
            <p>(비밀번호가 틀렸거나, 드라이버 파일이 없을 수 있습니다.)</p>
        <%
            }
        %>
    </div>
</body>
</html>