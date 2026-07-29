<template>
  <el-container class="layout-container">
    <!-- 侧边栏 -->
    <el-aside :width="isCollapse ? '64px' : '220px'" class="layout-aside">
      <div class="logo">
        <span v-if="!isCollapse">CRM 管理系统</span>
        <span v-else>CRM</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :collapse-transition="false"
        background-color="#001529"
        text-color="#ffffffbf"
        active-text-color="#ffffff"
        router
      >
        <!-- 工作台 -->
        <el-menu-item index="/">
          <el-icon><Odometer /></el-icon>
          <span>工作台</span>
        </el-menu-item>

        <!-- 业务模块 -->
        <el-sub-menu index="business">
          <template #title>
            <el-icon><Briefcase /></el-icon>
            <span>业务管理</span>
          </template>
          <el-menu-item index="/customer">客户管理</el-menu-item>
          <el-menu-item index="/clue">线索管理</el-menu-item>
          <el-menu-item index="/task-list">任务管理</el-menu-item>
          <el-menu-item index="/knowledge">知识库</el-menu-item>
          <el-menu-item index="/order">订单管理</el-menu-item>
          <el-menu-item index="/product">产品管理</el-menu-item>
        </el-sub-menu>

        <!-- 系统管理 -->
        <el-sub-menu index="system">
          <template #title>
            <el-icon><Setting /></el-icon>
            <span>系统管理</span>
          </template>
          <el-menu-item index="/system/user">用户管理</el-menu-item>
          <el-menu-item index="/system/role">角色管理</el-menu-item>
          <el-menu-item index="/system/permission">权限管理</el-menu-item>
          <el-menu-item index="/system/menu">菜单资源</el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>

    <!-- 右侧内容区 -->
    <el-container class="layout-main">
      <!-- 顶部栏 -->
      <el-header class="layout-header">
        <div class="header-left">
          <el-icon class="collapse-btn" @click="toggleCollapse">
            <Fold v-if="!isCollapse" />
            <Expand v-else />
          </el-icon>
        </div>
        <div class="header-right">
          <el-dropdown>
            <span class="user-info">
              <el-avatar :size="32" icon="UserFilled" />
              <span class="username">管理员</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 主内容 -->
      <el-main class="layout-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  Odometer,
  Briefcase,
  Setting,
  Fold,
  Expand,
  UserFilled,
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

/** 侧边栏是否折叠 */
const isCollapse = ref(false)

/** 切换侧边栏折叠状态 */
function toggleCollapse() {
  isCollapse.value = !isCollapse.value
}

/** 当前高亮的菜单项 */
const activeMenu = computed(() => route.path)

/** 退出登录 */
function handleLogout() {
  router.push('/login')
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.layout-aside {
  background-color: #001529;
  overflow-y: auto;
  transition: width 0.3s;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.layout-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
  padding: 0 20px;
}

.header-left {
  display: flex;
  align-items: center;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.username {
  font-size: 14px;
}

.layout-content {
  background-color: #f0f2f5;
  min-height: calc(100vh - 60px);
  padding: 20px;
}
</style>
