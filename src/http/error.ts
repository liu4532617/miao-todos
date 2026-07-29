import type { AxiosError } from 'axios'

/** 自定义 API 错误 */
export class ApiError extends Error {
  code?: number
  status?: number

  constructor(
    message: string,
    code?: number,
    status?: number,
  ) {
    super(message)
    this.name = 'ApiError'
    this.code = code
    this.status = status
  }
}

/** 根据 HTTP 状态码获取中文错误消息 */
const STATUS_MESSAGES: Record<number, string> = {
  400: '请求参数错误',
  401: '未登录，请重新登录',
  403: '无权限访问',
  404: '请求的资源不存在',
  500: '服务器内部错误',
  502: '网关错误',
  503: '服务暂不可用',
}

/** 统一提取错误信息 */
export function getErrorMessage(err: unknown): string {
  if (err instanceof ApiError) {
    return err.message
  }

  const axiosErr = err as AxiosError

  if (axiosErr.response) {
    const status = axiosErr.response.status
    return STATUS_MESSAGES[status] || `请求失败 (${status})`
  }

  if (axiosErr.request) {
    return '网络连接失败，请检查网络'
  }

  return '发生未知错误'
}
