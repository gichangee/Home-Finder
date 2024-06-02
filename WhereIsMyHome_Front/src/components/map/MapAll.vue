<script setup>
import { useRoute, onBeforeRouteUpdate } from "vue-router";
import { useRouter } from "vue-router";
import { ref, onMounted, onBeforeUnmount } from "vue";
import axios from "axios";
import { useMapStore } from "@/stores/map";
import AptListItem from "./AptListItem.vue";

const aptDataList = ref([]);
const store = useMapStore();
const route = useRoute();
const router = useRouter();
const fullDongcode = ref(route.params.fullDongcode);
const maxAmount = ref("");
const aptlistRef = ref(null);

onBeforeRouteUpdate((to, from) => {
  fullDongcode.value = to.params.fullDongcode;
  fetchAptList(); // 새로운 경로로 업데이트 될 때 리스트 갱신
});

onMounted(() => {
  console.log("here");
  fetchAptList();
});

const fetchAptList = () => {
  const url = "http://localhost:8080/home/full?dongCode=" + fullDongcode.value;

  axios
    .get(url)
    .then((response) => {
      makeList(response.data);
    })
    .catch((error) => {
      initTable();
    });
};

const makeList = (data) => {
  console.log("mapAll");
  aptDataList.value = data.dongList;
};

const initTable = () => {
  aptDataList.value = [];
};
</script>

<template>
  <div>
    <div class="text-center aptlist-container" id="aptlist" ref="aptlistRef">
      <AptListItem
        v-for="(apt, index) in aptDataList"
        :key="index"
        :apt="apt"
        class="home-info container d-flex"
      />
    </div>
  </div>
</template>

<style scoped>
.aptlist-container {
  max-height: 500px; /* 필요에 따라 이 값을 조정하세요 */
  overflow-y: auto;
  border: 1px solid #ddd; /* 선택 사항: 더 나은 가시성을 위해 경계를 추가 */
  padding: 10px; /* 선택 사항: 더 나은 간격을 위해 패딩 추가 */
}

.house-info {
  display: flex;
}

img {
  width: 100%;
  height: 100%;
}
</style>
