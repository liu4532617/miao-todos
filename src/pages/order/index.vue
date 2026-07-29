<template>
  <div class="order-page">
    <h2>订单管理</h2>
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="订单编号">
          <el-input v-model="query.orderNo" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="query.status" placeholder="请选择" clearable>
            <el-option label="待付款" value="pending" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新建订单</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="orderNo" label="订单编号" width="180" />
      <el-table-column prop="customerName" label="客户" />
      <el-table-column prop="totalAmount" label="金额" />
      <el-table-column prop="status" label="状态" />
      <el-table-column prop="createdAt" label="创建时间" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default>
          <el-button type="primary" link>详情</el-button>
          <el-button type="danger" link>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 订单列表页 */
import { ref, reactive } from 'vue'

const query = reactive({ orderNo: '', status: '' })
const list = ref<any[]>([])
const loading = ref(false)

function handleSearch() { /* TODO */ }
function handleReset() { query.orderNo = ''; query.status = ''; handleSearch() }
function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
