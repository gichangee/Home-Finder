// src/stores/highlighted.js
import { ref } from "vue"
import { useRouter } from "vue-router"
import { defineStore } from "pinia"
import {getHighLightedHomeListFromDB,deleteHighLightedHomeToDB,addHighLightedHomeToDB } from "@/api/user"

export const useHighLightedStore = defineStore("highLightedStore", () => {
    const router = useRouter()
    const highLightedList = ref([ ]);
    const getHighLightedHomeList = async (userid) => {
        // 함수 구현
        await getHighLightedHomeListFromDB(userid,
            (response) => {
                highLightedList.value = response.data.list;
            },
            (error) => {
                console.log("찜 목록 받아오기 에러 발생 " + error);
            })
    }
    const resetHighLightedHomeList = () => {
        highLightedList.value = [];
    }
    const addHighLightedHome = async (user_id, aptCode) => {
        const params = {
            user_id: user_id,
            aptCode: aptCode,
        }
        await addHighLightedHomeToDB(params,
            (response) => {
                highLightedList.value = response.data.list;
            },
            (error) => {
                console.log("찜 목록 받아오기 에러 발생 " + error);
        })
    }
    const deleteHighLightedHome = async (user_id, aptCode) => {
        const params = {
            user_id: user_id,
            aptCode: aptCode,
        }
        console.log(params.user_id+" "+aptCode)
        await deleteHighLightedHomeToDB(params,
            (response) => {
            
            },
            (error) => {
                console.log("찜 목록 받아오기 에러 발생 " + error);
            })
        console.log("삭제완료");
    }
    return {
        getHighLightedHomeList,
        highLightedList,
        resetHighLightedHomeList,
        addHighLightedHome,
        deleteHighLightedHome
    }
})
