<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.border{border: 1px solid silver;}
	.mt-1{margin-top: 10px;}
	.mt-5{margin-top: 50px;}
	.mr{margin-right: 30px;}
	.d-flex{display: flex;}
</style>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<table class="board_view">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		<caption>게시글 상세</caption>
		<tbody>
			<tr>
				<th scope="row">글 번호</th>
				<td>${map.IDX }</td>
				<th scope="row">조회수</th>
				<td>${map.HIT_CNT }</td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td>${map.CREA_ID }</td>
				<th scope="row">작성시간</th>
				<td>${map.CREA_DTM }</td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">${map.TITLE }</td>
			</tr>
			<tr>
				<td colspan="4">${map.CONTENTS }</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
				<c:choose>
					<c:when test="${fn:length(list) >0 }"> <!--  boolean  -->
						<c:forEach var="row" items="${list}">
							<input type="hidden" id="IDX" value="${row.IDX }">
							<a href="#this" name="file">${row.ORIGINAL_FILE_NAME }</a>
							(${row.FILE_SIZE }kb)
						</c:forEach>
					</c:when>
						<c:otherwise>첨부된 파일이 없습니다.!</c:otherwise>
				</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
	
	<a href="#this" class="btn" id="list">목록으로</a>
	<a href="#this" class="btn" id="update">수정하기</a>
	<a href="#this" class="btn" id="remove">삭제하기</a>
	<a href="#this" class="btn" id="prePage" onclick="fn_showPage('pre')">이전페이지</a>
	<a href="#this" class="btn" id="nextPage" onclick="fn_showPage('next')">다음페이지</a>
	
	<div class="board_view mt-5">
		<div class="d-flex mt-1">
			<label class="mr" for="replyWriter" >작성자</label>
			<input type="text" id="replyWriter">
		</div>
		<div class="d-flex mt-1">
			<input type="text" id="replyInput" style="width: 90%;">
			<input type="button" id="replyBtn" class="btn" style="width: 10%;" value="작성" onclick="fn_addReplyProcess()">
		</div>
		<table class="">
			<colgroup>
				<col width="15%"/>
				<col width="15%"/>
				<col width="70%"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">작성자</th>
					<th scope="col">작성일</th>
					<th scope="col">댓글 내용</th>
				</tr>
			</thead>	
			<tbody>
			<c:choose>
				<c:when test="${fn:length(replyList) > 0}">
				<c:forEach var="replyData" items="${replyList}">
					<tr>
						<td>${replyData.CREA_ID}</td>
						<td>${replyData.CREA_DTM}</td>
						<td>${replyData.CONTENTS}</td>
					</tr>				
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="3">조회된 결과가 없습니다</td>
					</tr>
				</c:otherwise>
			</c:choose>

			</tbody>					
		</table>
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_openBoardList();
			});
			
			$("#update").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_openBoardUpdate();
			});
			$("#remove").on("click", function(e){ //삭제하기 버튼
				e.preventDefault();
				fn_deleteBoard();
			});
			$("a[name='file']").on("click", function(e){ //파일이름
				e.preventDefault();
				fn_downloadFile($(this));
			});
		});
		
		function fn_openBoardList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardUpdate(){
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardUpdate.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		
		function fn_deleteBoard()
		{
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/deleteBoard.do'/>");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		
		function fn_downloadFile(obj)
		{
			var idx = obj.parent().find("#IDX").val();
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/common/downloadFile.do'/>");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}

		function fn_showPage(code) {
			var idx = "${map.IDX}";
			var next = "${map.NEXT}";
			var pre = "${map.PRE}";
			var bool = fn_checkPage(code, next, pre);
			if(!bool) {
				return;
			}
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.addParam("NEXT", next);
			comSubmit.addParam("PRE", pre);
			comSubmit.addParam("code", code);
			comSubmit.submit();
		}
		
		function fn_checkPage(code, next, pre) {
			var bool;
			if(code == 'next' && next == 0) {
				alert('마지막 글입니다');
				bool = false;
			} else if(code == 'pre' && pre == 0) {
				alert('첫 번째 글입니다');
				bool = false;
			} else {
				bool = true;
			}
			return bool;
		}

		function fn_addReplyProcess() {
			var replyWriter = document.getElementById("replyWriter").value;
			var replyContents = document.getElementById("replyInput").value;
			if(!replyWriter || !replyContents)
				return;
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/insertBoard.do' />");
			comSubmit.addParam("CREA_ID", replyWriter);
			comSubmit.addParam("CONTENTS", replyContents);
			comSubmit.addParam("TITLE", '${map.IDX }'+"댓글");
			comSubmit.addParam("PARENT_IDX", '${map.IDX }');
			comSubmit.submit();
		}
	</script>
</body>
</html>