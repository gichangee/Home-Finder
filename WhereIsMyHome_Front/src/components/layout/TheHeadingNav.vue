<script setup>
import { RouterLink, RouterView, useRouter } from "vue-router";
import { onMounted, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useUserStore } from "../../stores/user.js";
import { useHighLightedStore } from "@/stores/highlighted.js";
import Swal from "sweetalert2";

const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList, resetHighLightedHomeList } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

const router = useRouter();
const userStore = useUserStore();

const showModal = ref(false);

const logout = function () {
  resetHighLightedHomeList();
  userStore.userLogout();
  Swal.fire({
    title: "로그아웃 성공",
    // text: "다음에 만나요😎",
    icon: "success",
  });
  router.replace({ name: "home" });
};
</script>

<template>
  <div>
    <nav class="container-fluid nav justify-content-between align-items-center">
      <div class="nav-item d-flex">
        <RouterLink class="title" :to="{ name: 'home' }">Home Finder</RouterLink>
      </div>
      <div class="nav-item d-flex">
        <RouterLink class="nav-link" :to="{ name: 'map' }">지도</RouterLink>
        <!-- <RouterLink class="nav-link" :to="{ name: 'news' }">뉴스</RouterLink> -->
        <RouterLink class="nav-link" :to="{ name: 'free-board' }">자유게시판</RouterLink>
        <RouterLink class="nav-link" :to="{ name: 'review-board' }">리뷰게시판</RouterLink>
        <RouterLink class="nav-link" :to="{ name: 'qna-board' }">문의하기</RouterLink>
        <div class="nav-item d-flex" v-if="!userStore.isLogin">
          <RouterLink class="nav-link" :to="{ name: 'login' }">로그인</RouterLink>
          <RouterLink class="nav-link" :to="{ name: 'join' }">회원가입</RouterLink>
        </div>
        <div class="nav-item d-flex" v-else>
          <button class="btn" @click="logout">로그아웃</button>
          <RouterLink class="nav-link" :to="{ name: 'wishlist' }">찜목록</RouterLink>
          <RouterLink class="nav-link" :to="{ name: 'profile' }">마이페이지</RouterLink>
        </div>
      </div>
    </nav>
  </div>
</template>

<style scoped>
.nav {
  padding: 1% 2%;
  background-color: var(--white-color);
}
.nav a,
.btn {
  color: var(--gray-color);
  text-decoration: none;
  font-size: 15px;
}
.title {
  font-size: 25px !important;
}
</style>
