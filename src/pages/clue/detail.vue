<template>
  <div class="clue-detail">
    <h2>线索详情</h2>
    <el-descriptions :column="2" border>
      <el-descriptions-item label="线索ID">{{ id }}</el-descriptions-item>
      <el-descriptions-item label="线索名称">--</el-descriptions-item>
      <el-descriptions-item label="来源">--</el-descriptions-item>
      <el-descriptions-item label="状态">--</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<script setup lang="ts">
/** 线索详情页 */
import { useRoute } from 'vue-router'
const route = useRoute()
const id = route.params.id as string
</script>

<style scoped>
h2 { margin-bottom: 16px; }
</style>
