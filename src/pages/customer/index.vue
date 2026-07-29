<template>
  <div class="customer-page">
    <h2>客户管理</h2>
    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="客户名称">
          <el-input v-model="query.name" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 表格工具栏 -->
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增客户</el-button>
    </div>

    <!-- 客户列表 -->
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="客户名称" />
      <el-table-column prop="phone" label="联系电话" />
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
/** 客户列表页 */
import { ref, reactive } from 'vue'

/** 搜索条件 */
const query = reactive({ name: '' })

/** 列表数据 */
const list = ref<{ id: number; name: string; phone: string; createdAt: string }[]>([])
const loading = ref(false)

function handleSearch() {
  // TODO: 对接后端接口
}

function handleReset() {
  query.name = ''
  handleSearch()
}

function handleAdd() {
  // TODO: 弹出新增对话框
}
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
