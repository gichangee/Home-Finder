<script setup>
import { onMounted, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useRouter } from "vue-router";
import { useUserStore } from "@/stores/user.js";
import axios from "axios";
import Swal from "sweetalert2";
import { passwordConfirm, secessionUser } from "@/api/user.js";

const router = useRouter();
const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

const modifyUser = ref({
  user_id: "",
  user_username: "",
  user_password: "",
  email_id: "",
  email_domain: "",
});

const checkedPassword = ref("");
const passwordError = ref(false);
const emailError = ref(false);
const emailEmpty = ref(false);

if (!isLogin.value) {
  alert("잘못된 접근입니다.");
  router.replace({ name: "home" });
} else {
  //값을 복사해서 쓰지않으면 modifyUser가 바뀔 때 userInfo도 바뀜
  modifyUser.value = { ...userInfo.value };
  delete modifyUser.value.permission_level;
}

const modify = async () => {
  //비밀번호 변경이 있는데 비밀번호와 비밀번호 확인의 값이 일치하지않을 때
  if (modifyUser.value.user_password && modifyUser.value.user_password !== checkedPassword.value) {
    passwordError.value = true;
    return;
  }
  //비밀번호 변경을 취소한 경우
  else if (modifyUser.value.user_password == "") {
    modifyUser.value.user_password = null;
    passwordError.value = false;
  } else {
    passwordError.value = false;
  }

  //데이터 변경이 아예 없을 떄
  if (
    modifyUser.value.email_domain === userInfo.value.email_domain &&
    modifyUser.value.email_id === userInfo.value.email_id &&
    modifyUser.value.user_password === null
  ) {
    return;
  }

  //데이터 변경이 발생한 경우
  if (
    modifyUser.value.email_domain !== userInfo.value.email_domain ||
    modifyUser.value.email_id !== userInfo.value.email_id
  ) {
    //데이터 입력을 완수하지않은 경우
    if (modifyUser.value.email_domain == "" || modifyUser.value.email_id == "") {
      emailEmpty.value = true;
      return;
    }
    //데이터 입력을 완수한 경우
    else {
      emailEmpty.value = false;

      const modifyEmail = {
        email_domain: modifyUser.value.email_domain,
        email_id: modifyUser.value.email_id,
      };

      //이메일 유효성 검사
      axios
        .get("http://localhost:8080/user/emailcofirm", { params: modifyEmail })
        .then((response) => {
          console.log(response.data.result);
          //이미 사용중인 이메일일 경우
          if (!response.data.result) {
            emailError.value = true;
            return;
          }
          // 유효성 검사 통과
          else {
            emailError.value = false;
          }
        })
        .catch((e) => {
          console.log(e);
        });
    }
  }
  //수정하기
  axios
    .patch("http://localhost:8080/user/edit", modifyUser.value)
    .then((response) => {
      getUserInfo(sessionStorage.getItem("accessToken"));
      Swal.fire({
        title: "회원정보 수정 성공",
        icon: "success",
      }).then(() => {
        modifyUser.value.user_password = "";
        getUserInfo(userInfo.value.user_id);
        router.push({ name: "profile" });
      });
    })
    .catch((error) => {});
};

//회원 탈퇴 관련
const showSecessionConfirmModal = ref(false);
const showModal = async () => {
  const { value: password } = await Swal.fire({
    title: "비밀번호를 입력해주세요",
    input: "password",
    inputLabel: "탈퇴 시 계정을 되돌릴 수 없습니다.",
    inputPlaceholder: "비밀번호를 입력해주세요",
    inputAttributes: {
      maxlength: "10",
      autocapitalize: "off",
      autocorrect: "off",
    },
    icon: "warning", // 아이콘 유형을 명시적으로 설정
  });
  if (password) {
    try {
      const confirmUser = {
        user_id: userInfo.value.user_id,
        user_password: password,
      };
      const response = await passwordConfirm(confirmUser);
      if (response.status === 200) {
        Swal.fire("회원탈퇴가 완료되었습니다.", "", "success");
        sessionStorage.removeItem("accessToken");
        sessionStorage.removeItem("refreshToken");
        getUserInfo();
        router.replace({ name: "home" });
      }
    } catch (error) {
      if (error.response.status === 400) {
        Swal.fire("비밀번호가 일치하지 않습니다.", "", "error");
      } else {
        Swal.fire("회원탈퇴 중 오류가 발생했습니다.", "", "error");
      }
    }
  }
};

watch(showSecessionConfirmModal, (newVal) => {
  if (newVal) {
    showModal().then(() => {
      showSecessionConfirmModal.value = false; // Reset the modal state
    });
  }
});
onMounted(() => {
  emailError.value = false;
});
</script>
<template>
  <div class="profile-view">
    <div class="profile-form">
      <div class="input-group mb-3">
        <span class="input-group-text" id="inputGroup-sizing-default">아이디</span>
        <input
          disabled
          v-model="modifyUser.user_id"
          type="text"
          class="form-control"
          aria-label="Sizing example input"
          aria-describedby="inputGroup-sizing-default"
        />
      </div>
      <div class="input-group mb-3">
        <span class="input-group-text" id="inputGroup-sizing-default">이름</span>
        <input
          disabled
          v-model="modifyUser.user_name"
          type="text"
          class="form-control"
          aria-label="Sizing example input"
          aria-describedby="inputGroup-sizing-default"
        />
      </div>
      <div class="input-group mb-3">
        <span class="input-group-text" id="inputGroup-sizing-default">비밀번호</span>
        <input
          v-model="modifyUser.user_password"
          type="text"
          class="form-control"
          aria-label="Sizing example input"
          aria-describedby="inputGroup-sizing-default"
        />
      </div>
      <div class="d-flex flex-column" v-if="modifyUser.user_password">
        <div v-if="passwordError" class="error">비밀번호가 일치하지않습니다.</div>
        <div class="input-group mb-3">
          <span class="input-group-text" id="inputGroup-sizing-default">비밀번호 확인</span>
          <input
            v-model="checkedPassword"
            type="text"
            class="form-control"
            aria-label="Sizing example input"
            aria-describedby="inputGroup-sizing-default"
          />
        </div>
      </div>
      <div class="input-group mb-3 d-flex flex-column">
        <div v-if="emailEmpty" class="error">이메일을 입력해주세요</div>
        <div v-if="emailError" class="error">사용중인 이메일입니다.</div>
        <div class="d-flex">
          <input
            type="text"
            class="form-control"
            v-model="modifyUser.email_id"
            placeholder="Recipient's username"
            aria-label="Recipient's username"
            aria-describedby="basic-addon2"
          />
          <span class="input-group-text" id="inputGroup-sizing-default">@</span>
          <input
            type="text"
            class="form-control"
            v-model="modifyUser.email_domain"
            placeholder="Recipient's username"
            aria-label="Recipient's username"
            aria-describedby="basic-addon2"
          />
        </div>
      </div>
      <button type="button" @click="modify" class="btn mb-1">수정하기</button>
      <div @click="showSecessionConfirmModal = true">회원탈퇴</div>
    </div>
  </div>
</template>

<style scoped>
.profile-view {
  height: 70vh; /* Viewport height 설정 */
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.profile-form {
  width: 100%;
  max-width: 500px; /* 최대 너비 설정 */
}

.error {
  color: rgb(100, 129, 155);
  font-weight: 600;
  margin-top: 5px;
}

.btn {
  width: 100%;
  background-color: var(--blue-color);
}
</style>
