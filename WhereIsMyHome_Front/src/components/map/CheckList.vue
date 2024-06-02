<template>
  <div class="check-list" v-if="isOpen">
    <div
      class="d-flex align-items-center justify-content-between header mb-3 pb-1">
      <div>체크리스트</div>
    </div>
    <div class="d-flex mb-3 justify-content-center">
      <input
        v-model="newTodo"
        type="text"
        placeholder="체크할 부분을 메모하세요!" />
      <button class="add-btn" @click="addTodo">+</button>
    </div>
    <div>
      <ul>
        <li v-for="(todo, index) in todos" :key="index" class="todo-item">
          <span
            :class="{ completed: todo.completed }"
            @click="toggleComplete(index)">
            {{ todo.text }}
          </span>
          <button class="delete-btn" @click="removeTodo(index)">X</button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { defineProps, defineEmits } from "vue";

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true,
  },
});

const emit = defineEmits(["close"]);

const newTodo = ref("");
const todos = ref([]);

const addTodo = () => {
  if (newTodo.value.trim() !== "") {
    todos.value.push({ text: newTodo.value.trim(), completed: false });
    newTodo.value = "";
  }
};

const removeTodo = (index) => {
  todos.value.splice(index, 1);
};

const toggleComplete = (index) => {
  todos.value[index].completed = !todos.value[index].completed;
};

const close = () => {
  emit("close");
};
</script>

<style scoped>
.check-list {
  margin-top: 50px;
  background-color: white;
  padding: 20px 30px;
  border-radius: 20px;
}

.header {
  border-bottom: 2px solid var(--blue-color);
}

input {
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 5px;
  flex-grow: 1;
}

.add-btn {
  margin-left: 5px;
  width: 35px;
  height: 35px;
  background-color: var(--blue-color);
  color: white;
  border-radius: 5px;
  border: none;
  cursor: pointer;
}

ul {
  list-style: none;
  padding: 0;
}

li.todo-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f9f9f9;
  padding: 10px;
  margin-bottom: 5px;
  border-radius: 5px;
}

li.todo-item span {
  cursor: pointer;
}

li.todo-item span.completed {
  text-decoration: line-through;
  color: grey;
}

.delete-btn {
  background: none;
  border: none;
  color: red;
  font-size: 16px;
  cursor: pointer;
}

.close-button {
  background: none;
  border: none;
  font-size: 16px;
  cursor: pointer;
}
</style>
