<template>
  <div class="error-page">
    <el-result icon="error" title="500" sub-title="服务器内部错误，请稍后重试">
      <template #extra>
        <el-button type="primary" @click="refresh">刷新页面</el-button>
        <el-button @click="goHome">返回首页</el-button>
      </template>
    </el-result>
  </div>
</template>

<script setup lang="ts">
/** 500 页面 - 服务器错误时显示 */
import { useRouter } from 'vue-router'

const router = useRouter()

function refresh() {
  window.location.reload()
}

function goHome() {
  router.push('/')
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
