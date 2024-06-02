<!-- eslint-disable no-undef -->
<script setup>
import axios from "axios";
import { storeToRefs } from "pinia";
import { ref, onMounted, watch, nextTick } from "vue";
import { KakaoMap, KakaoMapMarker, KakaoMapInfoWindow } from "vue3-kakao-maps";
import { useRouter } from "vue-router";
import { useMapStore } from "@/stores/map";
import AptListItem from "@/components/map/AptListItem.vue";
import MapDetail from "@/components/map/MapDetail.vue";
import PagingBar from "../layout/PagingBar.vue";

import { useHighLightedStore } from "@/stores/highlighted.js";
const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList, addHighLightedHome, deleteHighLightedHome } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

import { useUserStore } from "@/stores/user.js";
const usertore = useUserStore();
const { userInfo, isLogin } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

// 데이터 정보를 받음
const aptDataList = ref(null);
const recentAmountList = ref([]);

const store = useMapStore();
const router = useRouter();

const lat = ref(33.450701);
const lng = ref(126.570667);
const map = ref();

// 정렬된 데이터
const sortedData = ref([]);

// 로딩판단
const waitData = ref(false);

// sort타입
const selectedSortType = ref("low-price");

// 마커 리스트
let list = ref([]);

// 상세페이지 보여주기 여부
const { isDetail } = storeToRefs(store);

// 디테일 페이지로 보낼 데이터
const detailProps = ref({});

// 지도 로드
const onLoadKakaoMap = (mapRef) => {
  // console.log("map load");
  map.value = mapRef;
};

// 지도 중심 잡기
const setCenter = (newLat, newLng) => {
  if (map.value) {
    lat.value = newLat;
    lng.value = newLng;
    const moveLatLng = new kakao.maps.LatLng(newLat, newLng);
    map.value.panTo(moveLatLng, { duration: 1000 }); // 애니메이션을 추가하여 부드럽게 이동
  }
};

const getAptInfo = async () => {
  // aptDataList를 빈 배열로 초기화
  // console.log("--------------------------------aptInfo-----------------");
  aptDataList.value = [];

  // highLightedList.value 배열을 순회
  for (const aptCode of highLightedList.value) {
    try {
      // console.log(aptCode);
      // 각 aptCode에 대한 URL 생성
      const url = "http://localhost:8080/home/wishList?aptCode=" + aptCode;

      // axios를 사용하여 요청 보내기
      const response = await axios.get(url);
      // console.log(response);

      // aptDataList.value에 응답 데이터 추가
      aptDataList.value = [...aptDataList.value, response.data.houseInfo];

      //-------여기까진 완벽해 ....
    } catch (error) {
      // 요청 실패 시 처리
      console.error("Error fetching data for aptCode:", item, error);
      initTable();
    }
  }

  // makeList 함수 호출
  await makeList(aptDataList.value);

  // 데이터가 있는 경우 첫번째 아파트 위치를 기준으로 지도를 보여줌
  if (sortedData.value.length > 0) {
    console.log(sortedData);
    const firstItem = sortedData.value[0].aptInfo;
    lat.value = firstItem.lat;
    lng.value = firstItem.lng;

    const newLatLng = new kakao.maps.LatLng(lat.value, lng.value);
    setCenter(lat.value, lng.value); // 첫 번째 아이템의 위치로 설정
  } else {
    sortedData.value = null;
  }
  waitData.value = true;
};

const makeList = async (data) => {
  recentAmountList.value = [];

  for (const apt of data) {
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
    } catch (e) {
      console.log("최근 거래가 가져오기 실패");
    }
    const markerItem = {
      lat: apt.lat,
      lng: apt.lng,
    };
    list.value.push(markerItem);
  }
  sortedData.value = recentAmountList.value;
  await sorting();
};

const initTable = () => {
  const tbody = document.querySelector("#apt-list");
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
    map.value.panTo(newLatLng, { duration: 500 }); // 부드러운 이동을 위해 panTo 사용
    isDetail.value = true;

    const aptInfo = aptDataList.value.find((apt) => apt.aptCode === aptCode);

    detailProps.value = {
      aptCode: aptCode,
      aptInfo: aptInfo,
      roadName: roadName,
    };
    // redirectToDetailPage 함수 호출 시 aptCode를 함께 전달합니다.
    // redirectToDetailPage(aptCode);
  }
}

const navigateToAll = () => {
  waitData.value = false;
  // fetchAptList();
  // router.push({ name: "all", params: { fullDongcode: fullDongcode.value } });
};

watch([() => store.lat, () => store.lng], ([newLat, newLng]) => {
  setCenter(newLat, newLng);
});

const { VITE_OPEN_API_SERVICE_KEY, VITE_SEARCH_TRIP_URL } = import.meta.env;
const { VITE_CON_OPEN_API_SERVICE_KEY, VITE_CON_URL } = import.meta.env;

const markers = ref([]);

const onLoadKakaoMapMarker = (index) => (newMarker) => {
  markers.value[index] = newMarker;
};

const updateData = async function () {
  // DOM 업데이트가 완료될 때까지 대기
  await nextTick();

  // 현재 데이터를 초기화
  aptDataList.value = [];
  recentAmountList.value = [];
  list.value = [];

  // 아파트 정보를 다시 가져오기
  await getAptInfo();
};

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
};

watch(selectedSortType, async () => {
  waitData.value = false;
  await sorting();
  waitData.value = true;
});

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

onMounted(() => {
  waitData.value = false;
  getAptInfo();
});
</script>
<template>
  <div class="d-flex">
    <!-- isDetail을 값을 props로 가져가고 버튼을 누름에 따라 값을 다르게 함 -> 보이는 것도 달라짐 -->
    <div class="row gx-5 wish-list">
      <div v-if="isDetail" class="col-lg-4 apt-detail">
        <div class="px-3 py-3 high-list-header">찜 리스트</div>
        <MapDetail :detail-props="detailProps" @go-back="goback" />
      </div>
      <div v-else class="col-lg-4">
        <div class="px-3 py-3 high-list-header d-flex justify-content-between align-items-center">
          <div class="">찜 리스트</div>
          <div class="form-group me-2 d-flex align-items-center">
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
        <div v-if="viewList" id="apt-list">
          <div v-if="waitData">
            <AptListItem
              @change-detail-prop="trclick"
              @update-apt-info="updateData"
              v-for="item in viewList"
              :key="item.aptInfo.aptCode"
              :apt-info="item.aptInfo"
              :recent-amount="item.recentAmount"
            />
            <PagingBar
              class="my-4"
              :currentPage="pageInfo.currentPage"
              :totalItems="pageInfo.totalItems"
              :itemsPerPage="4"
              @page-changed="pageChanged"
            />
          </div>
        </div>
        <h5 v-else class="d-flex justify-content-center align-items-center" style="height: 100%">
          찜한 매물이 없습니다.
        </h5>
      </div>
      <div class="col-lg-8">
        <div class="row gx-5 row-cols-1 row-cols-md-2">
          <div id="map">
            <KakaoMap
              :width="1700"
              :height="950"
              :lat="lat"
              :lng="lng"
              @onLoadKakaoMap="onLoadKakaoMap"
            >
              <KakaoMapMarker
                v-for="(item, index) in list"
                :key="index"
                :lat="item.lat"
                :lng="item.lng"
              />
              <!-- <KakaoMapMarker v-for="(item, index) in attractions" :key="index" :lat="item.mapy"
                        :lng="item.mapx" :image="getImageForValue(item.contenttypeid)"
                        @onLoadKakaoMapMarker="onLoadKakaoMapMarker" /> -->
              <!-- <KakaoMapInfoWindow v-for="(item, index) in attractions" :key="'info-' + index"
                            :marker="markers[index]" :lat="item.mapy" :lng="item.mapx" :visible="false">
                        </KakaoMapInfoWindow> -->
            </KakaoMap>
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
  width: 90%;
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
.high-list-header {
  color: #686868;
  font-weight: 500;
  font-size: 20px;
  border: 1px solid #ccc;
  border-left: none;
  border-right: none;
  box-sizing: border-box;
}
</style>
