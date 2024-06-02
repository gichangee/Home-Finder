<script setup>
import apartmentImage from "@/assets/img/apartment.jpeg";
import { useRouter } from "vue-router";
import { defineEmits } from "vue";
const emit = defineEmits(["changeDetailProp", "updateAptInfo"]);
const router = useRouter();

import { storeToRefs } from "pinia";
import { defineProps, onMounted, ref, watch } from "vue";

import { useHighLightedStore } from "@/stores/highlighted.js";
const highlightedStore = useHighLightedStore();
const { getHighLightedHomeList, addHighLightedHome, deleteHighLightedHome } = highlightedStore;
const { highLightedList } = storeToRefs(highlightedStore);

import { useMapStore } from "@/stores/map";
const store = useMapStore();
const { isDetail } = storeToRefs(store);

import { useUserStore } from "@/stores/user.js";
const usertore = useUserStore();
const { userInfo, isLogin } = storeToRefs(usertore);
const { userLogin, getUserInfo } = usertore;

const active = ref(false);

const price = ref({
  front: null,
  back: null,
});
const props = defineProps({
  aptInfo: Object,
  recentAmount: String,
  fullDongcode: String,
});

const addHighLight = async function (aptCdoe) {
  if (active.value) {
    //삭제요청하기
    console.log(userInfo);
    await deleteHighLightedHome(userInfo.value.user_id, aptCdoe).then(() => {
      //highLightedList값 바꾸기
      highLightedList.value = highLightedList.value.filter((item) => item.aptCode !== aptCdoe);
      active.value = false;
    });
    await getHighLightedHomeList(userInfo.value.user_id).then(() => {
      emit("updateAptInfo");
    });
  } else {
    //등록요청하기
    await addHighLightedHome(userInfo.value.user_id, aptCdoe).then(() => {
      //highLightedList값 바꾸기
      getHighLightedHomeList(userInfo.value.user_id);
      active.value = true;
    });
  }
};

function trclick(aptlng, aptlat, aptCode, roadName) {
  store.setCoordinates(aptlat, aptlng);
  isDetail.value = true;
  emit("changeDetailProp", aptlng, aptlat, aptCode, roadName);
  // router.push({ name: "detail", params: { aptCode: aptCode, fullDongcode: fullDongcode } });
}
const calPrice = function () {
  if (props.recentAmount.length > 5) {
    const remove = props.recentAmount.replace(/,/g, "");
    // console.log(remove);
    price.value.front = remove.slice(0, -4);
    price.value.back = remove.slice(-4);
    if (price.value.back == "0000") price.value.back = null;
  } else {
    price.value.back = props.recentAmount;
  }
};

// watch(highLightedList, (newValue, oldValue) => {
//   active.value = !active.value;
// });
onMounted(async () => {
  calPrice();
  await getHighLightedHomeList(userInfo.value.user_id);
  if (highLightedList.value.includes(props.aptInfo.aptCode)) {
    // console.log("리스트 - 찜하기 판단 성공");
    active.value = true;
  }
});
</script>

<template>
  <div>
    <div class="d-flex p-2 apt-list-item">
      <div
        class="col-5 apt-img"
        @click="
          trclick(
            props.aptInfo.lng,
            props.aptInfo.lat,
            props.aptInfo.aptCode,
            props.aptInfo.roadName
          )
        "
      >
        <img :src="apartmentImage" />
      </div>
      <div class="col-7 apt-info ms-3 d-flex flex-column">
        <div
          class="apt-info-top"
          @click="
            trclick(
              props.aptInfo.lng,
              props.aptInfo.lat,
              props.aptInfo.aptCode,
              props.aptInfo.roadName
            )
          "
        >
          <div class="apt-price">
            <span v-if="price.front">{{ price.front }}억</span>
            <span v-if="price.back">{{ price.back }}만원</span>
          </div>
          <div class="apt-name">건물명 : {{ props.aptInfo.apartmentName }}</div>
          <div class="apt-build-year">건축년도 : {{ props.aptInfo.buildYear }}년</div>
        </div>
        <div class="apt-info-bottom" v-if="isLogin">
          <button
            @click="addHighLight(props.aptInfo.aptCode)"
            class="like-btn d-flex justify-content-center align-items-center"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="w-6 h-6"
              :class="{ red: active }"
            >
              <path
                d="m11.645 20.91-.007-.003-.022-.012a15.247 15.247 0 0 1-.383-.218 25.18 25.18 0 0 1-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0 1 12 5.052 5.5 5.5 0 0 1 16.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 0 1-4.244 3.17 15.247 15.247 0 0 1-.383.219l-.022.012-.007.004-.003.001a.752.752 0 0 1-.704 0l-.003-.001Z"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.apt-list-item {
  border-bottom: 1px solid #ccc;
  height: 200px;
}
.apt-price {
  font-weight: 900;
  font-size: 30px;
}
/* .apt-name{
    font-weight: 900;
    font-size: 20px;
} */
img {
  width: 100%;
  height: 100%;
}

.apt-info-bottom {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: flex-end;
}
button {
  background-color: var(--blue-color);
  border: none;
  color: white;
  border-radius: 10px;
  /* width: 40px;
    height: 40px; */
  padding: 10px 30px;
}
svg {
  width: 20px;
  height: 20px;
}
.like-btn {
  z-index: 1000;
}
.red {
  color: rgb(41, 64, 100);
}
</style>
