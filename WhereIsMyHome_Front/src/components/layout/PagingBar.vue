<template>
    <div class="pagination">
        <button @click="gotoPage(1)" :disabled="currentPageCnt === 1">First</button>
        <button @click="prevPage" :disabled="currentPageCnt === 1">Prev</button>
        <template v-for="pageNumber in totalPages" :key="pageNumber">
            <button @click="gotoPage(pageNumber)" :class="{ active: currentPageCnt === pageNumber }">
                {{ pageNumber }}
            </button>
        </template>
        <button @click="nextPage" :disabled="currentPageCnt === totalPages">Next</button>
        <button @click="gotoPage(totalPages)" :disabled="currentPageCnt === totalPages">Last</button>
    </div>
</template>

<script setup>
import { ref, computed, watch } from "vue";
import { defineProps } from "vue";
import { onMounted } from "vue";
import { defineEmits } from "vue";
const emit = defineEmits(["page-changed"]);

const props = defineProps({
    totalItems: {
        type: Number,
        required: true,
        default: 0,
    },
    itemsPerPage: {
        type: Number,
        required: true,
    },
    currentPage: {
        type: Number,
        required: true,
    },
});
const currentPageCnt = ref();
onMounted(() => {
    currentPageCnt.value = props.currentPage;
});

const totalPages = computed(() => Math.ceil(props.totalItems / props.itemsPerPage));

const gotoPage = (page) => {
    if (page >= 1 && page <= totalPages.value) {
        currentPageCnt.value = page;
        emit("page-changed", currentPageCnt.value);
    }
};

const prevPage = () => {
    if (currentPageCnt.value > 1) {
        gotoPage(currentPageCnt.value - 1);
    }
};

const nextPage = () => {
    if (currentPageCnt.value < totalPages.value) {
        gotoPage(currentPageCnt.value + 1);
    }
};

watch(
    () => props.currentPage,
    (newValue) => {
        console.log(props.currentPage);
        currentPageCnt.value = newValue;
    }
);
onMounted(() => {
    currentPageCnt.value = props.currentPage;
});
</script>

<style scoped>
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 10px 0px;
    flex-wrap: wrap;
}

button {
    margin: 0 5px;
}

button:disabled {
    opacity: 0.5;
}

button.active {
    font-weight: 900;
    color: rgb(255, 255, 255);
    background-color: var(--blue-color);
    border-radius: 50%;
}
button {
    background-color: white;
    border: none;
}
</style>
