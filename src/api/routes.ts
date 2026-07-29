import http from '../http/index'
import type { BackendRouteRecord } from '../types/route'
import { fallbackRouteConfig } from '../router/fallbackRoutes'

/**
 * 从后端获取路由配置
 *
 * 约定后端响应格式：
 *   { code: 0, data: BackendRouteRecord[] }
 *
 * 请求失败或无数据时，返回 fallbackRouteConfig 兜底
 */
export async function fetchRouteConfig(): Promise<BackendRouteRecord[]> {
  try {
    const res = await http.get<{ code: number; data: BackendRouteRecord[] }>('/routes')
    if (res.data && 'data' in res.data && Array.isArray(res.data.data) && res.data.data.length > 0) {
      return res.data.data
    }
    console.warn('[routes] 后端返回的路由数据为空，使用本地 fallback')
  } catch (err) {
    console.warn('[routes] 无法从后端加载路由，使用本地 fallback', err)
  }
  return fallbackRouteConfig
}
