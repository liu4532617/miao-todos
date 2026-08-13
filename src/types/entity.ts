/** ============ 认证相关 ============ */

/** 登录请求 */
export interface LoginRequest {
  username: string
  password: string
}

/** 登录响应 */
export interface LoginResponse {
  token: string
  userId: number
  username: string
  nickname: string
}

/** ============ 系统模块 ============ */

/** 用户 */
export interface SysUser {
  id?: number
  username: string
  password?: string
  nickname?: string
  email?: string
  phone?: string
  avatar?: string
  status?: number
  createTime?: string
  updateTime?: string
}

/** 角色 */
export interface SysRole {
  id?: number
  name: string
  code: string
  description?: string
  status?: number
  sort?: number
  createTime?: string
  updateTime?: string
}

/** 菜单 */
export interface SysMenu {
  id?: number
  parentId?: number
  name: string
  icon?: string
  path?: string
  component?: string
  permission?: string
  type?: number
  sort?: number
  status?: number
  createTime?: string
  updateTime?: string
  /** 子菜单（树形结构） */
  children?: SysMenu[]
}

/** 权限 */
export interface SysPermission {
  id?: number
  name: string
  code: string
  description?: string
  createTime?: string
  updateTime?: string
}

/** ============ CRM 模块 ============ */

/** 客户 */
export interface CrmCustomer {
  id?: number
  name: string
  phone?: string
  email?: string
  company?: string
  address?: string
  source?: string
  level?: number
  status?: number
  ownerId?: number
  remark?: string
  createTime?: string
  updateTime?: string
}
