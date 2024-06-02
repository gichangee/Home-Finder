<script setup>
import axios from "axios";
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { defineEmits } from "vue";
import Quill from "quill";
import "quill/dist/quill.snow.css";

const route = useRoute();
const router = useRouter();
const emit = defineEmits(["callGetBoardList"]);

const articleno = route.params.articleno;
const board = ref({});
let quill;

const getBoardDetail = async () => {
  try {
    const { data } = await axios.get(`http://localhost:8080/board/edit/${articleno}`);
    board.value = data;
    // Quill 에디터를 초기화할 때 데이터베이스에서 가져온 내용을 HTML 형식으로 설정합니다.
    quill.root.innerHTML = data.content;
  } catch (error) {
    console.error("데이터를 가져오는 중 에러 발생:", error);
  }
};

const updateBoard = async () => {
  // Quill 에디터의 내용을 HTML 형식으로 가져옵니다.
  board.value.content = quill.root.innerHTML;
  try {
    await axios.put("http://localhost:8080/board", board.value);
    emit("callGetBoardList");
    router.push({ name: "article-view", params: { article_no: board.value.article_no } });
  } catch (error) {
    alert("업데이트 중 에러 발생");
    console.error(error);
  }
};

onMounted(() => {
  quill = new Quill("#editor", {
    theme: "snow",
  });
  getBoardDetail();
});
</script>

<template>
  <div class="container mt-5">
    <div class="row">
      <div class="form-group">
        <label for="subject">제목</label>
        <input id="subject" type="text" v-model="board.subject" />
      </div>
    </div>
    <div class="row">
      <div class="form-group">
        <label for="editor">내용</label>
        <div id="editor"></div>
      </div>
    </div>
    <div class="row">
      <div class="d-flex justify-content-end">
        <button @click="updateBoard">수정</button>
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
