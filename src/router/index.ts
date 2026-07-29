import { createRouter, createWebHistory } from 'vue-router'
import { fetchRouteConfig } from '../api/routes'
import { backendRoutesToRecords } from './dynamicRoutes'

/**
 * 先获取路由配置，再创建路由器
 * 保证路由器创建时就带有完整的路由表
 */
export async function setupAndGetRouter() {
  const config = await fetchRouteConfig()
  const routes = backendRoutesToRecords(config)

  return createRouter({
    history: createWebHistory(),
    routes,
  })
}
