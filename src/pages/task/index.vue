<template>
    <div>
        <div> task for name:{{ task?.name }}</div>
        <div> id:{{ task?.id }}</div>
    </div>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router';
import { userCurrentTask } from '../../composible/userCurentTask';

const route = useRoute();
const taskId = Number(route.params.id);
const task = userCurrentTask(taskId);

</script>