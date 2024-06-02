<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.ssafy.member.model.MemberDto"%>

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
			<div class="row align-items-top">
				<section class="py-5">
					<div class="container px-5">
						<!-- Contact form-->
						<div class="bg-light rounded-3 py-5 px-4 px-md-5 mb-5">
							<div class="text-center mb-5">
								<h1 class="fw-bolder">회원정보확인</h1>
								<p class="lead fw-normal text-muted mb-0">환영합니다</p>
							</div>
							<div class="row gx-5 justify-content-center">
								<div class="col-lg-8 col-xl-6">
									<form id="contactForm" data-sb-form-api-token="API_TOKEN"
										method="post" action="">
										<input type="hidden" name="action" value="modify">
										<!-- 아이디 input-->
										<div class="form-floating mb-3">
											<input class="form-control" name="user_id" id="userId"
												type="text" placeholder="Enter your name..."
												value="${userInfo.user_id }" data-sb-validations="required"
												readonly /> <label for="name">아이디</label>
										</div>

										<!-- 비번 input-->
										<div class="form-floating mb-3">
											<input class="form-control" id="password" type="text"
												name="user_password" placeholder="Enter your password..."
												value="${userInfo.user_password }"
												data-sb-validations="required" readonly /> <label
												for="password">비밀번호</label>
										</div>

										<!-- 이름 input-->
										<div class="form-floating mb-3">
											<input class="form-control" id="name" name="user_name"
												type="text" placeholder="Enter your name..."
												value="${userInfo.user_name }"
												data-sb-validations="required" /> <label for="name">NAME</label>
											<div class="invalid-feedback"
												data-sb-feedback="name:required">A name is required.</div>
										</div>


										<!-- Email 아이디 input-->

										<%-- 	<div class="form-floating mb-3">
											<input class="form-control" id="email" name="email" type="text"
												placeholder="Enter your Email ID..." value="<%=userInfo.getEmail_id() %>"
												data-sb-validations="required" /> <label for="name">NAME</label>
											<div class="invalid-feedback"
												data-sb-feedback="name:required">A Email ID is required.</div>
										</div> --%>


										<div class="form-floating mb-3">
											<input class="form-control" id="email" name="email_id"
												type="text" placeholder="name@example.com"
												value="${userInfo.email_id }" data-sb-validations="required" />
											<label for="email">Email ID</label>
											<div class="invalid-feedback"
												data-sb-feedback="email:required">An email ID is
												required.</div>
											<div class="invalid-feedback" data-sb-feedback="email:email">
												Email ID is not valid.</div>
										</div>

										<!-- Email 도메인 input-->

										<div class="form-floating mb-3">
											<input class="form-control" id="emaildomain"
												name="email_domain" type="email"
												placeholder="Enter your emaildomain..."
												value="${userInfo.email_domain}"
												data-sb-validations="required" /> <label for="name">NAME</label>
											<div class="invalid-feedback"
												data-sb-feedback="name:required">A emaildomain is
												required.</div>
										</div>

										<%-- 
										<div class="form-floating mb-3">
											<input class="form-control" id="emaildomain"
												name="emaildomain" type="email"
												placeholder="name@example.com" value="<%=userInfo.getEmail_domain() %>"
												data-sb-validations="required,email" /> <label for="email">Email
												Domain</label>
	
										</div> --%>

										<!-- Submit Button-->
										<div class="d-grid">
											<button class="btn btn-primary btn-lg" id="submitButton">수정</button>
											<br>
											<button class="btn btn-primary btn-lg" id="deleteButton">삭제</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</section>

			</div>
		</section>

		<!-- password check modal -->
		<div>
			<div class="modal fade" id="passwordModal" tabindex="-1"
				aria-labelledby="passwordModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="passwordModalLabel">비밀번호 확인</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<form id="passwordForm">
								<div class="mb-3">
									<label for="passwordInput" class="form-label">비밀번호를
										입력하세요:</label> <input type="password" class="form-control"
										id="passwordInput" required name="password">
								</div>
								<button type="submit" class="btn btn-primary">확인</button>
							</form>
						</div>
					</div>
				</div>
			</div>

		</div>
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
		document
				.querySelector("#submitButton")
				.addEventListener(
						"click",
						function() {
							document.querySelector("#contactForm").action = "${root}/user/mypage";
							document.querySelector("#contactForm").submit();
						});
	</script>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    // 삭제 버튼 클릭 시 모달 창 표시
    document.querySelector("#deleteButton").addEventListener("click", function() {
      let passwordModal = new bootstrap.Modal(document.getElementById('passwordModal'));
      passwordModal.show();
    });

    // 모달 창 닫힐 때 비밀번호 입력값 초기화
    document.querySelector("#passwordModal").addEventListener("hidden.bs.modal", function() {
      document.querySelector("#passwordInput").value = ""; // 비밀번호 입력값 초기화
    });

    // 비밀번호 확인 후 삭제 요청 등은 이곳에 추가합니다.
  });
</script>



<script>
  document.querySelector("#passwordForm").addEventListener("submit", function (event) {
    event.preventDefault(); // 폼 제출 방지
    let password = document.querySelector("#passwordInput").value;

    let modal = new bootstrap.Modal(document.getElementById('passwordModal'));
    modal.hide();

    fetch("${root}/user/delete", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ password: password })
    })
    .then(response => {
      if (response.ok) {
        alert("계정이 삭제되었습니다.");
        window.location.href = "/";
      } else if (response.status === 401) {
          alert("잘못된 비밀번호입니다.");
      } else {
          alert("계정 삭제에 실패했습니다.");
      }
    })
    .catch(error => {
      console.error("Error:", error);
    });
  });
</script>
</body>

</html>