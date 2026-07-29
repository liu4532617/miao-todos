<template>
  <div class="product-page">
    <h2>产品管理</h2>
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="产品名称">
          <el-input v-model="query.name" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="query.category" placeholder="请选择" clearable>
            <el-option label="软件" value="software" />
            <el-option label="硬件" value="hardware" />
            <el-option label="服务" value="service" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增产品</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="产品名称" />
      <el-table-column prop="category" label="分类" />
      <el-table-column prop="price" label="价格" />
      <el-table-column prop="stock" label="库存" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default>
          <el-button type="primary" link>编辑</el-button>
          <el-button type="danger" link>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 产品列表页 */
import { ref, reactive } from 'vue'

const query = reactive({ name: '', category: '' })
const list = ref<any[]>([])
const loading = ref(false)

function handleSearch() { /* TODO */ }
function handleReset() { query.name = ''; query.category = ''; handleSearch() }
function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
