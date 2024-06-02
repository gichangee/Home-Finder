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
const key = ref();

const pageInfo = ref({
  currentPage: 1, //현재 페이지
  totalItems: "", //총 아이템 수 [ 글 수, 리뷰 수 등등]
  itemsPerPage: 10, // 몇개로 쪼갤 지
  selected: "검색조건",
});

const setKey = function () {
  let article_type = route.fullPath.split("/");
  article_type = article_type[article_type.length - 1];
  if (article_type == "free") {
    key.value = 0;
  } else if (article_type == "qna") {
    key.value = 1;
  }
};

//null일때는 전체검색
//아닐때는
const getBoardList = async function () {
  await axios
    .get(
      "http://localhost:8080/board?key=" +
        key.value +
        "&page=" +
        1 +
        "&size=10" +
        "&select=" +
        pageInfo.value.selected +
        "&word=" +
        word.value
    )
    .then(({ data }) => {
      boardList.value = data;
      console.log(boardList.value);
    });
};

//글 갯수가져오기
const getBoardListSize = async function () {
  await axios
    .get(
      "http://localhost:8080/board/size?key=" +
        key.value +
        "&select=" +
        pageInfo.value.selected +
        "&word=" +
        word.value
    )
    .then(({ data }) => {
      pageInfo.value.totalItems = data;
    });
};

const redirectToArticleView = (articleNo) => {
  router.push({ name: "article-view", params: { article_no: articleNo } });
};

const pageChanged = async function (...args) {
  //데이터 새로 가져오기
  await axios
    .get(
      "http://localhost:8080/board?key=" +
        key.value +
        "&page=" +
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
    setKey();
    getBoardListSize();
    getBoardList();
  },
  { immediate: true }
);

onMounted(() => {
  setKey();
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
              name: 'article-write',
              params: {
                article_type: key,
              },
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
              <th class="text-center" scope="col">제목</th>
              <th class="text-center" scope="col">글쓴이</th>
              <th class="text-center" scope="col">조회수</th>
              <th class="text-center" scope="col">게시일</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="board in boardList"
              :key="board.article_no"
              @click="redirectToArticleView(board.article_no)"
            >
              <td class="text-center">
                {{ board.subject }}
              </td>
              <td class="text-center" v-if="board.user_id !== null">{{ board.user_id }}</td>
              <td class="text-center" v-else>(탈퇴한 회원)</td>
              <td class="text-center">{{ board.hit }}</td>
              <td class="text-center">{{ board.register_time }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div class="row pb-3">
      <PagingBar
        class="paging-bar"
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
</style>
