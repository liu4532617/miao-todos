<template>
  <div class="user-page">
    <h2>用户管理</h2>
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="用户名">
          <el-input v-model="query.username" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="query.status" placeholder="请选择" clearable>
            <el-option label="启用" value="active" />
            <el-option label="禁用" value="disabled" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增用户</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="nickname" label="昵称" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column prop="role" label="角色" />
      <el-table-column prop="status" label="状态" />
      <el-table-column label="操作" width="220" fixed="right">
        <template #default>
          <el-button type="primary" link>编辑</el-button>
          <el-button type="danger" link>删除</el-button>
          <el-button type="warning" link>重置密码</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 用户管理 - 系统用户列表与维护 */
import { ref, reactive } from 'vue'

const query = reactive({ username: '', status: '' })
const list = ref<any[]>([])
const loading = ref(false)

function handleSearch() { /* TODO */ }
function handleReset() { query.username = ''; query.status = ''; handleSearch() }
function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
