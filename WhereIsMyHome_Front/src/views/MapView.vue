<!-- eslint-disable no-undef -->
<script setup>
import axios from "axios";
import { storeToRefs } from "pinia";
import { ref, onMounted, watch } from "vue";
import { KakaoMap, KakaoMapMarker, KakaoMapInfoWindow } from "vue3-kakao-maps";
import { useRouter } from "vue-router";
import { useMapStore } from "@/stores/map";
import AptListItem from "@/components/map/AptListItem.vue";
import MapDetail from "@/components/map/MapDetail.vue";
import PagingBar from "../components/layout/PagingBar.vue";
import CheckList from "../components/map/CheckList.vue";

const isModalOpen = ref(false);

const openAndClose = () => {
    isModalOpen.value = !isModalOpen.value;
};

//데이터 정보를 받음
const aptDataList = ref(null);
const recentAmountList = ref([]);

const store = useMapStore();
const router = useRouter();
const selectedSido = ref("");
const selectedGugun = ref("");
const selectedDong = ref("");

const fullDongcode = ref("");
const lat = ref(33.450701);
const lng = ref(126.570667);
const map = ref();

//로딩판단
const waitData = ref(false);

//sort타입
const selectedSortType = ref("low-price");

//마커 리스트
let list = ref([]);
const isModalVisible = ref(false);

const { isDetail } = storeToRefs(store);
const detailProps = ref({});

//추가 필터 모달창
const showModal = () => {
    isModalVisible.value = !isModalVisible.value;
};

//지도 로드
const onLoadKakaoMap = (mapRef) => {
    console.log("map load");
    map.value = mapRef;
};

const address_header_map = selectedSido.value + " " + selectedGugun.value + " " + selectedDong.value;

//지도 중심 잡기
const setCenter = (newLat, newLng) => {
    if (map.value) {
        lat.value = newLat;
        lng.value = newLng;
        map.value.setLevel(3);
        map.value.setCenter(new kakao.maps.LatLng(newLat, newLng));
    }
};

//시도 데이터 변경 시 발생하는 이벤트 -> 구군 데이터를 가져옴
const onSidoChange = (event) => {
    if (event.target.value) {
        selectedSido.value = event.target.value;
        sendRequest("gugun", "?sido=" + selectedSido.value);
    } else {
        initOption("gugun");
        initOption("dong");
    }
};

//구군 데이터 변경시 발생하는 이벤트 -> 동 데이터를 가져옴
const onGugunChange = (event) => {
    if (event.target.value) {
        selectedGugun.value = event.target.value;
        sendRequest("dong", "?sido=" + selectedSido.value + "&gugun=" + selectedGugun.value);
    } else {
        initOption("dong");
    }
};

//동 데이터 변경 시 발생하는 이벤트 -> 풀코드 가져오기
const onDongChange = (event) => {
    selectedDong.value = event.target.value;
    const address_header_map = selectedSido.value + " " + selectedGugun.value + " " + selectedDong.value;

    const url =
        "http://localhost:8080/home/address/name?sido=" +
        selectedSido.value +
        "&gugun=" +
        selectedGugun.value +
        "&dong=" +
        selectedDong.value;

    axios
        .get(url)
        .then((response) => {
            fullDongcode.value = response.data;
        })
        .catch((error) => console.error("Error fetching data:", error));
};

const sendRequest = (selid, command) => {
    const url = "http://localhost:8080/home/address/" + selid + command;

    axios
        .get(url)
        .then((response) => addOption(selid, response.data))
        .catch((error) => console.error("Error fetching data:", error));
};

const addOption = (selid, data) => {
    let opt = ``;
    initOption(selid);
    switch (selid) {
        case "sido":
            opt += '<option value="">시도선택</option>';
            data.sidoList.forEach((sido) => {
                opt += `<option value="${sido}">${sido}</option>`;
            });
            break;
        case "gugun":
            opt += '<option value="">구군선택</option>';
            data.gugunList.forEach((gugun) => {
                opt += `<option value="${gugun}">${gugun}</option>`;
            });
            break;
        case "dong":
            opt += '<option value="">동선택</option>';
            data.dongList.forEach((dong) => {
                opt += `<option value="${dong}">${dong}</option>`;
            });
            break;
    }
    document.querySelector("#" + selid).innerHTML = opt;
};

const initOption = (selid) => {
    let options = document.querySelector("#" + selid);
    options.innerHTML = "";
};

//dongcode 테이블에서 dongcode 가져오기
//houseinfo에서 dongcode을 이용해서 모든 데이터 가져오기 select * from houseinfo where dongcode = #{dongcode}
const fetchAptList = async () => {
    const url = "http://localhost:8080/home/full?dongCode=" + fullDongcode.value;

    await axios
        .get(url)
        .then(async (response) => {
            aptDataList.value = response.data;
            await makeList(response.data);

            // 데이터가 있는 경우 첫번째 아파트 위치를 기준으로 지도를 보여줌
            if (sortedData.value.length > 0) {
                console.log(sortedData.value[0]);
                const firstItem = sortedData.value[0].aptInfo;
                lat.value = firstItem.lat;
                lng.value = firstItem.lng;

                const newLatLng = new kakao.maps.LatLng(lat.value, lng.value);
                setCenter(lat.value, lng.value); // 첫 번째 아이템의 위치로 설정
            } else {
                sortedData.value = null;
            }
        })
        .catch((error) => {
            initTable();
        });
};

const sortedData = ref([]);
const makeList = async (data) => {
    let cnt = 0;

    recentAmountList.value = [];

    for (const apt of data.dongList) {
        const url = "http://localhost:8080/home/amount?aptCode=" + apt.aptCode;
        try {
            const response = await axios.get(url);
            recentAmountList.value = [
                ...recentAmountList.value,
                {
                    aptInfo: apt,
                    recentAmount: response.data,
                },
            ];
            let arr = "home" + cnt;
            let aptlng = apt.lng;
            let aptlat = apt.lat;

            const markerItem = {
                lat: aptlat,
                lng: aptlng,
                apartmentName: apt.apartmentName,
            };
            list.value.push(markerItem);
        } catch (error) {
            console.log(error);
        }
    }

    sortedData.value = recentAmountList.value;
    sorting();
    waitData.value = true;
};

const initTable = () => {
    const tbody = document.querySelector(".apt-list");
    while (tbody.firstChild) {
        tbody.removeChild(tbody.firstChild);
    }
};

const goback = () => {
    isDetail.value = false;
};

function trclick(aptlng, aptlat, aptCode, roadName) {
    // 클릭한 아파트의 위도와 경도를 이용하여 새로운 LatLng 객체를 생성합니다.
    const newLatLng = new kakao.maps.LatLng(aptlat, aptlng);
    console.log(aptlng + "여기는 맵뷰 " + aptlat);

    // 만약 map이 정의되어 있다면 (지도가 로드된 경우)
    if (map.value) {
        // map을 사용하여 중심을 새로운 위도와 경도로 설정합니다.
        map.value.setCenter(newLatLng);
        isDetail.value = true;

        const aptInfo = aptDataList.value.dongList.find((apt) => apt.aptCode === aptCode);

        detailProps.value = {
            aptCode: aptCode,
            fullDongcode: fullDongcode.value,
            aptInfo: aptInfo,
            roadName: roadName,
        };
        // redirectToDetailPage 함수 호출 시 aptCode를 함께 전달합니다.
        // redirectToDetailPage(aptCode);
    }
}

const navigateToAll = () => {
    waitData.value = false;
    fetchAptList();
    //   router.push({ name: "all", params: { fullDongcode: fullDongcode.value } });
};

watch([() => store.lat, () => store.lng], ([newLat, newLng]) => {
    setCenter(newLat, newLng);
});

const { VITE_OPEN_API_SERVICE_KEY, VITE_SEARCH_TRIP_URL } = import.meta.env;
const { VITE_CON_OPEN_API_SERVICE_KEY, VITE_CON_URL } = import.meta.env;

const params = ref({
    serviceKey: VITE_OPEN_API_SERVICE_KEY,
    MobileOS: "ETC",
    MobileApp: "AppTest",
    _type: "json",
    mapX: lng.value,
    mapY: lat.value,
    radius: 1000,
    contentTypeId: "",
});

const paramsCon = ref({
    serviceKey: VITE_CON_OPEN_API_SERVICE_KEY,
    xPos: lng.value,
    yPos: lat.value,
    radius: 3000,
});

const checkedNames = ref([]);
const attractions = ref([]);

const searchAttraction2 = async () => {
    attractions.value = [];

    if (checkedNames.value.length > 0) {
        const attractionRequests = checkedNames.value.map(async (name) => {
            if (name === "버스정류장") {
                const url = "http://localhost:8080/building/bus?city=" + selectedSido.value;
                const { data } = await axios.get(url);
                const attractionsData = data.map((item) => ({
                    ...item,
                    bname: name,
                }));
                attractions.value.push(...attractionsData);
            } else {
                const url =
                    "http://localhost:8080/building/list?medium_business_category=" +
                    name +
                    "&dongCode=" +
                    fullDongcode.value;
                const { data } = await axios.get(url);
                const attractionsData = data.map((item) => ({
                    ...item,
                    bname: name,
                }));
                attractions.value.push(...attractionsData);
            }
        });
    }
};

// 주변 관광지 시설 검색
const searchAttraction = async () => {
    attractions.value = [];
    if (checkedNames.value.length > 0) {
        const attractionRequests = checkedNames.value.map(async (name) => {
            if (name == "1") {
                paramsCon.value.xPos = lng.value;
                paramsCon.value.yPos = lat.value;

                try {
                    const { data } = await axios.get(VITE_CON_URL, {
                        params: paramsCon.value,
                    });

                    // Add mapY and mapX to each item and push to attractions array
                    const attractionsData = data.response.body.items.item.map((item) => ({
                        ...item,
                        mapy: item.YPos, // Assuming mapY is already present in item
                        mapx: item.XPos, // Assuming mapX is already present in item
                        contenttypeid: "1",
                    }));

                    attractions.value.push(...attractionsData);
                    if (attractions.value.length === 0) {
                        console.log("attractions 배열이 비어 있습니다.");
                    } else {
                        attractions.value.forEach((attraction) => {
                            console.log(attraction.mapy);
                        });
                    }
                } catch (error) {
                    console.error("Error fetching data for contentTypeId 1:", error);
                }
            } else {
                params.value.contentTypeId = name;
                params.value.mapX = lng.value;
                params.value.mapY = lat.value;

                try {
                    const { data } = await axios.get(VITE_SEARCH_TRIP_URL, {
                        params: params.value,
                    });
                    // Add mapY and mapX to each item and push to attractions array
                    const attractionsData = data.response.body.items.item.map((item) => ({
                        ...item,
                    }));

                    attractions.value.push(...attractionsData);

                    if (attractions.value.length === 0) {
                        console.log("attractions 배열이 비어 있습니다.");
                    } else {
                        attractions.value.forEach((attraction) => {
                            console.log(attraction.mapy);
                        });
                    }
                } catch (error) {
                    console.error(`Error fetching data for contentTypeId ${name}:`, error);
                }
            }
        });

        try {
            await Promise.all(attractionRequests);
        } catch (error) {
            console.error("Error fetching data:", error);
        }
    } else {
        params.value.contentTypeId = ""; // 기본값 또는 다른 처리
        try {
            const response = await axios.get(VITE_SEARCH_TRIP_URL, {
                params: params.value,
            });
            console.log("Search results:", response.data);
        } catch (error) {
            console.error("Error fetching data:", error);
        }
    }
};

const getImageForValue = (value) => {
    let imageSrc;
    switch (value) {
        case "미용":
            imageSrc = "https://img.icons8.com/dusk/64/manicure.png";
            break;
        case "한식":
            imageSrc = "https://img.icons8.com/dusk/64/rice-bowl.png";
            break;
        case "세탁":
            imageSrc = "https://img.icons8.com/dusk/64/washing-machine.png";
            break;
        case "일식":
            imageSrc =
                "https://img.icons8.com/external-victoruler-flat-gradient-victoruler/64/external-sushi-food-and-delivery-victoruler-flat-gradient-victoruler.png";
            break;
        case "주점":
            imageSrc = "https://img.icons8.com/dusk/64/beer.png";
            break;
        case "중식":
            imageSrc = "https://img.icons8.com/dusk/64/kimchi-mandu.png";
            break;
        case "서양식":
            imageSrc = "https://img.icons8.com/dusk/64/kawaii-steak.png";
            break;
        case "교육":
            imageSrc = "https://img.icons8.com/dusk/64/book-and-pencil.png";
            break;
        case "수리":
            imageSrc = "https://img.icons8.com/dusk/64/maintenance.png";
            break;
        case "오락":
            imageSrc = "https://img.icons8.com/dusk/64/controller.png";
            break;
        case "스포츠":
            imageSrc = "https://img.icons8.com/dusk/64/deadlift.png";
            break;
        case "식료품":
            imageSrc = "https://img.icons8.com/dusk/64/shopping.png";
            break;
        case "도서관":
            imageSrc = "https://img.icons8.com/dusk/64/book-shelf.png";
            break;
        case "사진":
            imageSrc = "https://img.icons8.com/dusk/64/camera--v1.png";
            break;
        case "의약":
            imageSrc = "https://img.icons8.com/dusk/64/pills.png";
            break;
        case "연료":
            imageSrc = "https://img.icons8.com/dusk/64/gas-station.png";
            break;
        case "병원":
            imageSrc = "https://img.icons8.com/dusk/64/hospital.png";
            break;
        case "수의":
            imageSrc = "https://img.icons8.com/color/48/dog.png";
            break;
        case "버스정류장":
            imageSrc = "https://img.icons8.com/dusk/64/bus--v1.png";
            break;
        default:
            imageSrc = "https://img.icons8.com/material-outlined/24/hamburger.png";
            break;
    }
    return {
        imageSrc: imageSrc,
        imageWidth: 30,
        imageHeight: 30,
        imageOption: {},
    };
};

const markers = ref([]);
const sorting = async function () {
    if (selectedSortType.value == "high-price") {
        sortedData.value.sort((a, b) => {
            const amountA = parseInt(a.recentAmount.replace(",", ""));
            const amountB = parseInt(b.recentAmount.replace(",", ""));
            return amountB - amountA;
        });
    } else if (selectedSortType.value == "low-price") {
        sortedData.value.sort((a, b) => {
            const amountA = parseInt(a.recentAmount.replace(",", ""));
            const amountB = parseInt(b.recentAmount.replace(",", ""));
            return amountA - amountB;
        });
    } else if (selectedSortType.value === "old-building") {
        sortedData.value.sort((a, b) => {
            return parseInt(a.aptInfo.buildYear) - parseInt(b.aptInfo.buildYear);
        });
    } else if (selectedSortType.value === "new-building") {
        sortedData.value.sort((a, b) => {
            return parseInt(b.aptInfo.buildYear) - parseInt(a.aptInfo.buildYear);
        });
    }
    pageInfo.value.totalItems = sortedData.value.length;
    await setList();
    if (viewList.value.length > 0) {
        console.log(viewList.value[0]);
        const firstItem = viewList.value[0].aptInfo;
        lat.value = firstItem.lat;
        lng.value = firstItem.lng;

        const newLatLng = new kakao.maps.LatLng(lat.value, lng.value);
        setCenter(lat.value, lng.value); // 첫 번째 아이템의 위치로 설정
    } else {
        sortedData.value = null;
    }
};

watch(selectedSortType, async () => {
    waitData.value = false;
    await sorting();
    waitData.value = true;
});

const onLoadKakaoMapMarker = (index) => (newMarker) => {
    markers.value[index] = newMarker;
};

const pageInfo = ref({
    currentPage: 1, //현재 페이지
    totalItems: "", //총 아이템 수 [ 글 수, 리뷰 수 등등]
    itemsPerPage: "4", // 몇개로 쪼갤 지
});
const pageChanged = async function (...args) {
    waitData.value = false;
    pageInfo.value.currentPage = args[0];
    await setList();
    waitData.value = true;
};

const viewList = ref();
const setList = () => {
    const start = (pageInfo.value.currentPage - 1) * pageInfo.value.itemsPerPage;
    const end = start * 1 + pageInfo.value.itemsPerPage * 1;
    viewList.value = sortedData.value.slice(start, end);
};
function panTo() {
    // 이동할 위도 경도 위치를 생성합니다
    var moveLatLon = new kakao.maps.LatLng(33.45058, 126.574942);

    // 지도 중심을 부드럽게 이동시킵니다
    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
}
onMounted(() => {
    sendRequest("sido", "");
    //   fetchAptList();
});
</script>
<template>
    <div>
        <div>
            <div class="search-bar d-flex px-3 py-3 justify-content-center">
                <div class="row">
                    <div class="col-1 form-group me-2 d-flex align-items-center">
                        <select
                            class="form-select d-inline-block"
                            id="sort"
                            v-model="selectedSortType"
                            @change="onSortType"
                        >
                            <option value="high-price">가격↑</option>
                            <option value="low-price">가격↓</option>
                            <option value="old-building">건축년도↑</option>

                            <option value="new-building">건축년도↓</option>
                        </select>
                    </div>
                </div>
                <div class="col-11 d-flex justify-content-center">
                    <div class="form-group me-2 d-flex align-items-center">
                        <select class="form-select d-inline-block" id="sido" @change="onSidoChange">
                            <option value="">시도선택</option>
                        </select>
                    </div>
                    <div class="form-group me-2 d-flex align-items-center">
                        <select class="form-select d-inline-block" id="gugun" @change="onGugunChange">
                            <option value="">구군선택</option>
                        </select>
                    </div>
                    <div class="form-group me-2 d-flex align-items-center">
                        <select class="form-select d-inline-block" id="dong" @change="onDongChange">
                            <option value="">동선택</option>
                        </select>
                    </div>
                    <div class="form-group me-2 d-flex align-items-center" @click="showModal">
                        <select class="form-select show-option-btn">
                            <option value="" disabled selected>추가필터</option>
                        </select>
                    </div>
                    <div class="form-group me-2 d-flex align-items-center">
                        <button
                            type="button"
                            id="list-btn"
                            class="btn btn-outline-transparent border-0 search-btn"
                            @click="navigateToAll"
                        >
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 24 24"
                                fill="currentColor"
                                class="w-6 h-6"
                            >
                                <path
                                    fill-rule="evenodd"
                                    d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z"
                                    clip-rule="evenodd"
                                />
                            </svg>
                        </button>
                    </div>
                    <div v-if="isModalVisible" class="modal-custom" ref="customModal">
                        <div class="modal-dialog">
                            <div class="modal-content d-flex">
                                <div class="modal-header">
                                    <div class="modal-title mb-1">선호하는 시설을 선택해보세요</div>
                                </div>
                                <div class="modal-body d-flex align-items-center">
                                    <div class="d-flex filter-select-box">
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="미용"
                                                id="미용"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="미용">미용</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="한식"
                                                id="한식"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="한식">한식</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="중식"
                                                id="중식"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="중식">중식</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="일식"
                                                id="일식"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="일식">일식</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="서양식"
                                                id="서양식"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="서양식">서양식</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="세탁"
                                                id="세탁"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="세탁">세탁</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="주점"
                                                id="주점"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="주점">주점</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="교육"
                                                id="교육"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="교육">교육</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="수리"
                                                id="수리"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="수리">수리</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="오락"
                                                id="오락"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="오락">오락</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="스포츠"
                                                id="스포츠"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="스포츠">스포츠</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="식료품"
                                                id="식료품"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="식료품">식료품</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="도서관"
                                                id="도서관"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="도서관">도서관</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="사진"
                                                id="사진"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="사진">사진</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="의약"
                                                id="의약"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="의약">의약</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="연료"
                                                id="연료"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="연료">연료</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="병원"
                                                id="병원"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="병원">병원</label>
                                        </div>

                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="수의"
                                                id="수의"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="수의">수의</label>
                                        </div>
                                        <div class="form-check select-item me-5">
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                value="버스 정류장"
                                                id="버스 정류장"
                                                v-model="checkedNames"
                                            />
                                            <label class="form-check-label" for="버스 정류장">버스 정류장</label>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <button class="option-btn px-3 py-1" @click="searchAttraction2">검색하기</button>
                                </div>
                                <div class="mt-3">
                                    <div class="modal-title mb-1">선호하는 시설을 검색해보세요</div>
                                    <div class="modal-body d-flex align-items-center">
                                        <input
                                            class="me-3 filter-search-text"
                                            type="text"
                                            placeholder="예시: 수영장, 마트, 영화관..."
                                        />
                                        <button class="px-3 py-1 option-btn">검색하기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div>
            <!-- isDetail을 값을 props로 가져가고 버튼을 누름에 따라 값을 다르게 함 -> 보이는 것도 달라짐 -->
            <div class="row gx-5">
                <div v-if="isDetail" class="col-lg-4 apt-detail">
                    <MapDetail :detail-props="detailProps" @go-back="goback" />
                </div>
                <div v-else class="col-lg-3 apt-list">
                    <div v-if="aptDataList">
                        <div v-if="waitData">
                            <AptListItem
                                @change-detail-prop="trclick"
                                v-for="(item, index) in viewList"
                                :key="item.index"
                                :apt-info="viewList[index].aptInfo"
                                :recent-amount="viewList[index].recentAmount"
                                :full-dongcode="fullDongcode"
                            />
                            <PagingBar
                                class="mt-4 mb-4"
                                :currentPage="pageInfo.currentPage"
                                :totalItems="pageInfo.totalItems"
                                :itemsPerPage="4"
                                @page-changed="pageChanged"
                            />
                        </div>
                    </div>
                    <h5 v-else class="d-flex justify-content-center align-items-center" style="height: 100%">
                        검색된 매물이 없습니다.
                    </h5>
                </div>
                <div class="col-lg-8 map-view">
                    <div class="check-list">
                        <button @click="openAndClose">
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                                class="size-6"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25ZM6.75 12h.008v.008H6.75V12Zm0 3h.008v.008H6.75V15Zm0 3h.008v.008H6.75V18Z"
                                />
                            </svg>
                        </button>
                        <CheckList :isOpen="isModalOpen"> </CheckList>
                    </div>
                    <div class="row gx-5 row-cols-1 row-cols-md-2">
                        <div id="map">
                            <KakaoMap
                                :width="1500"
                                :height="900"
                                :lat="lat"
                                :lng="lng"
                                @onLoadKakaoMap="onLoadKakaoMap"
                            >
                                <KakaoMapMarker
                                    v-for="(item, index) in list"
                                    :key="index"
                                    :lat="item.lat"
                                    :lng="item.lng"
                                >
                                    <template v-slot:infoWindow>
                                        <div class="d-flex justify-content" style="padding: 10px">
                                            {{ item.apartmentName }}
                                        </div>
                                    </template>
                                </KakaoMapMarker>

                                <KakaoMapMarker
                                    v-for="(item, index) in attractions"
                                    :key="index"
                                    :lat="item.lat"
                                    :lng="item.lng"
                                    :image="getImageForValue(item.bname)"
                                    @onLoadKakaoMapMarker="onLoadKakaoMapMarker"
                                />
                            </KakaoMap>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
select::-ms-expand {
    display: none;
}

.form-select {
    -o-appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    width: fit-content;
}

svg {
    width: 30px;
    height: 30px;
    color: #a3b1bb;
    /* color:white; */
}

.search-bar {
    position: relative;
    /* background-color:var(--blue-color) ; */
    border-top: 1px solid #ccc;
    border-bottom: 1px solid #ccc;
}

.modal-custom {
    padding: 10px 20px;
    position: absolute;
    top: calc(100%);
    /* 검색 바 바로 아래에 위치하도록 설정 */
    width: 40%;
    z-index: 1050;
    background-color: white;
    border: 1px solid #ccc;
}

.form-select.show-option-btn {
    pointer-events: none;
}

.form-select.show-option-btn option {
    pointer-events: auto;
}

.list {
    border-right: 1px solid #ccc;
}

#map {
    padding: 0px;
}

.apart-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.apt-detail {
    padding-right: 0px;
}

.option-btn {
    border: none;
    background-color: var(--blue-color);
}
.filter-select-box {
    flex-wrap: wrap !important;
}
.select-item {
    margin-bottom: 10px;
}
.filter-search-text {
    width: 30%;
}

.check-list {
    position: absolute;
    top: 3%;
    right: 0%;
    z-index: 1000;
}
.check-list > button {
    border: none;
    background-color: rgb(162, 194, 216);
    padding: 10px 10px;
    border-radius: 50%;
}
.check-list > button > svg {
    color: rgb(0, 0, 0);
}
.map-view {
    position: relative;
    /* width: 80%; */
}
</style>
