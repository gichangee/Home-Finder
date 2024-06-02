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

<!-- Favicons -->
<link href="../assets/img/favicon.png" rel="icon">
<link href="../assets/img/apple-touch-icon.png" rel="apple-touch-icon">

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
<link href="../assets/vendor/simple-datatables/style.css"
	rel="stylesheet">

<!-- Template Main CSS File -->
<link href="../assets/css/style.css" rel="stylesheet">
</head>

<body>

	<%@ include file="../include/header.jsp"%>
	<%@ include file="../include/sidebar.jsp"%>

	<main id="main" class="main">
		<section class="section">
			<div class="container">
				<div class="row justify-content-center">
					<div class="col-lg-8">
						<div class="card">
							<div class="card-header">
								<h2 class="card-title">${board.subject}</h2>
								<div class="row">
									<div class="col">
										<p class="card-subtitle text-muted">작성
											일자:${board.register_time}</p>
									</div>
									<div class="col">
										<p class="card-subtitle text-muted">작성자: ${board.user_id}</p>
									</div>
									<div class="col">
										<p class="card-subtitle text-muted">조회수:${board.hit}</p>
									</div>
								</div>
							</div>
							<div class="card-body" style="padding-top: 20px;">
								<p class="card-text">${board.content}</p>
							</div>

							<!-- 수정 버튼 -->
							<a href="<%=root%>/board/update?article_no=${board.article_no}"
								class="btn btn-primary">수정</a>

							<!-- 삭제 버튼 -->
							<a href="<%=root%>/board/delete?article_no=${board.article_no}"
								class="btn btn-danger">삭제</a>
						</div>
					</div>
				</div>
			</div>
		</section>
	</main>



	<!-- End #main -->

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
		
	</script>
</body>

</html>