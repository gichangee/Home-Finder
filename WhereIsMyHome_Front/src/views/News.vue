<template>
  <div>
    <!-- 검색 결과를 나타낼 리스트 -->
    <div class="news-box" v-for="(article, index) in articles" :key="index">
      <a class="list-item" :href="article.link" target="_blank">{{
        article.title
      }}</a>
    </div>
  </div>
</template>

<script scoped>
import { ref } from "vue"; // Vue 3의 Composition API에서 ref 함수 import

export default {
  setup() {
    // 검색 결과를 저장할 ref 변수 선언
    const articles = ref([]);

    // 네이버 뉴스를 가져오는 함수
    const getNaverNews = async (query) => {
      const baseUrl = `https://search.naver.com/search.naver`;
      let url = `${baseUrl}?where=news&sm=mtb_pge&query=${query}`;

      try {
        let page = 1;
        const results = [];
        while (true) {
          const response = await fetch(url);
          if (!response.ok) {
            throw new Error("네이버 뉴스를 가져오는 데 실패했습니다.");
          }
          const html = await response.text();
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, "text/html");

          const newsArticles = doc.querySelectorAll(".news_area");
          newsArticles.forEach((article) => {
            const title = article.querySelector(".news_tit").textContent;
            const link = article.querySelector(".news_tit").href;
            results.push({ title, link });
          });

          // 다음 페이지로 이동하는 링크가 있는지 확인
          const nextButton = doc.querySelector(".paging a.next");
          if (!nextButton) break; // 다음 페이지가 없으면 종료

          // 다음 페이지 URL 구성
          page++;
          url = `${baseUrl}?where=news&sm=mtb_pge&query=${query}&start=${
            (page - 1) * 10 + 1
          }`;
        }
        articles.value = results;
      } catch (error) {
        console.error(error);
      }
    };

    // 컴포넌트가 마운트될 때 네이버 뉴스 가져오기
    getNaverNews("부동산");

    // 퍼블릭 API 반환
    return {
      articles,
    };
  },
};
</script>

<style scoped>
.news-box a {
  text-decoration: none;
  color: black;
  font-size: 15px;
  margin-bottom: 4px;
}
.news-box {
}
</style>
