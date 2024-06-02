<script setup>
import { ref } from "vue";
import { confirmUserid, confirmEmail, join } from "@/api/user";
import router from "@/router";
import Swal from "sweetalert2";

const joinUser = ref({
  user_id: "",
  user_name: "",
  user_password: "",
  user_email: "",
  email_domain: "",
  email_id: "",
});

const chckedPassword = ref("");

const error = ref({
  userid_empty: false,
  userid_unable: false,
  username_empty: false,
  userpassword_empty: false,
  useremail_empty: false,
  useremail_unable: false,
  notmatch_email_format: false,
  notmatch_password: false,
});

//빈칸이 있는지 꼭 확인하기
const checkAndJoin = async () => {
  await checkUsername();
  //아이디 유효성 검사
  await checkId();
  //비밀번호 검사
  await checkPassword();
  //이메일 유효성 검사 + 이메일 검증
  await checkEmail();

  //위의 다 통과하면 조인 시키기
  if (Object.values(error.value).every((value) => !value)) {
    delete joinUser.value.user_email;
    await join(
      joinUser.value,
      (response) => {
        Swal.fire({
          title: "회원가입 성공",
          text: "버튼을 누르면 로그인 페이지로 이동합니다!",
          icon: "success",
        }).then(() => {
          router.push({ name: "login" });
        });
      },
      (error) => {
        console.log(error);
        joinUser.value.user_email = "";
      }
    );
  }
};

const checkUsername = function () {
  if (joinUser.value.user_name === "" || joinUser.value.user_name === null) {
    error.value.username_empty = true;
    return;
  } else error.value.username_empty = false;
};

//아이디 유효성 검사
const checkId = async function () {
  //빈칸 여부
  if (joinUser.value.user_id == "" || joinUser.value.user_id == null) {
    error.value.userid_empty = true;
    return;
    // 존재하는 아이디인지 확인
  } else {
    error.value.userid_empty = false;
    await confirmUserid(
      joinUser.value.user_id,
      (response) => {
        if (response.data.result) {
          error.value.userid_unable = true;
          return;
        } else error.value.userid_unable = false;
      },
      (error) => {
        console.log(error);
        return;
      }
    );
  }
};

//비밀번호 검사
const checkPassword = function () {
  if (joinUser.value.user_password && joinUser.value.user_password !== chckedPassword.value) {
    error.value.notmatch_password = true;
    return;
  } else if (joinUser.value.user_password == "" || joinUser.value.user_password == null) {
    error.value.userpassword_empty = true;
    return;
  } else {
    error.value.notmatch_password = false;
    error.value.userpassword_empty = false;
  }
};

//이메일 유효성 검사
const checkEmail = async function () {
  error.value.useremail_unable = false;
  error.value.notmatch_email_format = false;
  const userEmail = joinUser.value.user_email;
  const atIndex = userEmail.indexOf("@"); // "@"의 인덱스 위치 찾기

  // "@"가 문자열에 존재하는 경우 - email id, domain 분리하기
  if (atIndex !== -1) {
    joinUser.value.email_id = userEmail.substring(0, atIndex); // "@" 이전의 부분 추출
    joinUser.value.email_domain = userEmail.substring(atIndex + 1); // "@" 이후의 부분 추출
  } else {
    error.value.notmatch_email_format = true;
    return;
  }
  // 데이터를 다 받았는지 확인하기
  if (
    joinUser.value.email_id.length == 0 ||
    joinUser.value.email_domain.length == 0 ||
    joinUser.value.email_domain.indexOf(".") === -1 ||
    joinUser.value.email_domain.substring(joinUser.value.email_domain.indexOf(".") + 1).length === 0
  ) {
    error.value.notmatch_email_format = true;
    return;
  }

  // 사용가능한 이메일인지
  const email = {
    email_id: joinUser.value.email_id,
    email_domain: joinUser.value.email_domain,
  };
  await confirmEmail(
    email,
    (response) => {
      console.log(response.data.result);
      if (response.data.result) {
        error.value.useremail_unable = true;
        return;
      }
    },
    (error) => {
      console.log(error);
      return;
    }
  );
};
</script>

<template>
  <div class="join-view">
    <div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div class="error" v-if="error.username_empty">이름을 입력하세요.</div>
          <input
            v-model="joinUser.user_name"
            placeholder="이름"
            @keyup.enter="checkAndJoin"
            type="text"
            id="user_name"
            class="form-control"
          />
        </div>
      </div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div class="error" v-if="error.userid_empty">아이디를 입력하세요.</div>
          <div class="error" v-if="error.userid_unable">이미 사용중인 아이디입니다.</div>
          <input
            v-model="joinUser.user_id"
            @keyup.enter="checkAndJoin"
            type="text"
            id="user_id"
            class="form-control"
            placeholder="아이디"
          />
        </div>
      </div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div class="error" v-if="error.userpassword_empty">비밀번호를 입력하세요.</div>
          <input
            v-model="joinUser.user_password"
            placeholder="비밀번호"
            @keyup.enter="checkAndJoin"
            type="password"
            id="user_password"
            class="form-control"
          />
        </div>
      </div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div class="error" v-if="error.notmatch_password">비밀번호가 일치하지않습니다.</div>
          <input
            v-model="chckedPassword"
            placeholder="비밀번호 확인"
            @keyup.enter="checkAndJoin"
            type="password"
            id="check_password"
            class="form-control"
          />
        </div>
      </div>
      <div class="row g-3 align-items-center mb-1">
        <div class="col-auto d-flex flex-column">
          <div class="error" v-if="error.useremail_empty">이메일을 입력하세요.</div>
          <div class="error" v-if="error.useremail_unable">이미 사용중인 이메일입니다.</div>
          <div class="error" v-if="error.notmatch_email_format">올바른 이메일 형식이 아닙니다.</div>
          <input
            v-model="joinUser.user_email"
            placeholder="이메일"
            @keyup.enter="checkAndJoin"
            type="email"
            id="email"
            class="form-control"
          />
        </div>
      </div>
      <div class="d-flex flex-column mt-2">
        <button type="button" @click="checkAndJoin" class="btn mb-1">회원가입</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.join-view {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.btn {
  width: 100%;
  background-color: var(--blue-color);
}

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
