<template>
  <div class="menu-page">
    <h2>菜单资源管理</h2>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增菜单</el-button>
    </div>
    <el-table
      :data="list"
      border
      stripe
      row-key="id"
      default-expand-all
      :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
      v-loading="loading"
    >
      <el-table-column prop="name" label="菜单名称" />
      <el-table-column prop="icon" label="图标" />
      <el-table-column prop="path" label="路由路径" />
      <el-table-column prop="component" label="组件路径" />
      <el-table-column prop="sort" label="排序" width="80" />
      <el-table-column prop="status" label="状态" width="80" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default>
          <el-button type="primary" link>编辑</el-button>
          <el-button type="primary" link>新增子菜单</el-button>
          <el-button type="danger" link>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 菜单资源管理 - 管理后台侧边栏菜单的层级结构 */
import { ref } from 'vue'

const list = ref<any[]>([])
const loading = ref(false)

function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
