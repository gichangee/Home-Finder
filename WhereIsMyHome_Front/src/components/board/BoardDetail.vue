<script setup>
import axios from "axios";
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useUserStore } from "@/stores/user.js";
import { storeToRefs } from "pinia";

const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);

const route = useRoute();
const router = useRouter();

const articleno = route.params.article_no;
const board = ref({});

const getBoardDetail = async function () {
  try {
    const { data } = await axios.get("http://localhost:8080/board/" + articleno);
    // 데이터를 받아올 때 <p></p> 태그를 줄바꿈으로 변경합니다.
    board.value = data;
    console.log(board.value.content);
  } catch (error) {
    console.error("데이터를 가져오는 중 에러 발생:", error);
  }
};

const goToEdit = function () {
  router.push({ name: "article-modify", params: { articleno: articleno } });
};

const goToDelete = function () {
  if (board.value.article_type == 0) {
    axios.delete("http://localhost:8080/board/" + articleno).then(() => {
      router.push({ name: "free-board" });
    });
  } else if (board.value.article_type == 1) {
    axios.delete("http://localhost:8080/board/" + articleno).then(() => {
      router.push({ name: "qna-board" });
    });
  }
};

onMounted(() => {
  getBoardDetail();
});
</script>

<template>
  <div class="container mt-5">
    <div class="row">
      <div class="detail-header d-flex justify-content-between mb-3 pb-3 pt-3">
        <div class="row">
          <div>{{ board.subject }}</div>
        </div>
        <div class="row">
          <div class="d-flex">
            <div v-if="board.user_id !== null">작성자 : {{ board.user_id }}</div>
            <div v-else>작성자 : (탈퇴한 회원)</div>
            <div class="me-3 ms-3">|</div>
            <div>작성일 : {{ board.register_time }}</div>
          </div>
        </div>
      </div>
      <!-- <hr /> -->
      <div class="detail-content p-5">
        <!-- v-html 디렉티브를 사용하여 HTML을 렌더링합니다. -->
        <div v-html="board.content"></div>
      </div>
      <div class="detail-btn mt-3 d-flex justify-content-end">
        <button
          class="me-3"
          v-if="
            (userInfo && board.user_id === userInfo.user_id) ||
            (userInfo && userInfo.permission_level == 0)
          "
          @click="goToDelete"
        >
          삭제
        </button>
        <button
          v-if="userInfo && board.user_id === userInfo.user_id"
          type="button"
          @click="goToEdit"
        >
          수정
        </button>
      </div>
    </div>
    <div class="row comment mt-5 mb-5">
      <div class="comment-container">
        <div class="comment-header mb-4">
          <div class="comment-title pb-2 mb-3">comments</div>
          <div class="comment-input-box d-flex">
            <input type="text" class="flex-grow-1 me-2" />
            <button class="comment-add-btn">+</button>
          </div>
        </div>
        <div class="comment-list">
          <div class="comment-cnt mb-2">1개의 댓글</div>
          <div class="comment-item">
            <div>ssafy</div>
            <div>유익한 정보 얻어갑니다.</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.detail-header {
  border-top: 3px solid #8d8d8d;
  border-bottom: 1px solid #ccc;
}
.comment-title {
  border-bottom: 1px solid #ccc;
}
.detail-content {
  width: 100%;
  height: 50%;
  border: 1px solid #ccc;
}
.detail-btn > button {
  border: none;
  background-color: var(--blue-color);
  padding: 5px 10px;
}
.comment-input-box > input {
  border: 1px solid #ccc;
  border-radius: 10px;
}
.comment-add-btn {
  background-color: var(--blue-color);
  border: none;
  color: white;
  height: 40px;
  width: 40px;
  text-align: center;
  font-weight: 900;
  border-radius: 10px;
}
.comment-cnt {
  font-weight: 800;
}
</style>
