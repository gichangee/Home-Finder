<script setup>
import News from "./News.vue";
import { useRoute, useRouter } from "vue-router";
import axios from "axios";
import { ref } from "vue";
import { onMounted, watch } from "vue";

const freeBoardList = ref([]);
const reviewBoardList = ref([]);
const getBoardList = async () => {
  await axios
    .get("http://localhost:8080/board/limit?key=0&size=10")
    .then(({ data }) => {
      freeBoardList.value = data;
    });
  console.log(freeBoardList.value);
  await axios
    .get("http://localhost:8080/board/review/limit?size=10")
    .then(({ data }) => {
      reviewBoardList.value = data;
    });
  console.log(reviewBoardList.value);
};

onMounted(() => {
  getBoardList();
});
</script>

<template>
  <div class="container">
    <div class="row">
      <div class="col-md-12 home-image">
        <img src="/src/assets/img/mainBackImage1.jpg" class="img-fluid" />
      </div>
    </div>
    <hr style="margin: 5% 0%" />
    <div class="container mb-5">
      <div class="row d-flex justify-content-between">
        <div class="col-md-4 px-4 home-board d-flex flex-column">
          <header class="mb-2">부동산 뉴스</header>
          <div class="list">
            <News />
          </div>
        </div>

        <div class="col-md-4 px-4 home-board d-flex flex-column">
          <header class="mb-2">자유게시판</header>
          <div
            class="list"
            v-for="free in freeBoardList"
            :key="free.article_no">
            <div class="list-item">{{ free.subject }}</div>
          </div>
        </div>
        <div class="col-md-4 px-4 home-board d-flex flex-column">
          <header class="mb-2">리뷰게시판</header>
          <div class="list">
            <div
              class="list"
              v-for="review in reviewBoardList"
              :key="review.review_no">
              <div class="list-item d-flex">
                <div class="col-10 d-flex">
                  <div class="col-3 word me-2">
                    {{ review.apartmentName }}
                  </div>
                  <div class="col-8 word">
                    {{ review.subject }}
                  </div>
                </div>
                <div class="d-flex" v-for="i in review.star" :key="i">
                  <span>★</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-image {
  display: flex;
  justify-content: center;
  align-content: center;
}

.home-image > img {
  width: 60%;
}

.home-board {
  display: flex;
}

.home-board > header {
  font-size: 20px;
  color: var(--gray-color);
}
header {
  border-bottom: 2px solid var(--blue-color);
}
.list-item {
  font-size: 15px;
  height: 30px;
}
.word {
  /* width: 100%; */
  display: block;
  color: black;
  /* font-weight: bolder !important; */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
