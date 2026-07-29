<template>
  <div class="order-detail">
    <h2>订单详情</h2>
    <el-descriptions :column="2" border>
      <el-descriptions-item label="订单编号">{{ id }}</el-descriptions-item>
      <el-descriptions-item label="客户">--</el-descriptions-item>
      <el-descriptions-item label="金额">--</el-descriptions-item>
      <el-descriptions-item label="状态">--</el-descriptions-item>
      <el-descriptions-item label="创建时间" :span="2">--</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<script setup lang="ts">
/** 订单详情页 */
import { useRoute } from 'vue-router'
const route = useRoute()
const id = route.params.id as string
</script>

<style scoped>
h2 { margin-bottom: 16px; }
</style>
