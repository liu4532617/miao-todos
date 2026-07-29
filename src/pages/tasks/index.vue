<template>
    <div>
        tasks
        <div><input type="text" ref="inputRef">
            <button @click="handAdd(inputRef?.value ?? '')">添加</button>
        </div>
        <div v-for="(task, i) in taskStore.tasks">
            <div>
                <router-link :to="{ name: 'task', params: { id: task.id } }">
                    {{ task.name }}</router-link>
                <button @click="taskStore.handDel(i)">删除</button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useTaskStore } from '../../stores/task';
const inputRef = ref<HTMLInputElement | null>(null);
const taskStore = useTaskStore();


const handAdd = (name: string) => {
    taskStore.handAdd(name);
    inputRef.value!.value = '';
}

</script>