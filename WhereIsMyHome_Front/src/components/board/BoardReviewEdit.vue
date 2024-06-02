<script setup>
import axios from "axios";
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { defineEmits } from "vue";
import Quill from "quill"; // Quill을 직접 import 합니다.
import "quill/dist/quill.snow.css"; // Quill의 CSS를 import 합니다.

const route = useRoute();
const router = useRouter();

const review_no = route.params.review_no;
const board = ref({
    content: "",
    review_no: "",
    subject: "",
});
let quill;

const getBoardDetail = async function () {
    try {
        const { data } = await axios.get("http://localhost:8080/board/reviewEdit/" + review_no);
        board.value = data;
        quill.root.innerHTML = board.value.content; // 데이터를 Quill 에디터에 추가합니다.
    } catch (error) {
        console.error("데이터를 가져오는 중 에러 발생:", error);
    }
};

const updateBoard = function () {
    axios
        .put("http://localhost:8080/board/reviewupdate", board.value)
        .then(() => {
            router.push({ name: "review-view", params: { review_no: board.value.review_no } });
        })
        .catch((error) => {
            alert("업데이트 중 에러 발생");
            console.log(error);
        });
};

onMounted(() => {
    quill = new Quill("#editor", {
        theme: "snow",
    });

    // Quill의 'text-change' 이벤트를 감시하여 board.content 업데이트
    quill.on("text-change", () => {
        board.value.content = quill.root.innerHTML; // Quill 에디터의 내용을 board.content에 업데이트합니다.
    });

    getBoardDetail(); // 데이터를 불러옵니다.
});
</script>

<template>
    <div class="container mt-5 mb-3">
        <div class="row mb-3">
            <div class="d-flex">
                <div class="col-10">
                    <label for="aptName">아파트이름</label>
                    <input id="aptName" type="text" v-model="board.apartmentName" readonly disabled />
                </div>
                <div class="col-2">
                    <label for="rating">별점</label>
                    <select class="star" id="rating" v-model="board.star">
                        <option class="star" value="1">★</option>
                        <option class="star" value="2">★★</option>
                        <option class="star" value="3">★★★</option>
                        <option class="star" value="4">★★★★</option>
                        <option class="star" value="5">★★★★★</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-group">
                <label for="subject">제목</label>
                <input class="subject" id="subject" type="text" v-model="board.subject" />
            </div>
        </div>
        <div class="row">
            <div class="form-group">
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
.subject {
    margin-left: 7px;
    width: 96%;
}
#aptName {
    width: 90%;
}
.star {
    color: rgb(103, 160, 214);
}
</style>
