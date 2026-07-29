<template>
  <div class="dashboard">
    <h2>工作台</h2>
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-cards">
      <el-col :span="6" v-for="item in stats" :key="item.label">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-value">{{ item.value }}</div>
          <div class="stat-label">{{ item.label }}</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
/** 工作台 - 首页概览面板 */

/** 统计数据（TODO: 对接真实接口） */
const stats = [
  { label: '客户总数', value: 0 },
  { label: '待办任务', value: 0 },
  { label: '跟进线索', value: 0 },
  { label: '本月订单', value: 0 },
]
</script>

<style scoped>
.dashboard h2 {
  margin-bottom: 20px;
}

.stat-cards {
  margin-bottom: 20px;
}

.stat-card {
  text-align: center;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #409eff;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 8px;
}
</style>
