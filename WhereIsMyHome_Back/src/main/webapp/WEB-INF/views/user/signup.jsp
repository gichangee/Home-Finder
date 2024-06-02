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

<!-- Favicons -->

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

	<section class="py-5">
		<div class="container px-5">
			<!-- Contact form-->
			<div class="bg-light rounded-3 py-5 px-4 px-md-5 mb-5">
				<div class="text-center mb-5">
					<h1 class="fw-bolder">회원가입</h1>
					<p class="lead fw-normal text-muted mb-0">환영합니다</p>
				</div>
				<div class="row gx-5 justify-content-center">
					<div class="col-lg-8 col-xl-6">

						<form id="joinForm" data-sb-form-api-token="API_TOKEN"
							method="POST" action="">
							<input type="hidden" name="action" value="/user/join">

							<!-- 아이디 input-->
							<div class="form-floating mb-3">
								<input class="form-control" id="userId" name="user_id"
									type="text" placeholder="Enter your ID..."
									data-sb-validations="required" /> <label for="userId">ID</label>
								<div class="invalid-feedback" data-sb-feedback="name:required">
									A id is required.</div>
							</div>

							<!-- 이름 input-->
							<div class="form-floating mb-3">
								<input class="form-control" id="name" name="user_name" type="text"
									placeholder="Enter your name..." data-sb-validations="required" />
								<label for="name">NAME</label>
								<div class="invalid-feedback" data-sb-feedback="name:required">
									A name is required.</div>
							</div>


							<!-- 비밀번호 input-->
							<div class="form-floating mb-3">
								<input class="form-control" id="password" name="user_password"
									type="password" placeholder="Enter your password..."
									data-sb-validations="required" /> <label for="password">Password</label>
								<div class="invalid-feedback" data-sb-feedback="name:required">
									A password is required.</div>
							</div>

							<!-- Email 아이디 input-->

							<div class="form-floating mb-3">
								<input class="form-control" id="email" name="email_id" type="text"
									placeholder="Enter your emailid..."
									data-sb-validations="required" /> <label for="email">Email
									ID</label>
								<div class="invalid-feedback" data-sb-feedback="name:required">
									An email ID is required.</div>
							</div>


							<!--  <div class="form-floating mb-3">
                  <input class="form-control" id="email" name="email" type="text" placeholder="name@example.com" required="required"
                   />
                  <label for="email">Email ID</label>
                  <div class="invalid-feedback" data-sb-feedback="email:required">
                    An email ID is required.
                  </div>
                  <div class="invalid-feedback" data-sb-feedback="email:email">
                    Email ID is not valid.
                  </div>
                </div> -->

							<!-- Email 도메인 input-->


							<div class="form-floating mb-3">
								<input class="form-control" id="emaildomain" name="email_domain"
									type="text" placeholder="Enter your  Emaildomain ..."
									data-sb-validations="required" /> <label for="emaildomain">
									Emaildomain </label>
								<div class="invalid-feedback" data-sb-feedback="name:required">
									An Emaildomain is required.</div>
							</div>


							<!--   <div class="form-floating mb-3">
                  <input class="form-control" id="emaildomain" name="emaildomain" type="email" placeholder="name@example.com"
                     required  />
                  <label for="email">Email Domain</label>
                  <div class="invalid-feedback" data-sb-feedback="email:required">
                    An emaildomain is required.
                  </div>
                  <div class="invalid-feedback" data-sb-feedback="email:email">
                    Emaildomain is not valid.
                  </div>
                </div> -->


							<div class="d-grid">
								<button class="btn btn-primary btn-lg" id="submitButton"
									type="submit">회원가입</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
	</main>

	<script>
document.querySelector("#submitButton").addEventListener("click", function (event) {
    event.preventDefault(); // Prevent default form submission


    // If the email format is valid, submit the form
    let form = document.querySelector("#joinForm");
    form.setAttribute("action", "<%=root%>
		/user/join");
					form.submit();
				});
	</script>

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