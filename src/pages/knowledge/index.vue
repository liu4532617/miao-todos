<template>
  <div class="knowledge-page">
    <h2>知识库</h2>
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="关键字">
          <el-input v-model="query.keyword" placeholder="搜索文章" clearable />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="query.category" placeholder="请选择" clearable>
            <el-option label="使用指南" value="guide" />
            <el-option label="常见问题" value="faq" />
            <el-option label="最佳实践" value="best-practice" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新建文章</el-button>
    </div>
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="category" label="分类" />
      <el-table-column prop="author" label="作者" />
      <el-table-column prop="createdAt" label="创建时间" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default>
          <el-button type="primary" link>查看</el-button>
          <el-button type="primary" link>编辑</el-button>
          <el-button type="danger" link>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup lang="ts">
/** 知识库列表页 */
import { ref, reactive } from 'vue'

const query = reactive({ keyword: '', category: '' })
const list = ref<any[]>([])
const loading = ref(false)

function handleSearch() { /* TODO */ }
function handleReset() { query.keyword = ''; query.category = ''; handleSearch() }
function handleAdd() { /* TODO */ }
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
