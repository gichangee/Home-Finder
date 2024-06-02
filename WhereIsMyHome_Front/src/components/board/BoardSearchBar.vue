<script setup></script>

<template>
    <div>
        <div class="col-lg-8 col-md-10 col-sm-12">
            <div class="row align-self-center mb-2">
                <div class="col-md-10">
                    <form class="d-flex" id="form-search" action="">
                        <select
                            name="key"
                            id="key"
                            class="form-select form-select-sm ms-5 me-1 w-50"
                            aria-label="검색조건"
                        >
                            <option selected>검색조건</option>
                            <option value="article_no">글번호</option>
                            <option value="subject">제목</option>
                            <option value="user_id">작성자</option>
                        </select>
                        <div class="input-group input-group-sm">
                            <input type="text" name="word" id="word" class="form-control" placeholder="검색어..." />
                            <button id="btn-search" class="btn btn-dark" type="button">검색</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped></style>
