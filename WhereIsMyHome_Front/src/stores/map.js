import { ref } from "vue";
import { defineStore } from "pinia";

export const useMapStore = defineStore("maplet", () => {
    const lat = ref(33.450701);
    const lng = ref(126.570667);
    const isDetail = ref(false);

    function setCoordinates(newLat, newLng) {
        lat.value = newLat;
        lng.value = newLng;
    }

    return { lat, lng, setCoordinates,isDetail };
});
