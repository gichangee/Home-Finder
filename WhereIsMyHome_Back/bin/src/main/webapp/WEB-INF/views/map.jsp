<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.stream.Collectors"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
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
<link href="../../../../assets/css/style.css" rel="stylesheet">

</head>

<body>

	<%@ include file="include/header.jsp"%>
	<%@ include file="include/sidebar.jsp"%>
	<!-- ======= Sidebar ======= -->
	<main id="main" class="main">
		<section class="section">
			<div class="row align-items-top">
				<div class='col-lg-12'>
					<div class='card'>
						<div class='card-body'>
							<form action="">
								<div class='row'>
									<div class="row col-md-12 justify-content-center mb-2">
										<div class="form-group col-md-2 d-flex align-items-center">
											<select class="form-select bg-light text-dark d-inline-block"
												id="sido">
												<option value="">시도선택</option>
											</select>
										</div>
										<div class="form-group col-md-2 d-flex align-items-center">
											<select class="form-select bg-light text-dark d-inline-block"
												id="gugun">
												<option value="">구군선택</option>
											</select>
										</div>
										<div class="form-group col-md-2 d-flex align-items-center">
											<select class="form-select bg-light text-dark d-inline-block"
												id="dong">
												<option value="">동선택</option>
											</select>
										</div>
										<div class="form-group col-md-2 d-flex align-items-center">
											<button type="button" id="list-btn"
												class="btn btn-outline-transparent border-0">
												<img src="../img/gl.png" width="80px" height="80px"
													alt="가져오기">
											</button>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<!-- Features section-->
				<section class="py-5" id="features">
					<div class="container px-5 my-2">
						<div class="row gx-5">
							<div class="col-lg-4 mb-5 mb-lg-0">
								<!-- 테이블 저장 한 곳-->
								<table class="table table-hover text-center"
									style="display: none">
									<tr>
										<th>아파트이름</th>
										<th>건축년도</th>
									</tr>
									<tbody id="aptlist"></tbody>
								</table>
							</div>
							<div class="col-lg-8">
								<div class="row gx-5 row-cols-1 row-cols-md-2">
									<!-- 지도 복사한 곳-->
									<div id="map" style="width: 100%; height: 700px"></div>
									<script type="text/javascript"
										src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ca6f818170cad1a64894a6dc419a62d4&libraries=services"></script>

								</div>

							</div>
						</div>
					</div>
				</section>




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

	<script>
        ///////////////////////// select box 설정 (지역, 매매기간) /////////////////////////
        let date = new Date();

        window.onload = function () {
            sendRequest("sido", "");
        };

        var selectedSido = "";
        var selectedGugun = "";
        var selectedDong = "";

        // 시도가 바뀌면 구군정보 얻기.
        document.querySelector("#sido").addEventListener("change", function () {
            if (this[this.selectedIndex].value) {
                selectedSido = this[this.selectedIndex].value;
                sendRequest("gugun", "?sido=" + selectedSido);
            } else {
                initOption("gugun");
                initOption("dong");
            }
        });

        // 구군이 바뀌면 동정보 얻기.
        document.querySelector("#gugun").addEventListener("change", function () {
            if (this[this.selectedIndex].value) {
                selectedGugun = this[this.selectedIndex].value;
                sendRequest("dong", "?gugun=" + selectedGugun);
            } else {
                initOption("dong");
            }
        });

        document.querySelector("#dong").addEventListener("change", function () {
            selectedDong = this[this.selectedIndex].value // 사용자가 선택한 "동"의 텍스트를 저장
            console.log("변화된 dong" + selectedDong);
            // 필요한 추가 작업이 있다면 여기에 구현
        });

        function sendRequest(selid, command) {
            //const url = "http://localhost:8080/home/home?action=" + selid + command;
            const url = "${root}/home/address/"+selid+command;
            
            const options = {
            	    method: 'GET',
            	    headers: {
            	        'Content-Type': 'application/json'
            	    }
            	};
            
            console.log(url);
            fetch(url,options)
                .then((response) => response.json())
                .then((data) => addOption(selid, data));
        }

        function addOption(selid, data) {
    console.log(data);
    let opt = ``;
    initOption(selid);
    switch (selid) {
        case "sido":
            opt += '<option value="">시도선택</option>';
            data.sidoList.forEach(function(sido) {
                opt += '<option value="' + sido + '">' + sido + '</option>';
            });
            break;
        case "gugun":
            opt += '<option value="">구군선택</option>';
            data.gugunList.forEach(function(gugun) {
                opt += '<option value="' + gugun + '">' + gugun + '</option>';
            });
            break;
        case "dong":
            opt += '<option value="">동선택</option>';
            data.dongList.forEach(function(dong) {
                opt += '<option value="' + dong + '">' + dong + '</option>';
            });
            break;
    }
    document.querySelector("#" + selid).innerHTML = opt;
}


        function initOption(selid) {
            let options = document.querySelector("#" + selid);
            console.log(options);
            options.length = 0;
        }



        ///////////////////////// 아파트 매매 정보 /////////////////////////
        document.querySelector("#list-btn").addEventListener("click", function () {
            // 지도 스크립트
            var address_header_map = selectedSido + " " + selectedGugun + " " + selectedDong;
            console.log(address_header_map);
            var myLatLng = new kakao.maps.LatLng(33.450701, 126.570667);
            var container = document.getElementById("map"); //지도를 담을 영역의 DOM 레퍼런스
            var options = {
                //지도를 생성할 때 필요한 기본 옵션
                center: myLatLng, //지도의 중심좌표.
                level: 3, //지도의 레벨(확대, 축소 정도)
            };

            var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

            // 주소-좌표 변환 객체를 생성합니다
            var geocoder = new kakao.maps.services.Geocoder();

            geocoder.addressSearch(address_header_map, function (result, status) {

                // 정상적으로 검색이 완료됐으면
                if (status === kakao.maps.services.Status.OK) {

                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    // var message = 'latlng: new kakao.maps.LatLng(' + result[0].y + ', ';
                    // message += result[0].x + ')';

                    var resultDiv = document.getElementById('clickLatlng');
                    // resultDiv.innerHTML = message;

                    // 결과값으로 받은 위치를 마커로 표시합니다
                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: coords
                    });

                    // 인포윈도우로 장소에 대한 설명을 표시합니다
                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="width:150px;text-align:center;padding:6px 0;">중심 위치</div>'
                    });
                    infowindow.open(map, marker);

                    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                    map.setCenter(coords);
                }
            });

            
            //const url = "http://localhost:8080/home/home?action=full&dong=" + selectedDong;
            const url = "${root}/home/full?dong="+selectedDong;
            console.log("마지막 " + url);
            fetch(url)
            .then((response) => response.json())
            .then((data) => {
                    makeList(data, address_header_map);
   
            })
            .catch((error) => {
            	 initTable();
            });
        });

      

        function makeList(data, address_header_map) {

            document.querySelector("table").setAttribute("style", "display: ;");
            document.querySelector("table").classList.add("table", "table-striped", "table-hover", "table-responsive");

            let tbody = document.querySelector("#aptlist");
            initTable(); // 기존 테이블의 내용을 초기화

            let sortedData = mergeSort(data.dongList);

            let cnt = 0;
            sortedData.forEach((apt) => {
                // JSON 데이터에서 필요한 값 추출
                let tr = document.createElement("tr");
                tr.setAttribute("id", "trname" + cnt);

                // 아파트 이름
                let nameTd = document.createElement("td");
                nameTd.appendChild(document.createTextNode(apt.apartmentName));
                tr.appendChild(nameTd);

                // 건축년도 (또는 다른 필요한 데이터)
                let yearTd = document.createElement("td");
                yearTd.appendChild(document.createTextNode(apt.buildYear));
                tr.appendChild(yearTd);

                let arr = "trname" + cnt;
                let aptName = apt.apartmentName;
                let aptBuildYear = apt.buildYear;
                let aptDong = apt.dong;
                let aptlng = apt.lng;
                let aptlat = apt.lat;

                tbody.appendChild(tr);

                document.getElementById(arr).addEventListener("click", () =>
                    trclick(aptName, aptBuildYear, aptDong, aptlng, aptlat, address_header_map)
                );

                cnt++;
            });
        }
        
        function initTable() {
            let tbody = document.querySelector("#aptlist");
            while (tbody.firstChild) {
                tbody.removeChild(tbody.firstChild);
            }
        }

        function trclick(aptName, aptBuildYear, aptDong,aptlng,aptlat,address_header_map) {
            var myLatLng = new kakao.maps.LatLng(33.450701, 126.570667);
            var container = document.getElementById("map"); //지도를 담을 영역의 DOM 레퍼런스
            var options = {
                //지도를 생성할 때 필요한 기본 옵션
                center: myLatLng, //지도의 중심좌표.
                level: 3, //지도의 레벨(확대, 축소 정도)
            };

            var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

            // 주소-좌표 변환 객체를 생성합니다
            var geocoder = new kakao.maps.services.Geocoder();

            geocoder.addressSearch(address_header_map, function (result, status) {

                // 정상적으로 검색이 완료됐으면
                if (status === kakao.maps.services.Status.OK) {

                    var coords = new kakao.maps.LatLng(aptlat, aptlng);
                    // var message = 'latlng: new kakao.maps.LatLng(' + result[0].y + ', ';
                    // message += result[0].x + ')';

                    var resultDiv = document.getElementById('clickLatlng');
                    // resultDiv.innerHTML = message;

                    // 결과값으로 받은 위치를 마커로 표시합니다
                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: coords
                    });

                    // 인포윈도우로 장소에 대한 설명을 표시합니다
                    var infowindow = new kakao.maps.InfoWindow({
                        content:'<div class="card" style="width: 18rem;">' +
  '<div class="card-body">' +
    '<h5 class="card-title">' + aptName + '</h5>' +
    '<p class="card-text"><strong>건축 연도:</strong> ' + aptBuildYear + '</p>' +
    '<p class="card-text"><strong>위치:</strong> ' + address_header_map + '</p>' +
  '</div>' +
'</div>'

                    });
                    infowindow.open(map, marker);

                    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                    map.setCenter(coords);
                }
            });
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        function mergeSort(arr) {
            if (arr.length <= 1) {
                return arr;
            }

            const mid = Math.floor(arr.length / 2);
            const left = arr.slice(0, mid);
            const right = arr.slice(mid);

            return merge(mergeSort(left), mergeSort(right));
        }

        function merge(left, right) {
            let result = [];
            let leftIndex = 0;
            let rightIndex = 0;

            while (leftIndex < left.length && rightIndex < right.length) {
                if (left[leftIndex].buildYear < right[rightIndex].buildYear) {
                    result.push(left[leftIndex]);
                    leftIndex++;
                } else {
                    result.push(right[rightIndex]);
                    rightIndex++;
                }
            }

            return result.concat(left.slice(leftIndex)).concat(right.slice(rightIndex));
        }
        
    </script>
	<script src="../js/template.js"></script>
</body>

</html>