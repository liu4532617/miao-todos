<template>
  <div class="knowledge-detail">
    <h2>文章详情</h2>
    <el-card>
      <template #header>
        <div class="article-header">
          <span class="article-title">文章标题</span>
          <span class="article-meta">作者：-- | 分类：--</span>
        </div>
      </template>
      <div class="article-content">
        <p>文章内容...</p>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
/** 知识库文章详情页 */
import { useRoute } from 'vue-router'
const route = useRoute()
const id = route.params.id as string
void id
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.article-header { display: flex; justify-content: space-between; align-items: center; }
.article-title { font-size: 18px; font-weight: bold; }
.article-meta { font-size: 13px; color: #909399; }
.article-content { line-height: 1.8; }
</style>
