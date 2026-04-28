<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 패널티 처리 이력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .wf-header { font-weight: bold; background-color: #f8f9fa; border-bottom: 2px solid #ced4da; position: sticky; top: 0; z-index: 10; }
    .table-container { border: 1px solid #ced4da; background-color: #ffffff; min-height: 500px; overflow-y: auto; }
    th, td { padding: 12px !important; vertical-align: middle; text-align: center; }
</style>
<script type="text/javascript">

function cancelPenalty(penaltyId) {

	const confirmResult = confirm("패널티 ID : " + penaltyId + "\n정말로 이 패널티를 취소하시겠습니까?");
	if (!confirmResult)
	{
		return false;
	}
	
	const cancelReason = prompt("취소 사유를 입력하세요.");
	if (!cancelReason.trim())
	{
		alert("취소 사유를 입력해야 합니다.");
		return false;
	}
	
	
	let formEl = document.createElement('form');
	formEl.method = 'POST';
	formEl.action = "${ pageContext.request.contextPath }/admin/penalty/cancel";
	
	
	let inputEl = document.createElement('input');
	inputEl.type = 'hidden';
	inputEl.name = "penaltyId";
	inputEl.value = penaltyId;
	formEl.appendChild(inputEl);
	
	
	inputEl = document.createElement('input');
	inputEl.type = 'hidden';
	inputEl.name = "cancelReason";
	inputEl.value = cancelReason;
	formEl.appendChild(inputEl);
	
	
	inputEl = document.createElement('input');
	inputEl.type = 'hidden';
	inputEl.name = "url";
	inputEl.value = location.href;
	formEl.appendChild(inputEl);
	
	
	document.body.appendChild(formEl);
	formEl.submit();
	
}

</script>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <h4 class="fw-bold mb-4">패널티 처리 이력</h4>
        <div class="table-container shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="wf-header">
                    <tr>
                        <th>페널티 ID</th>
                        <th>처리자</th>
                        <th>대상 유저</th>
                        <th>점수</th>
                        <%--
                        <th>사유</th>
                        --%>
                        <th>처리 일시</th>
                        <th>취소자</th>
                        <th>취소 사유</th>
                        <th>취소 일시</th>
                        <th>취소하기</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach var="penaltyHistoryDto" items="${ penaltyuHistoryList }">
                	<tr>
                        <td>${ penaltyHistoryDto.penaltyId }</td>
                        <td>${ penaltyHistoryDto.adminAccountId }</td>
                        <td>${ penaltyHistoryDto.userId }</td>
                        <td>
                        	<span class="badge bg-danger">
                        		${ penaltyHistoryDto.penaltyScore }
							</span>
						</td>
						<%--
                        <td>허위 매물 등록</td>
                        --%>
                        <td>${ penaltyHistoryDto.createdAt }</td>
                        
                        <td>${ penaltyHistoryDto.cancelAdminAccountId == 0 ? "-" : penaltyHistoryDto.cancelAdminAccountId }</td>
                        <td>${ empty penaltyHistoryDto.cancelReason ? "-" : penaltyHistoryDto.cancelReason}</td>
                        <td>${ empty penaltyHistoryDto.canceledAt ? "-" : penaltyHistoryDto.canceledAt }</td>
                        <td>
                        	<c:choose>
                        		<c:when test="${ penaltyHistoryDto.penaltyCancelId == 0 }">
                        			<%-- 취소 가능한 상태 --%>
                        			<button type="button" class="btn btn-sm btn-outline-danger btn-admin-custom"
                        			 onclick="cancelPenalty(${ penaltyHistoryDto.penaltyId });">
                        				취소하기
                        			</button>
                        		</c:when>
						        <c:otherwise>
						            <%-- 이미 취소 완료된 상태 --%>
						            <button type="button" class="btn btn-sm btn-action-disabled btn-admin-custom" tabindex="-1">
						                취소완료
						            </button>
						        </c:otherwise>
						    </c:choose>
						</td>
                    </tr>
                	</c:forEach>
                </tbody>
            </table>
        </div>
        
		<br><br>

        <div>
			${ pageElement }
        </div>
    </div>
</body>
</html>