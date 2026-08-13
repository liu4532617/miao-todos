import http from '../http/index'
import type { ApiResponse } from '../http/types'
import type { LoginRequest, LoginResponse, SysUser } from '../types/entity'

/** 认证接口前缀（对应后端 /api/auth） */
const BASE = '/auth'

/** 登录 - 成功后返回 token（后端缓存在服务器内存 Map 中） */
export function loginApi(data: LoginRequest): Promise<LoginResponse> {
  return http
    .post<ApiResponse<LoginResponse>>(BASE + '/login', data)
    .then((res) => res.data.data)
}

/** 登出 - 从服务器缓存移除 token */
export function logoutApi(): Promise<void> {
  return http.post<ApiResponse<null>>(BASE + '/logout').then(() => undefined)
}

/** 获取当前登录用户信息（header 传 token） */
export function fetchCurrentUser(): Promise<SysUser> {
  return http.get<ApiResponse<SysUser>>(BASE + '/info').then((res) => res.data.data)
}

/** 当前在线人数（调试用） */
export function fetchOnlineCount(): Promise<number> {
  return http.get<ApiResponse<number>>(BASE + '/online').then((res) => res.data.data)
}
