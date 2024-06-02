<script setup>
import { ref } from "vue";
import { storeToRefs } from "pinia";
import { useRouter } from "vue-router";
import { useUserStore } from "@/stores/user.js";
import { useHighLightedStore } from "@/stores/highlighted.js";
import Swal from "sweetalert2";

const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

const router = useRouter();

const usertore = useUserStore();
const { isLogin, isLoginError } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

const loginUser = ref({
  user_id: "",
  user_password: "",
});

const error = ref({
  password_empty: false,
  notmatch: false,
  userid_empty: false,
});

const login = async () => {
  error.value.userid_empty = false;
  error.value.password_empty = false;
  error.value.notmatch = false;

  if (loginUser.value.user_id === "" || loginUser.value.user_id === null) {
    error.value.userid_empty = true;
  }
  if (loginUser.value.user_password === "" || loginUser.value.user_password === null) {
    error.value.password_empty = true;
  }
  if (!error.value.userid_empty && !error.value.password_empty) {
    await userLogin(loginUser.value);
    let token = sessionStorage.getItem("accessToken");
    console.log(token);
    console.log("isLogin: " + isLogin.value);
    if (isLogin.value) {
      console.log("here");
      getUserInfo(token);
      console.log(loginUser.value.user_id);
      getHighLightedHomeList(loginUser.value.user_id);
      Swal.fire({
        title: "로그인 성공",
        icon: "success",
      });
      router.replace({ name: "home" });
    } else {
      // error.value.notmatch = true;
      Swal.fire({
        title: "로그인 실패",
        text: "올바르지않은 아이디/비밀번호 입니다.",
        icon: "error",
      });
    }
  }
};
</script>
<template>
  <div class="login-view d-flex flex-column">
    <div v-if="error.notmatch" class="error">올바르지않은 아이디/비밀번호 입니다.</div>
    <div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div v-if="error.userid_empty" class="error">아이디를 입력하세요.</div>
          <input
            v-model="loginUser.user_id"
            type="text"
            id="user_id"
            class="form-control"
            placeholder="아이디"
            aria-describedby="passwordHelpInline"
          />
        </div>
      </div>
      <div class="row g-3 align-items-center">
        <div class="col-auto d-flex flex-column">
          <div v-if="error.password_empty" class="error">비밀번호를 입력하세요.</div>
          <input
            placeholder="비밀번호"
            @keyup.enter="login"
            v-model="loginUser.user_password"
            type="password"
            id="user_password"
            class="form-control"
            aria-describedby="passwordHelpInline"
          />
        </div>
      </div>
      <div class="d-flex flex-column mt-2">
        <button type="button" @click="login" class="btn mb-1">로그인</button>
        <button type="button" @click="login" class="btn">
          <RouterLink class="nav-link" :to="{ name: 'join' }">회원가입</RouterLink>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-view {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 버튼 스타일 */
.btn {
  width: 100%;
  background-color: var(--blue-color);
}

/* 가로 정렬 및 간격 조정 */
.align-items-center > .col-auto {
  display: flex;
  justify-content: center;
}
.error {
  color: rgb(100, 129, 155);
  font-weight: 600;
  margin-top: 5px;
}
</style>
