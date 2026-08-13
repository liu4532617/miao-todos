import http from '../http/index'
import type { BackendRouteRecord } from '../types/route'
import type { SysMenu } from '../types/entity'
import { fallbackRouteConfig } from '../router/fallbackRoutes'

/**
 * 从后端获取当前用户可见的菜单树，并转换为前端路由表
 *
 * 后端接口: GET /sys/menu/menus (header 携带 token)
 * 返回格式: { code: 200, data: SysMenu[] }  SysMenu 含 children 树形结构
 * 管理员返回全部菜单，普通用户返回其角色关联的菜单
 *
 * 请求失败或无数据时，返回 fallbackRouteConfig 兜底
 */
export async function fetchRouteConfig(): Promise<BackendRouteRecord[]> {
  try {
    const res = await http.get<{ code: number; data: SysMenu[] }>('/sys/menu/menus')
    const menus = res.data?.data
    if (Array.isArray(menus) && menus.length > 0) {
      return menusToRouteRecords(menus)
    }
    console.warn('[routes] 后端返回的菜单数据为空，使用本地 fallback')
  } catch (err) {
    console.warn('[routes] 无法从后端加载菜单，使用本地 fallback', err)
  }
  return fallbackRouteConfig
}

/**
 * 后端菜单树 → 完整前端路由表
 *
 * 后端菜单是"目录/页面"两级结构：
 *   - type=1 目录（无 component，如 业务管理/系统管理）→ 不生成路由，但把目录名记到
 *     子菜单的 meta.group，供侧边栏分组渲染
 *   - type=2 菜单页面（有 path + component）→ 作为 layout 的子路由
 *   - type=3 按钮权限 → 不参与路由
 *
 * 最终结构：
 *   /login                       登录页（无布局）
 *   /        (layout)            主布局
 *     ├── ''                     工作台（path='/' 的一级菜单 → 默认子路由）
 *     ├── customer ...           各业务/系统页面（meta.group 记录所属分组）
 *   /404 /500                    错误页
 *   /:pathMatch(.*)*             兜底 404
 */
function menusToRouteRecords(menus: SysMenu[]): BackendRouteRecord[] {
  // 过滤按钮权限
  const pageMenus = menus.filter((menu) => menu.type !== 3)

  // 收集 layout 的子路由：目录展开 children，页面直接使用
  const layoutChildren: BackendRouteRecord[] = []

  for (const menu of pageMenus) {
    if (menu.path) {
      // 有 path 的一级菜单（如 工作台 '/'）→ 直接作为 layout 子路由
      layoutChildren.push(menuToRoute(menu))
    } else if (menu.children?.length) {
      // 无 path 的目录（如 业务管理/系统管理）→ 展开其子菜单，目录名记入 meta.group
      for (const child of menu.children) {
        if (child.type !== 3 && child.path) {
          layoutChildren.push(menuToRoute(child, menu.name))
        }
      }
    }
  }

  return [
    // 登录页（不含布局）
    { path: '/login', name: 'login', component: 'login/index' },

    // 主布局 + 后端菜单生成的子路由
    {
      path: '/',
      name: 'layout',
      component: 'layout/index',
      children: layoutChildren,
    },

    // 错误页
    { path: '/404', name: 'error404', component: 'error/404' },
    { path: '/500', name: 'error500', component: 'error/500' },

    // 通配符 404
    { path: '/:pathMatch(.*)*', name: 'notFound', component: 'error/404' },
  ]
}

/** 单个菜单项 → 路由记录 */
function menuToRoute(menu: SysMenu, group?: string): BackendRouteRecord {
  return {
    // 工作台 path='/' 作为 layout 默认子路由应转为 ''，其余去掉前导斜杠
    path: menu.path === '/' ? '' : (menu.path?.replace(/^\//, '') ?? ''),
    name: menu.name ?? `menu-${menu.id}`,
    component: menu.component ?? '',
    meta: {
      title: menu.name,
      icon: menu.icon,
      menuId: menu.id,
      // 所属目录分组（如 业务管理 / 系统管理），供侧边栏分组展示
      group,
    },
  }
}
