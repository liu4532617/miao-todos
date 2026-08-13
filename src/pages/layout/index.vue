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
        <!-- 无分组菜单（如 工作台）直接展示 -->
        <el-menu-item v-for="item in topLevelItems" :key="item.path" :index="'/' + item.path">
          <el-icon v-if="item.meta?.icon">
            <component :is="resolveIcon(item.meta.icon)" />
          </el-icon>
          <span>{{ item.meta?.title }}</span>
        </el-menu-item>

        <!-- 按目录分组（如 业务管理 / 系统管理） -->
        <el-sub-menu v-for="group in groups" :key="group" :index="group">
          <template #title>
            <span>{{ group }}</span>
          </template>
          <el-menu-item
            v-for="item in groupedItems[group]"
            :key="item.path"
            :index="'/' + item.path"
          >
            <span>{{ item.meta?.title }}</span>
          </el-menu-item>
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
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import type { Component } from 'vue'
import type { BackendRouteRecord } from '../../types/route'

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

/** 从路由表取出 layout 的子路由（即后端菜单生成的路由） */
const layoutChildren = computed<BackendRouteRecord[]>(() => {
  const layout = router.options.routes.find((r) => r.path === '/')
  return ((layout?.children ?? []) as unknown) as BackendRouteRecord[]
})

/** 无分组菜单（工作台等一级页面） */
const topLevelItems = computed(() =>
  layoutChildren.value.filter((item) => !item.meta?.group),
)

/** 所有分组名（业务管理 / 系统管理 等），保持原有顺序 */
const groups = computed(() => {
  const seen = new Set<string>()
  const result: string[] = []
  for (const item of layoutChildren.value) {
    const group = item.meta?.group
    if (typeof group === 'string' && !seen.has(group)) {
      seen.add(group)
      result.push(group)
    }
  }
  return result
})

/** 按分组归类：{ 业务管理: [路由...], 系统管理: [路由...] } */
const groupedItems = computed<Record<string, BackendRouteRecord[]>>(() => {
  const map: Record<string, BackendRouteRecord[]> = {}
  for (const item of layoutChildren.value) {
    const group = item.meta?.group
    if (typeof group === 'string') {
      ;(map[group] ??= []).push(item)
    }
  }
  return map
})

/** 根据图标名解析 Element Plus 图标组件（如 'Odometer' → <Odometer />） */
function resolveIcon(name: unknown): Component | undefined {
  if (typeof name !== 'string' || !name) return undefined
  const icons = ElementPlusIconsVue as Record<string, Component>
  return icons[name]
}

/** 退出登录 */
function handleLogout() {
  localStorage.removeItem('token')
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
