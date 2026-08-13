import axios from 'axios'
import type { AxiosInstance, InternalAxiosRequestConfig, AxiosResponse } from 'axios'
import { ApiError, getErrorMessage } from './error'
import type { ApiResponse } from './types'

/**
 * HTTP 请求实例
 *
 * 职责：
 *  - 统一 baseURL、超时、请求头
 *  - 请求拦截器：添加 token、loading 等
 *  - 响应拦截器：统一解包、统一错误处理
 */
const http: AxiosInstance = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
    timeout: 15_000,
    headers: { 'Content-Type': 'application/json' },
})

/* ========== 请求拦截器 ========== */
http.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
        // ── 统一添加 token（后端通过 header 名 token 获取）──
        const token = localStorage.getItem('token')
        if (token) {
            config.headers.token = token
        }
        return config
    },
    (error) => {
        return Promise.reject(error)
    },
)

/* ========== 响应拦截器 ========== */
http.interceptors.response.use(
  (response: AxiosResponse<ApiResponse>) => {
    const { data } = response

    // 情景一：后端统一包装成 { code, message, data }
    if (data && typeof data === 'object' && 'code' in data) {
      if (data.code === 0 || data.code === 200) {
        return response
      }

      // ── 按业务 code 跳转 ──
      if (data.code === 401) {
        // 未登录 / 登录过期 → 清除 token 并跳转登录页
        localStorage.removeItem('token')
        if (!window.location.pathname.startsWith('/login')) {
          window.location.href = '/login'
        }
      } else if (data.code === 403) {
        // 无权限 → 跳转无权限页
        if (!window.location.pathname.startsWith('/403')) {
          window.location.href = '/403'
        }
      }

      // 业务错误（如 token 过期、参数校验失败）
      throw new ApiError(data.message || '请求失败', data.code, response.status)
    }

    // 情景二：后端直接返回数据（无包装），透传
    return response
  },
    (error) => {
        const message = getErrorMessage(error)

        // ── 在此处统一处理错误 UI 提示 ──
        // ElMessage.error(message)

        console.error(`[HTTP Error] ${message}`)
        return Promise.reject(new ApiError(message))
    },
)

export default http
