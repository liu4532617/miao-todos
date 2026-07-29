<template>
  <div class="permission-page">
    <h2>权限管理</h2>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增权限</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="权限名称" />
      <el-table-column prop="code" label="权限标识" />
      <el-table-column prop="description" label="描述" />
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
/** 权限管理 - 系统权限点定义 */
import { ref } from 'vue'

const list = ref<any[]>([])
const loading = ref(false)

function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
