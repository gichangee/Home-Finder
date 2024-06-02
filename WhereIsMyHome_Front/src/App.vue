<script setup>
import { RouterLink, RouterView, useRouter } from "vue-router";
import { onMounted, ref, watch } from "vue";
import { storeToRefs } from "pinia";

import { useUserStore } from "./stores/user.js";
import TheHeadingNav from "./components/layout/TheHeadingNav.vue";
import TheFooter from "./components/layout/TheFooter.vue";

import { useHighLightedStore } from "@/stores/highlighted.js";
const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

const usertore = useUserStore();
const { isLogin, isLoginError, userInfo } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

const router = useRouter();
const userStore = useUserStore();

const logout = function () {
  userStore.logout();
  router.replace({ name: "home" });
};
onMounted(async () => {
  const token = sessionStorage.getItem("accessToken");
  if (token) {
    await userStore.getUserInfo(token).then(async () => {
      await getHighLightedHomeList(userInfo.value.user_id);
    });
  }
});
</script>

<template>
  <div class="container-fluid viewport-100">
    <TheHeadingNav />
    <main>
      <RouterView />
    </main>
    <TheFooter />
  </div>
</template>

<style scoped>
.viewport-100 {
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow-y: scroll;
}
main {
  flex: 1;
}
.container-fluid {
  margin: 0px;
  padding: 0px;
}
</style>
