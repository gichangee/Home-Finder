<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<title>Components / Cards - NiceAdmin Bootstrap Template</title>
<meta content="" name="description">
<meta content="" name="keywords">

<!-- Google Fonts -->
<link href="https://fonts.gstatic.com" rel="preconnect">
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
	rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="../assets/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css"
	rel="stylesheet">
<link href="../assets/vendor/boxicons/css/boxicons.min.css"
	rel="stylesheet">
<link href="../assets/vendor/quill/quill.snow.css" rel="stylesheet">
<link href="../assets/vendor/quill/quill.bubble.css" rel="stylesheet">
<link href="../assets/vendor/remixicon/remixicon.css" rel="stylesheet">
<link href="../assets/vendor/simple-datatables/style.css" rel="stylesheet">

<!-- Template Main CSS File -->
<link href="../assets/css/style.css" rel="stylesheet">


</head>

<body>

	<%@ include file="../include/header.jsp"%>
	<%@ include file="../include/sidebar.jsp"%>

	</ul>
	</aside>
	<!-- End Sidebar-->
	<main id="main" class="main">
		<div class="container">

			<div class="row justify-content-center">
				<div class="col-lg-8 col-md-10 col-sm-12">
					<h2 class="my-3 py-3 shadow-sm bg-light text-center">
						<mark class="sky">글목록</mark>
					</h2>
				</div>
				<div class="col-lg-8 col-md-10 col-sm-12">
					<div class="row align-self-center mb-2">
						<div class="col-md-2 text-start">
							<button type="button" id="btn-mv-register"
								class="btn btn-outline-primary btn-sm">글쓰기</button>
						</div>

						<div class="col-md-7 offset-3">
							<form id="form-search" class="d-flex">
								<select id="key" name="key"
									class="form-select form-select-sm ms-5 me-1 w-50"
									aria-label="검색조건">
									<option selected>검색조건</option>
									<option value="article_no">글번호</option>
									<option value="subject">제목</option>
									<option value="user_id">작성자</option>
								</select>
								<div class="input-group input-group-sm">
									<input id="word" name="word" type="text" class="form-control"
										placeholder="검색어..." />
									<button id="btn-search" class="btn btn-dark" type="button">검색</button>
								</div>
							</form>
						</div>

					</div>
					<table class="table table-hover">
						<thead>
							<tr class="text-center">
								<th scope="col">글번호</th>
								<th scope="col">제목</th>
								<th scope="col">작성자</th>
								<th scope="col">조회수</th>
								<th scope="col">작성일</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="article" items="${board}">
								<tr class="text-center">
									<th scope="row">${article.article_no}</th>
									<td class="text-start"> ${article.subject}</td>
									<td>${article.user_id}</td>
									<td>${article.hit}</td>
									<td>${article.register_time}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

			</div>
		</div>

	</main>



	<!-- ======= Footer ======= -->
	<footer id="footer" class="footer">
		<div class="copyright">
			&copy; Copyright <strong><span>NiceAdmin</span></strong>. All Rights
			Reserved
		</div>
		<div class="credits">
			<!-- All the links in the footer should remain intact. -->
			<!-- You can delete the links only if you purchased the pro version. -->
			<!-- Licensing information: https://bootstrapmade.com/license/ -->
			<!-- Purchase the pro version with working PHP/AJAX contact form: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/ -->
			Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
		</div>
	</footer>
	<!-- End Footer -->

	<a href="#"
		class="back-to-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>

	<!-- Vendor JS Files -->
	<script src="../assets/vendor/apexcharts/apexcharts.min.js"></script>
	<script src="../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="../assets/vendor/chart.js/chart.umd.js"></script>
	<script src="../assets/vendor/echarts/echarts.min.js"></script>
	<script src="../assets/vendor/quill/quill.min.js"></script>
	<script src="../assets/vendor/simple-datatables/simple-datatables.js"></script>
	<script src="../assets/vendor/tinymce/tinymce.min.js"></script>
	<script src="../assets/vendor/php-email-form/validate.js"></script>

	<script src="../js/template.js"></script>



	<script>
	document.querySelector("#btn-mv-register").addEventListener("click",
			function() {
				location.href = "${root}/board/write";
			})
		;
	</script>

	<script>
	
	document.querySelector("#btn-search").addEventListener("click", function () {
	    const selectBox = document.querySelector("#key");
	    const selectedOption = selectBox.options[selectBox.selectedIndex];
	    const selectKey = selectedOption.value;
	    const inputText = document.querySelector("#word").value.trim(); // ID가 "word"인 요소의 값을 가져옴
	    location.href = "<%=root%>/board/multipleSearch?selectKey=" + selectKey + "&inputText=" + inputText;
	});
	  
	</script>
	
	<script>
	//게시글 상세조회
	 const rows = document.querySelectorAll(".text-center");
		rows.forEach((row)=>{
			row.addEventListener("click",viewArticle);
		});
	function viewArticle(e){
		const article_no = e.target.parentElement.firstElementChild.innerText;
		location.href = "<%=root%>/board/view?article_no="+article_no;
	}
	</script> 
</body>
</html>
