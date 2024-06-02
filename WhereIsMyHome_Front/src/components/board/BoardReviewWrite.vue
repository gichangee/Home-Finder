<script setup>
import router from "@/router";
import { storeToRefs } from "pinia";
import axios from "axios";
import { ref, onMounted } from "vue";
import Quill from "quill"; // Quill을 직접 import 합니다.
import "quill/dist/quill.snow.css"; // Quill의 CSS를 import 합니다.
import { useUserStore } from "@/stores/user.js";
import { useRoute } from "vue-router";
import Swal from "sweetalert2";

const route = useRoute();
const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);

const board = ref({
  user_id: "",
  subject: "",
  content: "",
  apartmentName: "",
  aptCode: "",
  star: 0,
});

const apartmentName = route.params.apartmentName;
const aptCode = route.params.aptCode;
if (apartmentName !== undefined && aptCode !== undefined) {
  board.value.apartmentName = apartmentName;
  board.value.aptCode = aptCode;
}

const selectedSido = ref("");
const selectedGugun = ref("");
const selectedDong = ref("");
const selectedApt = ref("");

const fullDongcode = ref("");

board.value.user_id = userInfo.value.user_id;

let quill;

const createList = () => {
  const editorContent = quill.root.innerHTML; // Quill 에디터에서 HTML 형식의 내용을 가져옵니다.
  board.value.content = editorContent; // board 객체에 감싼 내용을 넣어줍니다.

  const URL = "http://localhost:8080/board/review";
  console.log(board.value);
  axios
    .post(URL, board.value)
    .then(({ data }) => {
      router.push({ name: "review-board" });
    })
    .catch(({ data }) => {
      console.log("에러발생");
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
      board.value.star = "";
    }
  });
};

onMounted(() => {
  quill = new Quill("#editor", {
    theme: "snow",
  });

  // Quill의 'text-change' 이벤트를 감시하여 board.content 업데이트
  quill.on("text-change", () => {
    board.value.content = quill.getText();
  });

  sendRequest("sido", "");
});

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
      console.log(fullDongcode.value);

      sendRequest("apt", "?dongCode=" + fullDongcode.value);
    })
    .catch((error) => console.error("Error fetching data:", error));
};

const onAptChange = (event) => {
  if (event.target.value) {
    board.value.apartmentName = event.target.value.slice(0, -1);

    const url =
      "http://localhost:8080/home/aptCode?dongCode=" +
      fullDongcode.value +
      "&apartmentName=" +
      board.value.apartmentName;

    axios
      .get(url)
      .then((response) => {
        console.log(response);
        board.value.aptCode = response.data;
      })
      .catch((error) => console.error("Error fetching data:", error));
  } else {
    initOption("apt");
  }
};

const sendRequest = (selid, command) => {
  const url = "http://localhost:8080/home/address/" + selid + command;

  axios
    .get(url)
    .then((response) => addOption(selid, response.data))
    .catch((error) => console.error("Error fetching data:", error));
};

const initOption = (selid) => {
  let options = document.querySelector("#" + selid);
  options.innerHTML = "";
};

const addOption = (selid, data) => {
  let opt = ``;
  initOption(selid);
  console.log(data);
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
    case "apt":
      opt += '<option value="">아파트선택</option>';
      data.aptList.forEach((apt) => {
        opt += `<option value="${apt}}">${apt}</option>`;
      });
      break;
  }
  document.querySelector("#" + selid).innerHTML = opt;
};

//아파트이름을 사용해서 아파트 코드 뽑기
</script>

<template>
  <div class="search-bar d-flex px-5 pt-5 justify-content-center">
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
    <div class="form-group me-2 d-flex align-items-center">
      <select class="form-select d-inline-block" id="apt" @change="onAptChange">
        <option value="">아파트선택</option>
      </select>
    </div>
  </div>
  <div class="container mt-2 pb-5">
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
        <button class="me-3" type="button" id="resetForm" @click="resetContent">비우기</button>
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
.subject {
  margin-left: 7px;
  width: 96%;
}
button {
  background-color: var(--blue-color);
  border: none;
  padding: 5px 10px;
}
#aptName {
  width: 90%;
}
.star {
  color: rgb(103, 160, 214);
}
</style>
