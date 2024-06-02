import { localAxios } from "@/util/http-commons";
import { useUserStore } from "@/stores/user.js";
import { storeToRefs } from "pinia";

const local = localAxios();

async function userConfirm(param, success, fail) {
  await local.post(`/user/login`, param).then(success).catch(fail);
}

async function findById(userid, success, fail) {
  local.defaults.headers["Authorization"] = sessionStorage.getItem("accessToken");
  await local.get(`/user/info/${userid}`).then(success).catch(fail);
}

async function tokenRegeneration(user, success, fail) {
  local.defaults.headers["refreshToken"] = sessionStorage.getItem("refreshToken"); //axios header에 refresh-token 셋팅
  await local.post(`/user/refresh`, user).then(success).catch(fail);
}

async function logout(userid, success, fail) {
  await local.get(`/user/logout/${userid}`).then(success).catch(fail);
}
async function confirmUserid(userid, success, fail) {
  await local.get(`/user/confirmuserid/${userid}`).then(success).catch(fail);
}
async function confirmEmail(email, success, fail) {
  await local.get(`/user/emailcofirm?email_id=${email.email_id}&email_domain=${email.email_domain}`).then(success).catch(fail);
}

async function join(param, success, fail) {
  await local.post(`/user/join`, param).then(success).catch(fail);  
}
async function passwordConfirm(confirmUser, success, fail) {
    const response = await local.post('/user/passwordconfirm', confirmUser);
    return response;

}
async function secessionUser(success, fail) {
  await local.delete(
    "/api/user/secession",
    {},
    {
      headers: {
        Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
      },
    }
  );
}
async function getHighLightedHomeListFromDB(userid, success, fail) {
  await local.get(`/user/highlight/${userid}`).then(success).catch(fail);
}
async function addHighLightedHomeToDB(params, success, fail) {
  await local.post(`/user/highlight`,params).then(success).catch(fail);
}
async function deleteHighLightedHomeToDB(params, success, fail) {
  await local.post(`/user/highlight/delete`,params).then(success).catch(fail);
}

export { deleteHighLightedHomeToDB,addHighLightedHomeToDB,getHighLightedHomeListFromDB,confirmEmail,userConfirm, findById, tokenRegeneration, logout,confirmUserid ,join,passwordConfirm,secessionUser};
