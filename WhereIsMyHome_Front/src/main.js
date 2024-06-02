import "./assets/main.css";

import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import { createPinia } from "pinia";

const app = createApp(App);
const pinia = createPinia();

app.use(pinia);

import { useKakao } from "vue3-kakao-maps/@utils";
useKakao("ca7e26cad6359dda12d099bb97cf187b");

import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap";

import VueSweetalert2 from "vue-sweetalert2";
import "sweetalert2/dist/sweetalert2.min.css";
app.use(VueSweetalert2);

app.use(router);
app.mount("#app");
