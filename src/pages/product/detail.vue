<template>
  <div class="product-detail">
    <h2>产品详情</h2>
    <el-descriptions :column="2" border>
      <el-descriptions-item label="产品ID">{{ id }}</el-descriptions-item>
      <el-descriptions-item label="产品名称">--</el-descriptions-item>
      <el-descriptions-item label="分类">--</el-descriptions-item>
      <el-descriptions-item label="价格">--</el-descriptions-item>
      <el-descriptions-item label="库存">--</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<script setup lang="ts">
/** 产品详情页 */
import { useRoute } from 'vue-router'
const route = useRoute()
const id = route.params.id as string
</script>

<style scoped>
h2 { margin-bottom: 16px; }
</style>
