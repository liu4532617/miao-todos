<template>
  <div class="role-page">
    <h2>角色管理</h2>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增角色</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="角色名称" />
      <el-table-column prop="code" label="角色编码" />
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="userCount" label="用户数" />
      <el-table-column prop="status" label="状态" />
      <el-table-column label="操作" width="260" fixed="right">
        <template #default>
          <el-button type="primary" link>编辑</el-button>
          <el-button type="primary" link>分配权限</el-button>
          <el-button type="danger" link>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 角色管理 - 系统角色定义与权限分配 */
import { ref } from 'vue'

const list = ref<any[]>([])
const loading = ref(false)

function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
