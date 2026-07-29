<template>
  <div class="customer-detail">
    <h2>客户详情</h2>
    <el-descriptions :column="2" border>
      <el-descriptions-item label="客户ID">{{ id }}</el-descriptions-item>
      <el-descriptions-item label="客户名称">--</el-descriptions-item>
      <el-descriptions-item label="联系电话">--</el-descriptions-item>
      <el-descriptions-item label="创建时间">--</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<script setup lang="ts">
/** 客户详情页 */
import { useRoute } from 'vue-router'

const route = useRoute()
const id = route.params.id as string
</script>

<style scoped>
h2 { margin-bottom: 16px; }
</style>
