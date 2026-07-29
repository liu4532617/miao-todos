<template>
  <div class="clue-page">
    <h2>线索管理</h2>
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="线索名称">
          <el-input v-model="query.name" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="query.status" placeholder="请选择" clearable>
            <el-option label="新建" value="new" />
            <el-option label="跟进中" value="follow" />
            <el-option label="已转化" value="converted" />
            <el-option label="已关闭" value="closed" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增线索</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="线索名称" />
      <el-table-column prop="source" label="来源" />
      <el-table-column prop="status" label="状态" />
      <el-table-column prop="createdAt" label="创建时间" />
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
/** 线索列表页 */
import { ref, reactive } from 'vue'

const query = reactive({ name: '', status: '' })
const list = ref<any[]>([])
const loading = ref(false)

function handleSearch() { /* TODO */ }
function handleReset() { query.name = ''; query.status = ''; handleSearch() }
function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
