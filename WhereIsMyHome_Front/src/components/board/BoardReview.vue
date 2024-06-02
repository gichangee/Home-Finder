<script setup>
import { useRoute, useRouter } from "vue-router";
import axios from "axios";
import { ref } from "vue";
import { onMounted, watch } from "vue";
import { useUserStore } from "@/stores/user.js";
import { storeToRefs } from "pinia";
import PagingBar from "../layout/PagingBar.vue";

const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);
const route = useRoute();
const router = useRouter();

const boardList = ref([]);
const word = ref("");

const pageInfo = ref({
  currentPage: 1, //현재 페이지
  totalItems: "", //총 아이템 수 [ 글 수, 리뷰 수 등등]
  itemsPerPage: "10", // 몇개로 쪼갤 지
  selected: "검색조건",
});

const getBoardList = async function () {
  await axios
    .get(
      "http://localhost:8080/board/review" +
        "?page=" +
        1 +
        "&size=10" +
        "&select=" +
        pageInfo.value.selected +
        "&word=" +
        word.value
    )
    .then(({ data }) => {
      boardList.value = data;
    });
};

//글 갯수가져오기

const getBoardListSize = async function () {
  await axios
    .get(
      "http://localhost:8080/board/review/size?select=" +
        pageInfo.value.selected +
        "&word=" +
        word.value
    )
    .then(({ data }) => {
      pageInfo.value.totalItems = data;
    });
};

const pageChanged = async function (...args) {
  //데이터 새로 가져오기
  await axios
    .get(
      "http://localhost:8080/board/review?page=" +
        args[0] +
        "&size=10&select=" +
        pageInfo.value.selected +
        "&word=" +
        word.value
    )
    .then(({ data }) => {
      boardList.value = data;
    });
};

const redirectToArticleView = (review_no) => {
  router.push({ name: "review-view", params: { review_no: review_no } });
};

const getSearchArticle = async () => {
  await getBoardListSize();
  await getBoardList();
  pageInfo.value.currentPage = 1;
  console.log(pageInfo.value.currentPage);
};

//url을 감시해서 변경시 데이터 다시 가져오기
watch(
  route,
  (newRoute, oldRoute) => {
    getBoardListSize();
    getBoardList();
  },
  { immediate: true }
);

onMounted(() => {
  getBoardListSize();
  getBoardList();
});
</script>

<template>
  <div class="container board-list mt-3">
    <div>
      <!-- <div>{{ article_type }}</div> -->
      <!-- <img src="../../assets/img/boardBackImage2.png" /> -->
    </div>
    <div class="row mb-2" v-if="isLogin">
      <div>
        <button class="write-btn">
          <RouterLink
            :to="{
              name: 'review-write',
            }"
            >글쓰기</RouterLink
          >
        </button>
      </div>
    </div>
    <div class="row" @call-get-board-list="getBoardList">
      <div>
        <table class="table">
          <thead class="table-top">
            <tr>
              <th class="text-center" scope="col">아파트이름</th>
              <th class="text-center" scope="col">제목</th>
              <th class="text-center" scope="col">글쓴이</th>
              <th class="text-center" scope="col">조회수</th>
              <th class="text-center" scope="col">별점</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="board in boardList"
              :key="board.review_no"
              @click="redirectToArticleView(board.review_no)"
            >
              <th class="text-center" scope="row">{{ board.apartmentName }}</th>
              <td class="text-center">
                {{ board.subject }}
              </td>
              <td class="text-center" v-if="board.user_id !== null">{{ board.user_id }}</td>
              <td class="text-center" v-else>(탈퇴한 회원)</td>
              <td class="text-center">{{ board.hit }}</td>
              <td class="text-center">
                <span class="star" v-for="i in parseInt(board.star)" :key="i">★</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div class="row pb-3">
      <PagingBar
        :currentPage="pageInfo.currentPage"
        :totalItems="pageInfo.totalItems"
        :itemsPerPage="pageInfo.itemsPerPage"
        @page-changed="pageChanged"
      />
    </div>
    <div class="row mt-auto">
      <div class="col-sm-12 d-flex justify-content-center">
        <form class="d-flex col-md-6 col-lg-6 col-sm-12" id="form-search" action="">
          <select
            name="key"
            id="key"
            class="form-select form-select-sm me-1 w-50"
            aria-label="검색조건"
            v-model="pageInfo.selected"
          >
            <option selected>검색조건</option>
            <option value="apartmentName">아파트이름</option>
            <option value="subject">제목</option>
            <option value="user_id">작성자</option>
          </select>
          <div class="input-group input-group-sm">
            <input
              type="text"
              name="word"
              id="word"
              v-model="word"
              class="form-control"
              placeholder="검색어..."
            />
            <button @click="getSearchArticle" class="btn" type="button">검색</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.board-list {
}
.board-list > .row:nth-child(2) > div {
  display: flex;
  width: 100%;
  justify-content: flex-end;
  margin: 10px 0px;
}
.board-list > .row:nth-child(2) > div > button {
  background-color: white;
  border: none;
  border-bottom: 3px solid var(--blue-color);
  padding-bottom: 5px;
  /* border-radius: 50px; */
  /* border: none; */
}
.board-list > .row:nth-child(2) > div > button > a {
  text-decoration: none;
  color: var(--gray-color);
}
.btn {
  background-color: var(--blue-color);
}
.table-top {
  border-bottom: 2px solid #ccc;
  border-top: 2px solid #ccc;
}
.star {
  color: rgb(103, 160, 214);
}
</style>
