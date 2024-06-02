<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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


	<main id="main" class="main">

		<!-- Page content-->
		<section class="py-5">
			<div class="container px-5">
				<!-- Contact form-->
				<div class="bg-light rounded-3 py-5 px-4 px-md-5 mb-5">
					<div class="text-center mb-5">

						<h1 class="fw-bolder">비밀번호 찾기!!!</h1>
					</div>
					<div class="row gx-5 justify-content-center">
						<div class="col-lg-8 col-xl-6">



							<c:if test="${isFind}">
								<c:if test="${not notMatch}">
									<div>${user_id }님의 비밀번호 : ${findPassword}</div>
								</c:if>
								<c:if  test="${notMatch}">
									<div>해당 계정은 존재하지않습니다.</div>
								</c:if>
							</c:if>
							<form id="findForm" data-sb-form-api-token="API_TOKEN"
								method="POST" action="<%=root%>/user/findpassword">
								<input type="hidden" name="action" value="find">
								<!-- ID input-->
								<div class="form-floating mb-3">
									<input class="form-control" id="user_id" name="user_id"
										type="text" placeholder="Enter your text..." /> <label>ID</label>
									<div class="invalid-feedback">A ID is required.</div>
								</div>

								<!-- Submit Button-->
								<div class="d-grid">
									<button class="btn btn-primary btn-lg" id="findpassword"
										type="submit">비밀번호 찾기</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</section>
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


</body>
</html>
