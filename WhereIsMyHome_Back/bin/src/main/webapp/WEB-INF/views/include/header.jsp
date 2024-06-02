<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%
String root = request.getContextPath();
application.setAttribute("root", root);
%>
<!DOCTYPE html>
<!-- ======= Header ======= -->
<header id="header" class="header fixed-top d-flex align-items-center">

	<div class="d-flex align-items-center justify-content-between">
		<a href="/" class="logo d-flex align-items-center"> <img
			src="assets/img/logo.png" alt=""> <span
			class="d-none d-lg-block">구해줘 Home</span>
		</a> <i class="bi bi-list toggle-sidebar-btn"></i>
	</div>
	<!-- End Logo -->

	<nav class="header-nav ms-auto">
		<ul class="d-flex align-items-center">

			<li class="nav-item d-block d-lg-none"><a
				class="nav-link nav-icon search-bar-toggle " href="#"> <i
					class="bi bi-search"></i>
			</a></li>
			<!-- End Search Icon-->

			<li class="nav-item dropdown pe-3"><a
				class="nav-link nav-profile d-flex align-items-center pe-0" href="#"
				data-bs-toggle="dropdown"> <span
					class="d-none d-md-block dropdown-toggle ps-2">회원정보</span>
			</a> <!-- End Profile Iamge Icon -->

				<ul
					class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
						<c:if test="${empty userInfo}">
					<li class="dropdown-header">로그인필요!</span>
					</li>
					<li>
						<hr class="dropdown-divider">
					</li>
						<li><a class="dropdown-item d-flex align-items-center"
							href="<%=root%>/user/join"> <i class="bi bi-person"></i> <span>회원가입</span>
						</a></li>
						<li>
							<hr class="dropdown-divider">
						</li>
						<li><a class="dropdown-item d-flex align-items-center"
							href="<%=root%>/user/login"> <i class="bi bi-box-arrow-right"></i>
								<span>로그인</span>
						</a></li>
					</c:if>

					<c:if test="${not empty userInfo}">
						<li class="dropdown-header"><span>${userInfo.user_name} 님 안녕하세요!</span></li>
						<li>
							<hr class="dropdown-divider">
						</li>
						<li><a class="dropdown-item d-flex align-items-center"
							href="<%=root%>/user/logout"> <i class="bi bi-person"></i> <span>로그아웃</span>
						</a></li>
						<li>
							<hr class="dropdown-divider">
						</li>

						<li><a class="dropdown-item d-flex align-items-center"
							href="<%=root%>/user/mypage"> <i
								class="bi bi-box-arrow-right"></i> <span>마이페이지</span>
						</a></li>

						<li><a class="dropdown-item d-flex align-items-center"
							href="<%=root%>/board/write"> <i
								class="bi bi-box-arrow-right"></i> <span>글쓰기</span>
						</a></li>
					</c:if>




				</ul> <!-- End Profile Dropdown Items --></li>
			<!-- End Profile Nav -->
		</ul>
	</nav>
	<!-- End Icons Navigation -->

</header>
<!-- End Header -->
