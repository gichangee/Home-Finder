import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import MapView from "@/views/MapView.vue";

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: "/",
            name: "home",
            component: HomeView,
        },
        {
            path: "/map",
            name: "map",
            component: MapView,
            children: [
                {
                    path: "all/:fullDongcode",
                    name: "all",
                    component: () => import("@/components/map/MapAll.vue"),
                },
                {
                    path: "detail/:aptCode/:fullDongcode",
                    name: "detail",
                    component: () => import("@/components/map/MapDetail.vue"),
                },
            ],
        },
        {
            path: "/board",
            name: "board",
            component: () => import("../views/BoardView.vue"),
            redirect: { name: "article-list" },
            children: [
                {
                    path: "list",
                    name: "article-list",
                    component: () => import("@/components/board/BoardList.vue"),
                    children: [
                        {
                            path: "free",
                            name: "free-board",
                            component: () => import("@/components/board/BoardList.vue"),
                        },
                        {
                            path: "qna",
                            name: "qna-board",
                            component: () => import("@/components/board/BoardList.vue"),
                        },
                    ],
                },
                {
                    path: "review",
                    name: "review-board",
                    component: () => import("@/components/board/BoardReview.vue"),
                },
                {
                    path: "reviewview/:review_no",
                    name: "review-view",
                    component: () => import("@/components/board/BoardReviewDetail.vue"),
                },
                {
                    path: "reviewedit/:review_no",
                    name: "review-edit",
                    component: () => import("@/components/board/BoardReviewEdit.vue"),
                },
                {
                    path: "view/:article_no",
                    name: "article-view",
                    component: () => import("@/components/board/BoardDetail.vue"),
                },
                {
                    path: "write/:article_type",
                    name: "article-write",
                    component: () => import("@/components/board/BoardWrite.vue"),
                },
                {
                    path: "reviewwrite",
                    name: "review-write",
                    component: () => import("@/components/board/BoardReviewWrite.vue"),
                },
                {
                    path: "reviewwrite/:apartmentName/:aptCode",
                    name: "review-write-params",
                    component: () => import("@/components/board/BoardReviewWrite.vue"),
                },
                {
                    path: "modify/:articleno",
                    name: "article-modify",
                    component: () => import("@/components/board/BoardModify.vue"),
                },
            ],
        },
        {
            path: "/user",
            name: "user",
            component: () => import("../views/UserView.vue"),
            redirect: { name: "home" },
            children: [
                {
                    path: "profile",
                    name: "profile",
                    component: () => import("@/components/user/UserProfile.vue"),
                },
                {
                    path: "wishlist",
                    name: "wishlist",
                    component: () => import("@/components/user/WishList.vue"),
                },
            ],
        },
        {
            path: "/login",
            name: "login",
            component: () => import("../views/LoginView.vue"),
        },
        {
            path: "/join",
            name: "join",
            component: () => import("../views/JoinView.vue"),
        },
        {
            path: "/news",
            name: "news",
            component: () => import("../views/News.vue"),
        },
    ],
});

export default router;
