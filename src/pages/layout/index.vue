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
        <!-- 动态菜单：无分组的顶层菜单项 -->
        <el-menu-item v-for="item in topItems" :key="item.name" :index="menuPath(item)">
          <el-icon><component :is="iconFor(item)" /></el-icon>
          <span>{{ item.meta?.title }}</span>
        </el-menu-item>

        <!-- 动态菜单：按 meta.group 分组的子菜单 -->
        <el-sub-menu v-for="(items, group) in groupedItems" :key="group" :index="group">
          <template #title>
            <el-icon><component :is="iconForGroup(group)" /></el-icon>
            <span>{{ group }}</span>
          </template>
          <el-menu-item v-for="item in items" :key="item.name" :index="menuPath(item)">
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
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  Odometer,
  Briefcase,
  Setting,
  Folder,
  Fold,
  Expand,
  UserFilled,
} from '@element-plus/icons-vue'
import type { BackendRouteRecord } from '../../types/route'
import { fetchRouteConfig } from '../../api/routes'

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

/* ========== 动态菜单（数据来自后端 /api/routes） ========== */
const menuItems = ref<BackendRouteRecord[]>([])

/** 无分组的顶层菜单项（如工作台） */
const topItems = computed(() => menuItems.value.filter((i) => !i.meta?.group))

/** 按 meta.group 分组的子菜单 */
const groupedItems = computed<Record<string, BackendRouteRecord[]>>(() => {
  const map: Record<string, BackendRouteRecord[]> = {}
  for (const item of menuItems.value) {
    const group = item.meta?.group as string | undefined
    if (group) {
      ;(map[group] ??= []).push(item)
    }
  }
  return map
})

/** child path 是相对路径，拼成菜单 index */
function menuPath(item: BackendRouteRecord) {
  return item.path ? `/${item.path}` : '/'
}

/** 菜单项图标（按名称匹配，缺省 Folder） */
function iconFor(item: BackendRouteRecord) {
  const title = item.meta?.title
  if (title === '工作台') return Odometer
  return Folder
}

/** 分组图标 */
function iconForGroup(group: string) {
  if (group === '业务管理') return Briefcase
  if (group === '系统管理') return Setting
  return Folder
}

onMounted(async () => {
  const config = await fetchRouteConfig()
  const layout = config.find((r) => r.name === 'layout')
  menuItems.value = layout?.children ?? []
})
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
