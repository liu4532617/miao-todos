import http from '../http/index'
import type { ApiResponse } from '../http/types'
import type { SysMenu, SysPermission, SysRole, SysUser } from '../types/entity'

/** ============ 用户管理 (后端 /api/sys/user) ============ */
export const userApi = {
  /** 用户列表（支持条件过滤） */
  list(params?: Partial<SysUser>): Promise<SysUser[]> {
    return http
      .get<ApiResponse<SysUser[]>>('/sys/user/list', { params })
      .then((res) => res.data.data)
  },

  /** 用户详情 */
  detail(id: number): Promise<SysUser> {
    return http.get<ApiResponse<SysUser>>(`/sys/user/${id}`).then((res) => res.data.data)
  },

  /** 新增用户（密码会被后端 BCrypt 加密） */
  add(data: SysUser): Promise<void> {
    return http.post<ApiResponse<null>>('/sys/user', data).then(() => undefined)
  },

  /** 更新用户 */
  update(data: SysUser): Promise<void> {
    return http.put<ApiResponse<null>>('/sys/user', data).then(() => undefined)
  },

  /** 删除用户 */
  remove(id: number): Promise<void> {
    return http.delete<ApiResponse<null>>(`/sys/user/${id}`).then(() => undefined)
  },
}

/** ============ 角色管理 (后端 /api/sys/role) ============ */
export const roleApi = {
  list(params?: Partial<SysRole>): Promise<SysRole[]> {
    return http
      .get<ApiResponse<SysRole[]>>('/sys/role/list', { params })
      .then((res) => res.data.data)
  },

  detail(id: number): Promise<SysRole> {
    return http.get<ApiResponse<SysRole>>(`/sys/role/${id}`).then((res) => res.data.data)
  },

  add(data: SysRole): Promise<void> {
    return http.post<ApiResponse<null>>('/sys/role', data).then(() => undefined)
  },

  update(data: SysRole): Promise<void> {
    return http.put<ApiResponse<null>>('/sys/role', data).then(() => undefined)
  },

  remove(id: number): Promise<void> {
    return http.delete<ApiResponse<null>>(`/sys/role/${id}`).then(() => undefined)
  },
}

/** ============ 菜单管理 (后端 /api/sys/menu) ============ */
export const menuApi = {
  list(params?: Partial<SysMenu>): Promise<SysMenu[]> {
    return http
      .get<ApiResponse<SysMenu[]>>('/sys/menu/list', { params })
      .then((res) => res.data.data)
  },

  detail(id: number): Promise<SysMenu> {
    return http.get<ApiResponse<SysMenu>>(`/sys/menu/${id}`).then((res) => res.data.data)
  },

  /** 子菜单列表 */
  listByParentId(parentId: number): Promise<SysMenu[]> {
    return http
      .get<ApiResponse<SysMenu[]>>(`/sys/menu/parent/${parentId}`)
      .then((res) => res.data.data)
  },

  /** 当前用户菜单（树形） */
  listMyMenus(): Promise<SysMenu[]> {
    return http.get<ApiResponse<SysMenu[]>>('/sys/menu/menus').then((res) => res.data.data)
  },

  add(data: SysMenu): Promise<void> {
    return http.post<ApiResponse<null>>('/sys/menu', data).then(() => undefined)
  },

  update(data: SysMenu): Promise<void> {
    return http.put<ApiResponse<null>>('/sys/menu', data).then(() => undefined)
  },

  remove(id: number): Promise<void> {
    return http.delete<ApiResponse<null>>(`/sys/menu/${id}`).then(() => undefined)
  },
}

/** ============ 权限管理 (后端 /api/sys/permission) ============ */
export const permissionApi = {
  list(params?: Partial<SysPermission>): Promise<SysPermission[]> {
    return http
      .get<ApiResponse<SysPermission[]>>('/sys/permission/list', { params })
      .then((res) => res.data.data)
  },

  detail(id: number): Promise<SysPermission> {
    return http
      .get<ApiResponse<SysPermission>>(`/sys/permission/${id}`)
      .then((res) => res.data.data)
  },

  add(data: SysPermission): Promise<void> {
    return http
      .post<ApiResponse<null>>('/sys/permission', data)
      .then(() => undefined)
  },

  update(data: SysPermission): Promise<void> {
    return http
      .put<ApiResponse<null>>('/sys/permission', data)
      .then(() => undefined)
  },

  remove(id: number): Promise<void> {
    return http
      .delete<ApiResponse<null>>(`/sys/permission/${id}`)
      .then(() => undefined)
  },
}
