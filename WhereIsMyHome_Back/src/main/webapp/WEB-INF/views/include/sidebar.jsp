<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>

<aside id="sidebar" class="sidebar">

	<ul class="sidebar-nav" id="sidebar-nav">

		<li class="nav-item"><a class="nav-link collapsed" href="/">
				<i class="bi bi-grid"></i> <span>Main Page</span>
		</a></li>
		<li class="nav-item"><a class="nav-link collapsed"
			href="${root}/board/list"> <i class="bi bi-grid"></i> <span>Board</span>
		</a></li>
		<!-- End Dashboard Nav -->
		<li class="nav-item"><a class="nav-link collapsed"
			href="${root}/home/map"> <i class="bi bi-geo-alt-fill"></i> <span>Map</span>
		</a> <!-- End Dashboard Nav -->
	</ul>

</aside>
