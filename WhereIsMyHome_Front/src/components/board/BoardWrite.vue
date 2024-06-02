<script setup>
import axios from "axios";
import { storeToRefs } from "pinia";
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useUserStore } from "@/stores/user.js";
import Quill from "quill";
import "quill/dist/quill.snow.css";
import Swal from "sweetalert2";

const route = useRoute();
const router = useRouter();
const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);

const articleno = route.params.article_no;
const board = ref({
  subject: "",
  content: "",
  user_id: userInfo.value.user_id,
  article_type: route.params.article_type,
});

let quill;

const createList = () => {
  const editorContent = quill.root.innerHTML; // Quill 에디터에서 HTML 형식의 내용을 가져옵니다.
  board.value.content = editorContent; // board 객체에 감싼 내용을 넣어줍니다.

  const URL = "http://localhost:8080/board";
  axios
    .post(URL, board.value)
    .then(() => {
      if (board.value.article_type == 0) {
        router.push({ name: "free-board" });
      } else if (board.value.article_type == 1) {
        router.push({ name: "qna-board" });
      }
    })
    .catch((error) => {
      console.error("에러발생:", error);
    });
};

const resetContent = () => {
  Swal.fire({
    title: "작성한 내용을 지우겠습니까?",
    text: "OK를 누르면 내용이 지워집니다.",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "OK",
  }).then((result) => {
    if (result.isConfirmed) {
      board.value.subject = "";
      quill.root.innerHTML = "";
    }
  });
};

onMounted(() => {
  quill = new Quill("#editor", {
    theme: "snow",
  });
});
</script>

<template>
  <div class="container mt-5 mb-5">
    <div class="row">
      <div class="form-group mb-4">
        <label class="block" for="subject">제목</label>
        <input id="subject" type="text" v-model="board.subject" />
      </div>
    </div>
    <div class="row">
      <div class="form-group">
        <!-- <label for="editor">내용</label> -->
        <div id="editor"></div>
      </div>
    </div>
    <div class="row">
      <div class="d-flex justify-content-end">
        <button class="me-3" type="button" @click="resetContent">비우기</button>
        <button type="submit" @click="createList">등록</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.form-group {
  margin-bottom: 14px;
}

label {
  margin-right: 10px;
}

input {
  border: 1px solid #ccc;
}

input,
.ql-editor {
  padding: 4px;
  font-size: 14px;
}

.row:nth-child(1) > .form-group {
  display: flex;
  margin-bottom: 0px;
}

.row:nth-child(1) > .form-group > input {
  flex: 1;
}

#editor {
  height: 500px;
}

button {
  background-color: var(--blue-color);
  border: none;
  padding: 5px 10px;
}
</style>
