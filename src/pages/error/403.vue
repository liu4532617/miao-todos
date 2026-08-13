<template>
  <div class="error-page">
    <el-result icon="warning" title="403" sub-title="抱歉，您没有权限访问该页面">
      <template #extra>
        <el-button type="primary" @click="goHome">返回首页</el-button>
        <el-button @click="goBack">返回上一页</el-button>
      </template>
    </el-result>
  </div>
</template>

<script setup lang="ts">
/** 403 页面 - 无权限时显示（后端返回 code=403 时跳转至此） */
import { useRouter } from 'vue-router'

const router = useRouter()

function goHome() {
  router.push('/')
}

function goBack() {
  router.back()
}
</script>

<style scoped>
.error-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
