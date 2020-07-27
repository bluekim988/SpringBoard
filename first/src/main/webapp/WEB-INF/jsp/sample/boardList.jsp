<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file ="/WEB-INF/include/include-header.jspf" %>

</head>
<body>
	<a href="/first/sample/openBoardList.do"><h2>게시판 목록</h2></a>
	<div class="board_view" style="display: flex;">
		<select id="code_search">
			<option value="idx">글번호</option>
			<option value="title">제목</option>
			<option value="contents">내용</option>
		</select>
		<input type="hidden" id="re_code" value="${code}">
		<input type="hidden" id="re_keyword" value="${keyword}">
		<input type="text" id="keyword_search" name="search" class="wdp_90" onKeypress="javascript:if(event.keyCode==13) {fn_keyword_search()}">
		<input type="button" class="btn" id="search_btn" onclick="fn_keyword_search()" value="검색" style="cursor: pointer;">
		<input type="button" class="btn" id="remove_btn" onclick="fn_remove_checked()" value="선택 삭제" style="cursor: pointer;">
	</div>
	<table class="board_list">
		<colgroup>
			<col width="5%"/>
			<col width="10%"/>
			<col width="*"/>
			<col width="15%"/>
			<col width="20%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">체크</th>
				<th scope="col">글번호</th>
				<th scope="col">제목</th>
				<th scope="col">조회수</th>
				<th scope="col">작성일</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${fn:length(list) > 0}">  <!-- boolean -->
					<c:forEach items="${list }" var="row" varStatus="status">
						<tr>
							<td><input type="checkbox" class="removeIdx" id="${row.IDX}"></td>
							<td>${row.IDX }</td>
							<td class="title">
								<a href="#this" name="title">${row.TITLE }</a>
								<input type="hidden" id="IDX" value="${row.IDX }">
							</td>
							<td>${row.HIT_CNT }</td>
							<td>${row.CREA_DTM }</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="4">조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	
	<c:if test="${not empty paginationInfo }">
		<ui:pagination paginationInfo = "${paginationInfo }" type="text" jsFunction="fn_search"/>
	</c:if>
	<input type="hidden" id="currentPageNo" name="currentPageNo"/>
	
	<br/>
	<a href="#this" class="btn" id="write">글쓰기</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			
			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_openBoardWrite();
			});	
			
			$("a[name='title']").on("click", function(e){ //제목 
				e.preventDefault();
				fn_openBoardDetail($(this)); //$(this)의미 : jQuery <a 태그의미
			});

			$('.removeIdx').on('click', function(e){
				$(e.target).attr.checked = false;
			});
		});
		
		
		function fn_openBoardWrite(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardWrite.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail.do' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val()); // key와 value값
			comSubmit.submit();
		}
		
		function fn_search(pageNo)
		{
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
			comSubmit.addParam("currentPageNo", pageNo);

			var re_code = document.getElementById("re_code").value;
			var re_keyword = document.getElementById("re_keyword").value;
			if(re_code != null && re_code != "") {
				comSubmit.addParam("code", re_code);
				comSubmit.addParam("keyword", re_keyword);
				console.log('test');
			}
			comSubmit.submit();
		}
		function fn_keyword_search() {
			var code = document.getElementById("code_search").value;
			var keyword = document.getElementById("keyword_search").value;
			if(!keyword) {
				alert("입력을 완료해주세요");
				return;
			}
			if(code == 'idx') {
				var exptext = /^[0-9]*$/; 
				var test = exptext.test(keyword);
				if(!test) {
					alert('글번호는 숫자만 입력해주세요');
					return;
				}
			}
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
			comSubmit.addParam("code", code);
			comSubmit.addParam("keyword", keyword);
			comSubmit.submit();
		}

		function fn_remove_checked() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/deleteBoard.do'/>");
			var checkboxTag = document.getElementsByClassName('removeIdx');
			var count = 0;
			for(var i=0; i<checkboxTag.length; i++) {
				if(checkboxTag[i].checked) {
					comSubmit.addParam("idxArray", checkboxTag[i].id);
					count++;
				}				
			}
			if(count > 0)
				comSubmit.submit();
			else 
				alert("삭제할 게시물을 선택해주세요");
		}



	</script>	
</body>
</html>