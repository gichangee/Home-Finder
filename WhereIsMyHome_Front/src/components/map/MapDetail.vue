<script setup>
import axios from "axios";
import { defineEmits } from "vue";
import { useRouter } from "vue-router";
import { defineProps, onMounted, ref, watch } from "vue";
import { onBeforeRouteLeave } from "vue-router";
import GraphComponent from "./GraphComponent.vue";
const emit = defineEmits(["goBack"]);
const props = defineProps({
  detailProps: Object,
  aptInfo: Object,
});
const router = useRouter();
const pageInfo = ref({
  currentPage: "1", //현재 페이지
  totalItems: "", //총 아이템 수 [ 글 수, 리뷰 수 등등]
  itemsPerPage: "10", // 몇개로 쪼갤 지
});

import { storeToRefs } from "pinia";

import { useHighLightedStore } from "@/stores/highlighted.js";
const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList, addHighLightedHome, deleteHighLightedHome } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

import { useMapStore } from "@/stores/map";
const store = useMapStore();
const { isDetail } = storeToRefs(store);

import { useUserStore } from "@/stores/user.js";
const usertore = useUserStore();
const { userInfo, isLogin } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

const active = ref(false);

const addHighLight = async function (aptCdoe) {
  if (active.value) {
    //삭제요청하기
    await deleteHighLightedHome(userInfo.value.user_id, aptCdoe).then(() => {
      //highLightedList값 바꾸기
      highLightedList.value = highLightedList.value.filter((item) => item.aptCode !== aptCdoe);
      active.value = false;
    });
  } else {
    //등록요청하기
    await addHighLightedHome(userInfo.value.user_id, aptCdoe).then(() => {
      //highLightedList값 바꾸기
      getHighLightedHomeList(userInfo.value.user_id);
      active.value = true;
    });
  }
};

import apartmentImage from "@/assets/img/apartment.jpeg";
import PagingBar from "../layout/PagingBar.vue";

//해당 아파트 거래 내역
const totalDataList = ref([]);
const graphDataList = ref([]);
const list = ref([]);
const reviewlist = ref([]);

const goBack = () => {
  emit("goBack");
};

const updateInfo = async () => {
  console.log(props.detailProps.aptCode);
  const url = "http://localhost:8080/home/info?aptCode=" + props.detailProps.aptCode;
  await axios
    .get(url)
    .then((response) => {
      // 데이터를 받아온 후 거래 날짜를 기준으로 내림차순 정렬
      totalDataList.value = response.data.sort((a, b) => {
        const dateA = new Date(a.dealYear, a.dealMonth - 1, a.dealDay);
        const dateB = new Date(b.dealYear, b.dealMonth - 1, b.dealDay);
        return dateB - dateA;
      });
      graphDataList.value = response.data.filter((item) => item.dealYear >= 2021);
    })
    .catch((error) => console.error("Error fetching data:", error));
};
const setList = () => {
  const start = (pageInfo.value.currentPage - 1) * pageInfo.value.itemsPerPage;
  const end = start * 1 + pageInfo.value.itemsPerPage * 1;
  console.log(start + " " + end);
  list.value = totalDataList.value.slice(start, end);
};
const pageChanged = async function (...args) {
  pageInfo.value.currentPage = args[0];
  console.log(pageInfo.value.currentPage);
  setList();
};

const handleRowClick = (item) => {
  router.push({ name: "review-view", params: { review_no: item.review_no } });
};

const updatereview = async () => {
  const url = "http://localhost:8080/board/reviewdetail?aptCode=" + props.detailProps.aptCode;
  const { data } = await axios.get(url);

  const attractionsData = data.map((item) => ({
    ...item,
  }));
  reviewlist.value.push(...attractionsData);
};

onMounted(async () => {
  updatereview();
  updateInfo().then(() => {
    pageInfo.value.totalItems = totalDataList.value.length;
    setList();
  });
  await getHighLightedHomeList(userInfo.value.user_id);
  if (highLightedList.value.includes(props.detailProps.aptCode)) {
    console.log("디테일 - 찜하기 판단 성공");
    active.value = true;
  }
});
onBeforeRouteLeave((to, from) => {
  isDetail.value = false;
});
</script>

<template>
  <div class="">
    <div class="map-detail-header py-2 px-3">
      <button @click="goBack">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-6 h-6"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"
          />
        </svg>
      </button>
    </div>
    <div class="map-detail-body px-4 py-2">
      <div class="d-flex mb-3">
        <div class="left-box col-5">
          <img :src="apartmentImage" />
        </div>
        <div class="right-box col-7 px-2 d-flex flex-column">
          <div>
            <div class="apt-name">{{ props.detailProps.aptInfo.apartmentName }}</div>
            <div class="apt-address">주소지 :{{ props.detailProps.aptInfo.roadName }}</div>
            <div class="apt-build">건축년도 : {{ props.detailProps.aptInfo.buildYear }}</div>
          </div>

          <div class="like-btn-box" v-if="isLogin">
            <button
              @click="addHighLight(props.detailProps.aptCode)"
              class="like-btn d-flex justify-content-center align-items-center"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="currentColor"
                class="w-6 h-6 like-btn-svg"
                :class="{ red: active }"
              >
                <path
                  d="m11.645 20.91-.007-.003-.022-.012a15.247 15.247 0 0 1-.383-.218 25.18 25.18 0 0 1-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0 1 12 5.052 5.5 5.5 0 0 1 16.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 0 1-4.244 3.17 15.247 15.247 0 0 1-.383.219l-.022.012-.007.004-.003.001a.752.752 0 0 1-.704 0l-.003-.001Z"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <div class="mb-3">
        <div class="d-flex justify-content-between">
          <div class="row-header">아파트 리뷰</div>
          <div class="d-flex">
            <div v-if="isLogin" class="me-3 more-review-link">
              <router-link
                :to="{
                  name: 'review-write-params',
                  params: {
                    apartmentName: props.detailProps.aptInfo.apartmentName,
                    aptCode: props.detailProps.aptCode,
                  },
                }"
                class="me-auto"
              >
                리뷰쓰기
              </router-link>
            </div>
            <div>더보기</div>
          </div>
        </div>
        <table v-if="reviewlist.length" class="table">
          <thead>
            <tr>
              <th>제목</th>
              <th>평점</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in reviewlist" :key="item.review_no" @click="handleRowClick(item)">
              <td>{{ item.subject }}</td>
              <td>
                <span class="star" v-for="i in item.star" :key="i">★</span>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="">
          <p class="d-flex justify-content-center align-items-center" style="height: 100px">
            리뷰가 없습니다.
          </p>
        </div>
      </div>

      <div class="mb-5">
        <div class="row-header">거래내역</div>
        <table class="table">
          <thead>
            <tr>
              <th>거래날짜</th>
              <th>거래금액</th>
              <th>평수</th>
              <th>층</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in list" :key="item.id">
              <td>{{ item.dealYear }} / {{ item.dealMonth }} / {{ item.dealDay }}</td>
              <td>{{ item.dealAmount }}</td>
              <td>{{ item.area }} m^2</td>
              <td>{{ item.floor }}</td>
            </tr>
          </tbody>
        </table>
        <PagingBar
          class="many-paging"
          :currentPage="1"
          :totalItems="pageInfo.totalItems"
          :itemsPerPage="10"
          @page-changed="pageChanged"
        />
      </div>
      <div class="mb-5">
        <div class="row-header">거래 추이 그래프</div>
        <GraphComponent :list="graphDataList" />
      </div>
    </div>
  </div>
</template>

<style scoped>
svg {
  width: 25px;
  height: 25px;
  color: #818181;
}

button {
  border: none;
  background-color: white;
}

.map-detail-header {
  border-bottom: 1px solid #ccc;
}

img {
  width: 100%;
  height: 100%;
}

.apt-name {
  font-size: 20px;
  font-weight: 800;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
}

th {
  background-color: #f2f2f2;
}

.like-btn {
  background-color: var(--blue-color);
  border: none;
  color: white;
  border-radius: 10px;
  /* width: 40px;
    height: 40px; */
  padding: 10px 30px;
}

.like-btn-box {
  display: flex;
  flex: 1;
  justify-content: flex-end;
  align-items: flex-end;
}

.like-btn-svg {
  color: white;
}

.red {
  color: rgb(41, 64, 100);
}

.write-post {
  padding: 5px 10px;
  font-size: 14px;
  cursor: pointer;
}

.many-paging {
  flex-wrap: wrap;
}

.map-detail-body {
  height: 840px;
  overflow-y: scroll;
  overflow-x: hidden;
}
.more-review-link a {
  color: black;
  text-decoration: none;
}
.row-header {
  font-weight: 900;
  font-size: 20px;
}
.star {
  color: rgb(103, 160, 214);
}
</style>
