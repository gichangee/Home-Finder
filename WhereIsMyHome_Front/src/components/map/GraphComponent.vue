<script setup>
import { ref, onMounted, defineProps, watch } from "vue";
import { Chart, Grid, Line } from "vue3-charts";

const props = defineProps({
  list: Array,
});
const datalist = ref([]);

// 차트 데이터 가져오기
const chartData = ref([]);
// 방향
const chartDirection = ref("horizontal");
// 차트 마진
const chartMargin = ref({
  left: 0,
  top: 20,
  right: 20,
  bottom: 0,
});
// 차트 사이즈
const chartSize = ref({ width: 600, height: 500 });
// 차트 가로값 세로값
const chartDataKeys = ref(["name", "pl"]);

// props.list가 변경될 때마다 차트 데이터를 업데이트합니다.
watch(
  () => props.list,
  (newVal) => {
    // props.list가 변경되면 datalist를 비우고 새로운 데이터를 추가합니다.
    datalist.value = newVal.map((item) => ({
      name: `${item.dealYear}/${item.dealMonth}`, // 예: "2018/10"
      pl: parseFloat(item.dealAmount.replace(/,/g, "")), // dealAmount에서 쉼표를 제거하고 숫자로 변환합니다.
    }));

    // 데이터를 역순으로 변경합니다.
    datalist.value.reverse();

    // 차트 데이터를 업데이트합니다.
    chartData.value = [...datalist.value];
  }
);
onMounted(() => {
  console.log("list 데이터:", props.list);
});
</script>

<template>
  <Chart :size="chartSize" :data="chartData" :margin="chartMargin" :direction="chartDirection">
    <template #layers>
      <Grid strokeDasharray="2,2" />
      <Line :dataKeys="chartDataKeys" />
    </template>
  </Chart>
</template>

<style scoped></style>
